# Recovery Notes — Olist Metabase Password Reset

## Context

The Olist project was deployed via Docker Compose but the project directory was lost (only Postgres data volumes survived). To recover the Metabase admin password, I had to reverse-engineer Metabase v0.62.1.4's authentication scheme.

## Findings

**1. Metabase uses Postgres as its application database.**

The handoff's claim that Metabase uses an H2 file database was wrong. The container env vars were:
```
MB_DB_TYPE=postgres
MB_DB_HOST=postgres
MB_DB_DBNAME=metabaseappdb
```

This is also why the `docker_pgdata` volume contains all dashboard/card state — it's not just the Olist data, it's also the Metabase internal state.

**2. Metabase uses a `salt + password` concatenation before bcrypt, NOT plain bcrypt.**

Found via bytecode analysis of `metabase.util.password$verify_password`:
```clojure
(bcrypt-verify (str salt password) hashed-password)
```

So the `password` column in `auth_identity.credentials` is `bcrypt(str(password_salt, plain_password))`, not just `bcrypt(plain_password)`.

**3. The authentication is in `auth_identity`, NOT `core_user.password`.**

This was the breakthrough. `core_user.password` is a legacy column from older Metabase versions; current authentication reads from `auth_identity.credentials` (a JSONB column). I had been updating the wrong table for ~45 minutes before finding this.

The schema:
```
auth_identity
  id            | integer
  user_id       | integer (FK -> core_user)
  provider      | varchar  ('password' for native login)
  credentials   | text  (JSON: {"password_hash": "$2a$...", "password_salt": "uuid"})
  provider_id   | varchar
  ...
```

**4. The CLI `reset-password` command is broken in Metabase v0.62.1.4.**

It writes a literal string `placeholder` to the `auth_identity.credentials` JSON (not a hash). The "OK" output is the new password hash stored in `reset_token`, which is also broken.

**5. Throttling is in-memory, not in DB.**

After repeated bad logins, you get "Too many attempts!" — restart the container to clear it.

## Recovery Procedure (What Actually Worked)

```bash
# 1. Bring up Postgres pointing at the surviving volume
docker run -d --name olist_postgres_recover \
  -e POSTGRES_USER=olist \
  -e POSTGRES_PASSWORD=devpassword \
  -e POSTGRES_DB=olist \
  -p 5432:5432 \
  -v docker_pgdata:/var/lib/postgresql/data \
  postgres:16

# 2. Generate the right bcrypt hash
python3 -c "
import bcrypt
salt = 'default'  # any string works as long as you remember it
password = 'Olist2026!Recover'
combined = (salt + password).encode('utf-8')
h = bcrypt.hashpw(combined, bcrypt.gensalt(10, prefix=b'2a'))
print(h.decode())
"
# Output: $2a$10$qu8WL11t80XNSe0bKozXDOyG6fxkV50yFUq.6RMwxWHKH.DKVJWHm

# 3. UPDATE auth_identity (NOT core_user)
NEW_HASH='$2a$10$qu8WL11t80XNSe0bKozXDOyG6fxkV50yFUq.6RMwxWHKH.DKVJWHm'
PGPASSWORD=devpassword psql -h localhost -U olist -d metabaseappdb -c "
UPDATE auth_identity
SET credentials = jsonb_build_object(
  'password_hash', '${NEW_HASH}',
  'password_salt', 'default'
)
WHERE user_id = 1 AND provider = 'password';
"

# 4. Bring up Metabase pointing at the new Postgres
docker run -d --name olist_metabase_recover \
  -e MB_DB_TYPE=postgres \
  -e MB_DB_HOST=host.docker.internal \
  -e MB_DB_PORT=5432 \
  -e MB_DB_DBNAME=metabaseappdb \
  -e MB_DB_USER=olist \
  -e MB_DB_PASS=devpassword \
  -p 3000:3000 \
  metabase/metabase:latest

# 5. Login via API to get session
curl -X POST http://localhost:3000/api/session \
  -H "Content-Type: application/json" \
  -d '{"username":"admin@olist.local","password":"Olist2026!Recover"}'
# Returns: {"id": "<session-uuid>"}
```

## Key Insight

If you have to do this in the future and you know the user has been active before:
1. Check `auth_identity` table, not `core_user.password`
2. Use jBCrypt-compatible format: `$2a$10$...` (NOT `$2b$`)
3. Hash is over `salt + password`, not just `password`
4. The CLI reset-password command is unreliable — do it via SQL

## What I Tried That Did NOT Work

- ❌ Python bcrypt with `$2b$` prefix — jBCrypt may not accept it
- ❌ Python bcrypt with no salt prefix — Python defaults to `$2b$`
- ❌ Updating `core_user.password` directly — that's a legacy column
- ❌ Setting only `password` without `password_salt` (defaults to literal `'default'` string)
- ❌ Metabase CLI `reset-password` command — writes broken hash in v0.62
- ❌ `password_salt = UUID` with `password = bcrypt(uuid + plain)` — works mathematically, but
  the CLI was writing to wrong column
- ❌ Restarting Metabase to clear in-memory rate limiting — necessary but not sufficient
