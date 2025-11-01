CREATE OR REPLACE TABLE proyek.tabel_analisa AS
WITH base_data AS (
  SELECT
    t.transaction_id,
    t.branch_id,
    kf_kantor.provinsi,
    p.product_id,
    p.product_name,
    p.price,
    t.discount_percentage,
    (t.price * (1 - t.discount_percentage)) AS nett_sales,
    CASE
      WHEN p.price <= 50000 THEN 0.10
      WHEN p.price <= 100000 THEN 0.15
      WHEN p.price <= 300000 THEN 0.20
      WHEN p.price <= 500000 THEN 0.25
      ELSE 0.30
    END AS persentase_gross_laba,
    (t.price * (1 - t.discount_percentage)) *
      CASE
        WHEN p.price <= 50000 THEN 0.10
        WHEN p.price <= 100000 THEN 0.15
        WHEN p.price <= 300000 THEN 0.20
        WHEN p.price <= 500000 THEN 0.25
        ELSE 0.30
      END AS nett_profit,
    t.rating,
    t.date
  FROM proyek.kf_transaction AS t
  JOIN proyek.kf_product AS p
    ON t.product_id = p.product_id
  JOIN proyek.kf_kantor AS kf_kantor
    ON t.branch_id = kf_kantor.branch_id
)
SELECT * FROM base_data;
