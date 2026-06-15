--
-- PostgreSQL database dump
--

\restrict rWv3cGGFz5HVCu7MgEJN8N8239OGnfU1ieuzl9BqW5J6iIMZX5Ox3dFuFOpgfme

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
-- Name: olist_raw; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA olist_raw;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: olist_customers; Type: TABLE; Schema: olist_raw; Owner: -
--

CREATE TABLE olist_raw.olist_customers (
    customer_id character varying(64) NOT NULL,
    customer_unique_id character varying(64) NOT NULL,
    customer_zip_code_prefix integer,
    customer_city character varying(128),
    customer_state character varying(4)
);


--
-- Name: olist_order_items; Type: TABLE; Schema: olist_raw; Owner: -
--

CREATE TABLE olist_raw.olist_order_items (
    order_id character varying(64) NOT NULL,
    order_item_id integer NOT NULL,
    product_id character varying(64) NOT NULL,
    seller_id character varying(64) NOT NULL,
    shipping_limit_date timestamp without time zone,
    price double precision,
    freight_value double precision
);


--
-- Name: olist_orders; Type: TABLE; Schema: olist_raw; Owner: -
--

CREATE TABLE olist_raw.olist_orders (
    order_id character varying(64) NOT NULL,
    customer_id character varying(64) NOT NULL,
    order_status character varying(32),
    order_purchase_timestamp timestamp without time zone,
    order_approved_at timestamp without time zone,
    order_delivered_carrier_date timestamp without time zone,
    order_delivered_customer_date timestamp without time zone,
    order_estimated_delivery_date timestamp without time zone
);


--
-- Name: olist_geolocation; Type: TABLE; Schema: olist_raw; Owner: -
--

CREATE TABLE olist_raw.olist_geolocation (
    geolocation_zip_code_prefix integer,
    geolocation_lat double precision,
    geolocation_lng double precision,
    geolocation_city character varying(128),
    geolocation_state character varying(4)
);


--
-- Name: olist_order_payments; Type: TABLE; Schema: olist_raw; Owner: -
--

CREATE TABLE olist_raw.olist_order_payments (
    order_id character varying(64) NOT NULL,
    payment_sequential integer NOT NULL,
    payment_type character varying(32),
    payment_installments integer,
    payment_value double precision
);


--
-- Name: olist_order_reviews; Type: TABLE; Schema: olist_raw; Owner: -
--

CREATE TABLE olist_raw.olist_order_reviews (
    review_id character varying(64) NOT NULL,
    order_id character varying(64) NOT NULL,
    review_score integer,
    review_comment_title character varying(256),
    review_comment_message text,
    review_creation_date timestamp without time zone,
    review_answer_timestamp timestamp without time zone
);


--
-- Name: olist_products; Type: TABLE; Schema: olist_raw; Owner: -
--

CREATE TABLE olist_raw.olist_products (
    product_id character varying(64) NOT NULL,
    product_category_name character varying(128),
    product_name_lenght integer,
    product_description_lenght integer,
    product_photos_qty integer,
    product_weight_g integer,
    product_length_cm integer,
    product_height_cm integer,
    product_width_cm integer
);


--
-- Name: olist_sellers; Type: TABLE; Schema: olist_raw; Owner: -
--

CREATE TABLE olist_raw.olist_sellers (
    seller_id character varying(64) NOT NULL,
    seller_zip_code_prefix integer,
    seller_city character varying(128),
    seller_state character varying(4)
);


--
-- Name: product_category_name_translation; Type: TABLE; Schema: olist_raw; Owner: -
--

CREATE TABLE olist_raw.product_category_name_translation (
    product_category_name character varying(128) NOT NULL,
    product_category_name_english character varying(128)
);


--
-- Name: olist_customers olist_customers_pkey; Type: CONSTRAINT; Schema: olist_raw; Owner: -
--

ALTER TABLE ONLY olist_raw.olist_customers
    ADD CONSTRAINT olist_customers_pkey PRIMARY KEY (customer_id);


--
-- Name: olist_order_items olist_order_items_pkey; Type: CONSTRAINT; Schema: olist_raw; Owner: -
--

ALTER TABLE ONLY olist_raw.olist_order_items
    ADD CONSTRAINT olist_order_items_pkey PRIMARY KEY (order_id, order_item_id);


--
-- Name: olist_order_payments olist_order_payments_pkey; Type: CONSTRAINT; Schema: olist_raw; Owner: -
--

ALTER TABLE ONLY olist_raw.olist_order_payments
    ADD CONSTRAINT olist_order_payments_pkey PRIMARY KEY (order_id, payment_sequential);


--
-- Name: olist_order_reviews olist_order_reviews_pkey; Type: CONSTRAINT; Schema: olist_raw; Owner: -
--

ALTER TABLE ONLY olist_raw.olist_order_reviews
    ADD CONSTRAINT olist_order_reviews_pkey PRIMARY KEY (review_id);


--
-- Name: olist_orders olist_orders_pkey; Type: CONSTRAINT; Schema: olist_raw; Owner: -
--

ALTER TABLE ONLY olist_raw.olist_orders
    ADD CONSTRAINT olist_orders_pkey PRIMARY KEY (order_id);


--
-- Name: olist_products olist_products_pkey; Type: CONSTRAINT; Schema: olist_raw; Owner: -
--

ALTER TABLE ONLY olist_raw.olist_products
    ADD CONSTRAINT olist_products_pkey PRIMARY KEY (product_id);


--
-- Name: olist_sellers olist_sellers_pkey; Type: CONSTRAINT; Schema: olist_raw; Owner: -
--

ALTER TABLE ONLY olist_raw.olist_sellers
    ADD CONSTRAINT olist_sellers_pkey PRIMARY KEY (seller_id);


--
-- Name: product_category_name_translation product_category_name_translation_pkey; Type: CONSTRAINT; Schema: olist_raw; Owner: -
--

ALTER TABLE ONLY olist_raw.product_category_name_translation
    ADD CONSTRAINT product_category_name_translation_pkey PRIMARY KEY (product_category_name);


--
-- Name: olist_order_items fk_order_items_orders; Type: FK CONSTRAINT; Schema: olist_raw; Owner: -
--

ALTER TABLE ONLY olist_raw.olist_order_items
    ADD CONSTRAINT fk_order_items_orders FOREIGN KEY (order_id) REFERENCES olist_raw.olist_orders(order_id);


--
-- Name: olist_order_items fk_order_items_products; Type: FK CONSTRAINT; Schema: olist_raw; Owner: -
--

ALTER TABLE ONLY olist_raw.olist_order_items
    ADD CONSTRAINT fk_order_items_products FOREIGN KEY (product_id) REFERENCES olist_raw.olist_products(product_id);


--
-- Name: olist_order_items fk_order_items_sellers; Type: FK CONSTRAINT; Schema: olist_raw; Owner: -
--

ALTER TABLE ONLY olist_raw.olist_order_items
    ADD CONSTRAINT fk_order_items_sellers FOREIGN KEY (seller_id) REFERENCES olist_raw.olist_sellers(seller_id);


--
-- Name: olist_order_payments fk_order_payments_orders; Type: FK CONSTRAINT; Schema: olist_raw; Owner: -
--

ALTER TABLE ONLY olist_raw.olist_order_payments
    ADD CONSTRAINT fk_order_payments_orders FOREIGN KEY (order_id) REFERENCES olist_raw.olist_orders(order_id);


--
-- Name: olist_order_reviews fk_order_reviews_orders; Type: FK CONSTRAINT; Schema: olist_raw; Owner: -
--

ALTER TABLE ONLY olist_raw.olist_order_reviews
    ADD CONSTRAINT fk_order_reviews_orders FOREIGN KEY (order_id) REFERENCES olist_raw.olist_orders(order_id);


--
-- Name: olist_orders fk_orders_customers; Type: FK CONSTRAINT; Schema: olist_raw; Owner: -
--

ALTER TABLE ONLY olist_raw.olist_orders
    ADD CONSTRAINT fk_orders_customers FOREIGN KEY (customer_id) REFERENCES olist_raw.olist_customers(customer_id);


--
-- PostgreSQL database dump complete
--

\unrestrict rWv3cGGFz5HVCu7MgEJN8N8239OGnfU1ieuzl9BqW5J6iIMZX5Ox3dFuFOpgfme

