-- create_dwh_schema.sql
-- Ganti schema/nama sesuai kebutuhan

-- 1. set search_path jika ingin schema khusus (opsional)
-- CREATE SCHEMA IF NOT EXISTS dwh;
-- SET search_path = dwh;

-- DROP existing (opsional, hati-hati: akan hapus data)
DROP TABLE IF EXISTS fact_sales CASCADE;
DROP TABLE IF EXISTS dim_payment CASCADE;
DROP TABLE IF EXISTS dim_date CASCADE;

-- 2. Dimension: dim_date
CREATE TABLE IF NOT EXISTS dim_date (
  date_id SERIAL PRIMARY KEY,
  order_date DATE UNIQUE,
  year INT,
  month INT,
  day INT,
  day_of_week INT
);

-- 3. Dimension: dim_payment
CREATE TABLE IF NOT EXISTS dim_payment (
  payment_id SERIAL PRIMARY KEY,
  payment_type VARCHAR(100) UNIQUE
);

-- 4. Fact table: fact_sales
CREATE TABLE IF NOT EXISTS fact_sales (
  fact_id   BIGSERIAL PRIMARY KEY,
  order_id  VARCHAR(100),
  date_id   INT REFERENCES dim_date(date_id),
  payment_id INT REFERENCES dim_payment(payment_id),
  price     NUMERIC,
  freight_value NUMERIC,
  total_value NUMERIC
);
