--
-- PostgreSQL database dump
--

\restrict pDTQpaib4jFcnhIqsoiRQQSkQGltvwPI9dbqzw1OcPBPwZz9i69K84fSJygSo2S

-- Dumped from database version 16.13 (Debian 16.13-1.pgdg13+1)
-- Dumped by pg_dump version 16.13 (Debian 16.13-1.pgdg13+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: olist_marts; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA olist_marts;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: mart_customer_orders; Type: TABLE; Schema: olist_marts; Owner: -
--

CREATE TABLE olist_marts.mart_customer_orders (
    customer_id character varying(64),
    customer_unique_id character varying(64),
    customer_city text,
    customer_state text,
    total_orders bigint,
    total_revenue double precision,
    avg_ticket double precision,
    first_order_date date,
    last_order_date date,
    recency_days integer,
    avg_review_score numeric,
    total_items_purchased bigint
);


--
-- Name: mart_monthly_revenue; Type: TABLE; Schema: olist_marts; Owner: -
--

CREATE TABLE olist_marts.mart_monthly_revenue (
    month timestamp with time zone,
    total_revenue double precision,
    order_count bigint,
    unique_customers bigint,
    avg_order_value double precision
);


--
-- Name: stg_customers; Type: VIEW; Schema: olist_marts; Owner: -
--

CREATE VIEW olist_marts.stg_customers AS
 WITH source AS (
         SELECT olist_customers.customer_id,
            olist_customers.customer_unique_id,
            olist_customers.customer_zip_code_prefix,
            olist_customers.customer_city,
            olist_customers.customer_state
           FROM olist_raw.olist_customers
        ), renamed AS (
         SELECT source.customer_id,
            source.customer_unique_id,
            source.customer_zip_code_prefix,
            TRIM(BOTH FROM source.customer_city) AS customer_city,
            upper(TRIM(BOTH FROM source.customer_state)) AS customer_state,
            CURRENT_TIMESTAMP AS _loaded_at
           FROM source
        )
 SELECT customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state,
    _loaded_at
   FROM renamed;


--
-- Name: stg_order_items; Type: VIEW; Schema: olist_marts; Owner: -
--

CREATE VIEW olist_marts.stg_order_items AS
 WITH source AS (
         SELECT olist_order_items.order_id,
            olist_order_items.order_item_id,
            olist_order_items.product_id,
            olist_order_items.seller_id,
            olist_order_items.shipping_limit_date,
            olist_order_items.price,
            olist_order_items.freight_value
           FROM olist_raw.olist_order_items
        ), renamed AS (
         SELECT source.order_id,
            source.order_item_id,
            source.product_id,
            source.seller_id,
            source.shipping_limit_date,
            source.price,
            source.freight_value,
            CURRENT_TIMESTAMP AS _loaded_at
           FROM source
        )
 SELECT order_id,
    order_item_id,
    product_id,
    seller_id,
    shipping_limit_date,
    price,
    freight_value,
    _loaded_at
   FROM renamed;


--
-- Name: stg_orders; Type: VIEW; Schema: olist_marts; Owner: -
--

CREATE VIEW olist_marts.stg_orders AS
 WITH source AS (
         SELECT olist_orders.order_id,
            olist_orders.customer_id,
            olist_orders.order_status,
            olist_orders.order_purchase_timestamp,
            olist_orders.order_approved_at,
            olist_orders.order_delivered_carrier_date,
            olist_orders.order_delivered_customer_date,
            olist_orders.order_estimated_delivery_date
           FROM olist_raw.olist_orders
        ), renamed AS (
         SELECT source.order_id,
            source.customer_id,
            source.order_status,
            source.order_purchase_timestamp,
            source.order_approved_at,
            source.order_delivered_carrier_date,
            source.order_delivered_customer_date,
            source.order_estimated_delivery_date,
            (source.order_purchase_timestamp)::date AS order_purchase_date,
            (source.order_approved_at)::date AS order_approved_date,
            (source.order_delivered_carrier_date)::date AS order_delivered_carrier_date_only,
            (source.order_delivered_customer_date)::date AS order_delivered_customer_date_only,
            (source.order_estimated_delivery_date)::date AS order_estimated_delivery_date_only,
                CASE
                    WHEN ((source.order_status)::text = 'canceled'::text) THEN true
                    ELSE false
                END AS is_canceled,
            CURRENT_TIMESTAMP AS _loaded_at
           FROM source
        )
 SELECT order_id,
    customer_id,
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date,
    order_purchase_date,
    order_approved_date,
    order_delivered_carrier_date_only,
    order_delivered_customer_date_only,
    order_estimated_delivery_date_only,
    is_canceled,
    _loaded_at
   FROM renamed;


--
-- PostgreSQL database dump complete
--

\unrestrict pDTQpaib4jFcnhIqsoiRQQSkQGltvwPI9dbqzw1OcPBPwZz9i69K84fSJygSo2S

