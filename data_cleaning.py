import pandas as pd
import numpy as np

ft = pd.read_csv('/content/kf_final_transaction.csv')
iv = pd.read_csv('/content/kf_inventory.csv')
kc = pd.read_csv('/content/kf_kantor_cabang.csv')
pr = pd.read_csv('/content/kf_product.csv')

# Cek apakah ada baris duplikat di setiap tabel
print("Jumlah baris duplikat pada tabel kf_final_transation:", ft.duplicated().sum())
print("Jumlah baris duplikat pada tabel kf_inventory:", iv.duplicated().sum())
print("Jumlah baris duplikat pada tabel kf_kantor_cabang:", kc.duplicated().sum())
print("Jumlah baris duplikat pada tabel kf_product:", pr.duplicated().sum())

# Cek null values pada setiap tabel
print("Null values pada tabel kf_final_transaction:\n", ft.isna().sum())
print("\nNull values pada tabel kf_inventory:\n", iv.isna().sum())
print("\nNull values pada tabel kf_kantor_cabang:\n", kc.isna().sum())
print("\nNull values pada tabel kf_product:\n", pr.isna().sum())

# Membuat function untuk mendeteksi outlier di kolom numerik pada setiap tabel
def detect_outliers_iqr(df, column):
    Q1 = df[column].quantile(0.25)
    Q3 = df[column].quantile(0.75)
    IQR = Q3 - Q1
    lower_bound = Q1 - 1.5 * IQR
    upper_bound = Q3 + 1.5 * IQR
    outliers = df[(df[column] < lower_bound) | (df[column] > upper_bound)]
    return outliers

# Cek outliers di tabel kf_final_transaction
print("\nOutliers di tabel kf_final_transaction:")
for col in ['price', 'discount_percentage', 'rating']:
    outliers = detect_outliers_iqr(ft, col)
    print(f"{col}: {len(outliers)} outlier")

# Cek outliers di tabel kf_inventory
print("\nOutliers di tabel kf_inventory:")
outliers = detect_outliers_iqr(iv, 'opname_stock')
print(f"opname_stock: {len(outliers)} outlier")

# Cek outliers di tabel kf_kantor_cabang
print("\nOutliers di tabel kf_kantor_cabang:")
outliers = detect_outliers_iqr(kc, 'rating')
print(f"rating: {len(outliers)} outlier")

# Tidak ada kolom numerik pada tabel kf_product sehingga tidak dilakukan pengecekan outlier.
print("\nTabel kf_product tidak memiliki kolom numerik.")
