```markdown
# 🧩 ETL Pipeline Penjualan Online (Real Data - Olist E-Commerce)

## 🎯 Tujuan
Membangun **pipeline ETL (Extract, Transform, Load)** yang mengambil data transaksi e-commerce **nyata** dari dataset Olist (Kaggle), membersihkan data menggunakan **Python (Pandas)**, lalu memuatnya ke **PostgreSQL** untuk dilakukan analisis SQL sederhana.

---

## 🧱 Arsitektur Pipeline

```

CSV (orders, payments, items)
│
▼
[Python + Pandas]
│
Cleaning & Join
│
▼
[PostgreSQL Database]
│
▼
[SQL Analysis]

```

---

## ⚙️ Tools & Teknologi

| Komponen | Deskripsi |
|-----------|------------|
| **Python** | Bahasa utama untuk ETL |
| **Pandas** | Manipulasi dan transformasi data |
| **SQLAlchemy** | Koneksi dan komunikasi ke PostgreSQL |
| **PostgreSQL** | Database untuk menyimpan hasil ETL |
| **psycopg2** | Driver PostgreSQL untuk Python |

---

## 📂 Struktur Folder

```

etl-pipeline-penjualan/
│
├── data/
│   ├── olist_orders_dataset.csv
│   ├── olist_order_payments_dataset.csv
│   ├── olist_order_items_dataset.csv
│
├── etl_pipeline.py
├── requirements.txt
└── README.md

````

---

## 🧩 Langkah ETL

### 1️⃣ Extract  
Menarik data dari tiga file CSV:
- `olist_orders_dataset.csv`
- `olist_order_payments_dataset.csv`
- `olist_order_items_dataset.csv`

### 2️⃣ Transform  
- Menggabungkan data berdasarkan `order_id`
- Menghapus duplikat dan nilai kosong
- Mengonversi kolom tanggal ke format datetime
- Menghitung kolom baru `total_nilai` = `payment_value` + `freight_value`

### 3️⃣ Load  
Menyimpan data hasil transformasi ke **tabel PostgreSQL** bernama `data_penjualan_online`.

---

## 💻 Kode Utama (`etl_pipeline.py`)

```python
import pandas as pd
from sqlalchemy import create_engine

# --------------------------
# 1️⃣ EXTRACT
# --------------------------
orders = pd.read_csv("data/olist_orders_dataset.csv")
payments = pd.read_csv("data/olist_order_payments_dataset.csv")
items = pd.read_csv("data/olist_order_items_dataset.csv")

# --------------------------
# 2️⃣ TRANSFORM
# --------------------------
df = orders.merge(payments, on="order_id", how="left")
df = df.merge(items, on="order_id", how="left")

df.dropna(subset=["payment_value", "price"], inplace=True)
df.drop_duplicates(inplace=True)

df["order_purchase_timestamp"] = pd.to_datetime(df["order_purchase_timestamp"])
df["total_nilai"] = df["payment_value"] + df["freight_value"]

final_df = df[[
    "order_id",
    "order_purchase_timestamp",
    "payment_type",
    "price",
    "freight_value",
    "total_nilai"
]]

# --------------------------
# 3️⃣ LOAD
# --------------------------
engine = create_engine("postgresql+psycopg2://postgres:password@localhost:5432/penjualan_db")
final_df.to_sql("data_penjualan_online", engine, if_exists="replace", index=False)

print("✅ ETL Pipeline selesai! Data berhasil dimuat ke PostgreSQL.")
````

---

## 🧠 SQL Query Analisis

### 1. Total Penjualan Berdasarkan Metode Pembayaran

```sql
SELECT payment_type, ROUND(SUM(total_nilai), 2) AS total_penjualan
FROM data_penjualan_online
GROUP BY payment_type
ORDER BY total_penjualan DESC;
```

### 2. Jumlah Transaksi per Bulan

```sql
SELECT DATE_TRUNC('month', order_purchase_timestamp) AS bulan,
       COUNT(order_id) AS jumlah_transaksi
FROM data_penjualan_online
GROUP BY bulan
ORDER BY bulan;
```

---

## 📊 Contoh Hasil Query

| payment_type | total_penjualan |
| ------------ | --------------: |
| credit_card  |   42,392,000.55 |
| boleto       |   18,102,430.23 |
| debit_card   |    2,200,430.00 |
| voucher      |      104,000.00 |

---

## 📸 Screenshot yang Disarankan

1. ✅ Terminal output ETL sukses
2. 🗄️ Tampilan tabel `data_penjualan_online` di PostgreSQL
3. 📊 Hasil query SQL di pgAdmin atau DBeaver

---

## 📦 Dataset

Dataset asli:
👉 [Brazilian E-Commerce Public Dataset by Olist (Kaggle)](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

---

## 🧰 Cara Menjalankan Project

### 1. Clone repository

```bash
git clone https://github.com/<username-kamu>/etl-pipeline-penjualan.git
cd etl-pipeline-penjualan
```

### 2. Install dependencies

```bash
pip install -r requirements.txt
```

### 3. Buat database di PostgreSQL

```sql
CREATE DATABASE penjualan_db;
```

### 4. Jalankan script ETL

```bash
python etl_pipeline.py
```

---

## 👤 Author

Dibuat oleh **[Ilyas Yanuar]**
💼 Calon **Data Engineer** yang menunjukkan kemampuan dalam:

* Data ingestion
* Data cleaning
* Data loading ke database relasional
* Analisis data dengan SQL

---