const { chromium } = require("/Users/nformenton/Dev/career-ops/node_modules/playwright");
const http = require("http");
const fs = require("fs");
const path = require("path");
const { URL } = require("url");

const METABASE_URL = "http://localhost:3000";
const USERNAME = "admin@olist.local";
const PASSWORD = "Olist2026!Recover";
const OUTPUT_DIR = "/Users/nformenton/Dev/herm/olist-bi-recovery/screenshots";

function postJson(url, body) {
  return new Promise((resolve, reject) => {
    const u = new URL(url);
    const opts = {
      hostname: u.hostname,
      port: u.port,
      path: u.pathname,
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Content-Length": Buffer.byteLength(body),
      },
    };
    const req = http.request(opts, (res) => {
      let data = "";
      res.on("data", (chunk) => (data += chunk));
      res.on("end", () => {
        if (res.statusCode >= 200 && res.statusCode < 300) {
          try {
            resolve(JSON.parse(data));
          } catch (e) {
            reject(new Error(`Bad JSON: ${data.slice(0, 200)}`));
          }
        } else {
          reject(new Error(`HTTP ${res.statusCode}: ${data.slice(0, 200)}`));
        }
      });
    });
    req.on("error", reject);
    req.write(body);
    req.end();
  });
}

async function captureDashboard(page, dashId, name) {
  console.log(`\n==> Dashboard ${dashId}: ${name}`);

  const consoleErrors = [];
  page.removeAllListeners("pageerror");
  page.removeAllListeners("console");
  page.on("pageerror", (e) => consoleErrors.push(`pageerror: ${e.message.slice(0, 200)}`));
  page.on("console", (msg) => {
    if (msg.type() === "error") {
      const text = msg.text();
      if (!text.includes("favicon") && !text.includes("manifest")) {
        consoleErrors.push(`console.error: ${text.slice(0, 200)}`);
      }
    }
  });

  // 1. Navigate (initial load uses default viewport)
  await page.goto(`${METABASE_URL}/dashboard/${dashId}`, {
    waitUntil: "domcontentloaded",
    timeout: 60000,
  });
  await page.waitForLoadState("networkidle", { timeout: 60000 });
  await page.waitForTimeout(3000);

  // 2. Click "Toggle sidebar" to hide the parameter sidebar
  const toggleBtn = page.locator('button[aria-label="Toggle sidebar"]').first();
  if (await toggleBtn.count() > 0) {
    console.log("  Hiding parameter sidebar");
    await toggleBtn.click();
    await page.waitForTimeout(2000);
  }

  // 3. Measure content height to choose a viewport height
  const contentHeight = await page.evaluate(() => {
    const main = document.querySelector("main");
    if (!main) return 2000;
    // Find all card containers and use the maximum bottom
    const cards = document.querySelectorAll('[data-testid^="dashcard"], .DashCard, [class*="DashCard"]');
    let maxBottom = 0;
    cards.forEach((el) => {
      const r = el.getBoundingClientRect();
      maxBottom = Math.max(maxBottom, r.bottom);
    });
    // Also check the dashboard element
    const dash = document.querySelector('[data-testid="dashboard"], [data-element-id="dashboard"]');
    if (dash) {
      maxBottom = Math.max(maxBottom, dash.getBoundingClientRect().bottom);
    }
    // Add header height (~52px) and some padding
    return Math.ceil(maxBottom) + 100;
  });
  console.log(`  Content height: ${contentHeight}px`);

  // 4. Resize viewport to fit the entire dashboard
  await page.setViewportSize({ width: 2560, height: contentHeight });
  await page.waitForTimeout(3000);

  // 5. Wait until all problem charts clear (max 60s)
  const startWait = Date.now();
  while (Date.now() - startWait < 60000) {
    const problemCount = await page
      .locator("text=/There was a problem displaying this chart/i")
      .count();
    if (problemCount === 0) break;
    console.log(`  Waiting for ${problemCount} problem chart(s)...`);
    await page.waitForTimeout(2000);
  }

  // 6. Scroll through to trigger any lazy-loaded charts
  const finalHeight = await page.evaluate(() => document.body.scrollHeight);
  for (let y = 0; y < finalHeight; y += 800) {
    await page.evaluate((scrollY) => window.scrollTo(0, scrollY), y);
    await page.waitForTimeout(400);
  }
  await page.evaluate(() => window.scrollTo(0, 0));
  await page.waitForTimeout(1500);

  // 7. Final check
  const dashCards = await page.locator('[data-testid^="dashcard"]').count();
  const problemCount = await page
    .locator("text=/There was a problem displaying this chart/i")
    .count();
  console.log(`  DashCards: ${dashCards}, Problem charts: ${problemCount}`);

  // 8. Take the full-page screenshot
  const filePath = path.join(OUTPUT_DIR, `${name}.png`);
  await page.screenshot({ path: filePath, fullPage: true });
  const stat = fs.statSync(filePath);
  console.log(`  Saved: ${filePath} (${(stat.size / 1024).toFixed(0)}KB)`);

  if (consoleErrors.length > 0) {
    console.log(`  Console errors: ${consoleErrors.length}`);
    for (const e of consoleErrors.slice(0, 3)) console.log(`    - ${e}`);
  }
}

async function main() {
  fs.mkdirSync(OUTPUT_DIR, { recursive: true });

  const loginData = await postJson(
    `${METABASE_URL}/api/session`,
    JSON.stringify({ username: USERNAME, password: PASSWORD })
  );
  const sessionId = loginData.id;
  console.log(`==> Logged in: ${sessionId}`);

  const browser = await chromium.launch({
    headless: true,
    executablePath:
      "/Users/nformenton/Library/Caches/ms-playwright/chromium-1217/chrome-mac-arm64/Google Chrome for Testing.app/Contents/MacOS/Google Chrome for Testing",
  });
  const context = await browser.newContext({
    viewport: { width: 2560, height: 1440 },
    deviceScaleFactor: 1,
  });
  await context.addCookies([
    {
      name: "metabase.SESSION",
      value: sessionId,
      domain: "localhost",
      path: "/",
      httpOnly: true,
      sameSite: "Lax",
    },
  ]);

  const page = await context.newPage();

  const dashboards = [
    { id: 1, name: "01_e-commerce_insights" },
    { id: 2, name: "02_executive_dashboard" },
    { id: 3, name: "03_customer_analytics_dashboard" },
    { id: 4, name: "04_operations_dashboard" },
  ];

  for (const dash of dashboards) {
    await captureDashboard(page, dash.id, dash.name);
  }

  await browser.close();
  console.log("\n==> Done");
}

main().catch((err) => {
  console.error("FATAL:", err);
  process.exit(1);
});
