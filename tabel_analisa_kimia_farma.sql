-- ====================================================================
-- TABEL ANALISA PENJUALAN DAN PROFIT KIMIA FARMA (2020–2023)
-- --------------------------------------------------------------------
-- Tujuan:
--   Membuat tabel analisa gabungan dari data transaksi, produk, 
--   dan kantor cabang untuk perhitungan nett sales, nett profit,
--   serta pengelompokan data per provinsi.
-- ====================================================================

CREATE OR REPLACE TABLE proyek.tabel_analisa AS

-- Gunakan CTE (Common Table Expression) untuk menyusun data dasar
WITH base_data AS (
  SELECT
    -- ID unik setiap transaksi
    t.transaction_id,
    
    -- ID cabang tempat transaksi dilakukan
    t.branch_id,
    
    -- Provinsi cabang dari tabel kantor
    kf_kantor.provinsi,
    
    -- Informasi produk
    p.product_id,
    p.product_name,
    p.price,
    
    -- Persentase diskon dari transaksi
    t.discount_percentage,
    
    -- Perhitungan Nett Sales:
    -- Harga produk dikalikan (1 - diskon)
    (t.price * (1 - t.discount_percentage)) AS nett_sales,
    
    -- Persentase Gross Laba berdasarkan kisaran harga produk
    CASE
      WHEN p.price <= 50000 THEN 0.10       -- 10% untuk harga ≤ 50.000
      WHEN p.price <= 100000 THEN 0.15      -- 15% untuk harga ≤ 100.000
      WHEN p.price <= 300000 THEN 0.20      -- 20% untuk harga ≤ 300.000
      WHEN p.price <= 500000 THEN 0.25      -- 25% untuk harga ≤ 500.000
      ELSE 0.30                             -- 30% untuk harga > 500.000
    END AS persentase_gross_laba,
    
    -- Perhitungan Nett Profit:
    -- Nett Sales dikalikan dengan Persentase Gross Laba
    (t.price * (1 - t.discount_percentage)) *
      CASE
        WHEN p.price <= 50000 THEN 0.10
        WHEN p.price <= 100000 THEN 0.15
        WHEN p.price <= 300000 THEN 0.20
        WHEN p.price <= 500000 THEN 0.25
        ELSE 0.30
      END AS nett_profit,
    
    -- Rating transaksi dari tabel transaksi
    t.rating,
    
    -- Tanggal transaksi
    t.date

  -- Join antar tabel
  FROM proyek.kf_transaction AS t
  JOIN proyek.kf_product AS p
    ON t.product_id = p.product_id
  JOIN proyek.kf_kantor AS kf_kantor
    ON t.branch_id = kf_kantor.branch_id
)

-- Output akhir: seluruh kolom dari base_data
SELECT * 
FROM base_data;

