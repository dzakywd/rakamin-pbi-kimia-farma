-- Membuat tabel baru untuk kebutuhan Dashboard Performance Analytics
CREATE TABLE kimia_farma.kf_analysis_table AS
  SELECT
    -- Mengambil data transaksi utama
    ft.transaction_id,
    ft.date,
    ft.branch_id,
  
    -- Menambahkan informasi cabang (nama, kota, provinsi, dan rating)
    kc.branch_name,
    kc.kota,
    kc.provinsi,
    kc.rating AS rating_cabang, -- Alias digunakan untuk membedakan rating cabang dan rating transaksi
    
    -- Menambahkan informasi pelanggan dan produk
    ft.customer_name,
    ft.product_id,
    p.product_name,
    p.price AS actual_price, -- Alias untuk memperjelas konteks harga asli produk
    ft.discount_percentage,
    
    -- Menentukan persentase laba kotor berdasarkan rentang harga produk
    CASE
      WHEN p.price <= 50000 THEN 0.1
      WHEN p.price <= 100000 THEN 0.15
      WHEN p.price <= 300000 THEN 0.2
      WHEN p.price <= 500000 THEN 0.25
      ELSE 0.3
    END AS persentase_gross_laba,
    
    -- Menghitung nilai penjualan bersih setelah diskon
    p.price - (p.price * ft.discount_percentage) AS nett_sales, -- Menggunakan alias untuk memberi nama kolom yang belum ada sebelumnya
    
    -- Menghitung laba bersih per transaksi berdasarkan penjualan bersih dan persentase laba
    (p.price - (p.price * ft.discount_percentage)) * (
      CASE
        WHEN p.price <= 50000 THEN 0.1
        WHEN p.price <= 100000 THEN 0.15
        WHEN p.price <= 300000 THEN 0.2
        WHEN p.price <= 500000 THEN 0.25
        ELSE 0.3
      END
    ) AS nett_profit,

    -- Menambahkan rating dari setiap transaksi
    ft.rating AS rating_transaksi -- Alias digunakan untuk membedakan rating cabang dan rating transaksi

FROM
  `rakamin-kf-analytics-475609.kimia_farma.kf_final_transaction` AS ft -- Menggunakan alias untuk mempermudah pemanggilan tabel dalam query
  JOIN `rakamin-kf-analytics-475609.kimia_farma.kf_kantor_cabang` AS kc ON ft.branch_id = kc.branch_id -- Menggabungkan data cabang berdasarkan ID cabang
  JOIN `rakamin-kf-analytics-475609.kimia_farma.kf_product` AS p ON ft.product_id = p.product_id -- Menggabungkan data produk berdasarkan ID produk
