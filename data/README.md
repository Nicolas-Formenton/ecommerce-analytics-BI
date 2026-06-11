# Data: Olist Brazilian E-Commerce Public Dataset

## Data Source

This dataset is the **Brazilian E-Commerce Public Dataset by Olist**, hosted on Kaggle:

- **Kaggle**: [olistbr/brazilian-ecommerce](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
- **License**: [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/)
- **Attribution**: Data provided by [Olist](https://olist.com), the largest department store in Brazilian marketplaces.

> **Important**: The dataset is licensed under **CC BY-NC-SA 4.0** (Non-Commercial — ShareAlike). You may use it for non-commercial purposes only, and any derivative work must be shared under the same license. See [`DATA_LICENSE.md`](../DATA_LICENSE.md) for the full legal text.

## Dataset Overview

| Property | Value |
|----------|-------|
| Timeframe | 2016–2018 |
| Orders | ~96,000+ |
| CSVs | 9 files |
| Size | ~100 MB (compressed), ~200 MB (uncompressed) |
| Coverage | All states in Brazil |
| Attributes | Customer info, product details, payment info, reviews, geolocation |

## File Listing

| # | File | Description |
|---|------|-------------|
| 1 | `olist_customers_dataset.csv` | Customer identifiers, city, and state — one row per order. |
| 2 | `olist_geolocation_dataset.csv` | Brazilian ZIP code lat/lng coordinates. |
| 3 | `olist_order_items_dataset.csv` | Items within each order: product, seller, price, freight. |
| 4 | `olist_order_payments_dataset.csv` | Payment methods, installments, and transaction values. |
| 5 | `olist_order_reviews_dataset.csv` | Review scores (1–5), titles, and free-text comments. |
| 6 | `olist_orders_dataset.csv` | Order status and timestamps (purchase→approval→delivery→estimated). |
| 7 | `olist_products_dataset.csv` | Product category, weight, dimensions, and photo count. |
| 8 | `olist_sellers_dataset.csv` | Seller identifiers, city, and state. |
| 9 | `product_category_name_translation.csv` | Mapping from Portuguese category names to English. |

## Data Dictionary

### `olist_orders_dataset.csv`

| Column | Type | Description |
|--------|------|-------------|
| `order_id` | string | Unique order identifier |
| `customer_id` | string | Customer key (joins to `olist_customers_dataset`) |
| `order_status` | string | Status: delivered, shipped, canceled, etc. |
| `order_purchase_timestamp` | datetime | When the order was placed |
| `order_approved_at` | datetime | When payment was approved |
| `order_delivered_carrier_date` | datetime | When shipped to carrier |
| `order_delivered_customer_date` | datetime | When delivered to customer |
| `order_estimated_delivery_date` | datetime | Estimated delivery date |

### `olist_customers_dataset.csv`

| Column | Type | Description |
|--------|------|-------------|
| `customer_id` | string | Unique customer order key (joins to `orders`) |
| `customer_unique_id` | string | Unique customer identifier across orders |
| `customer_zip_code_prefix` | int | First 5 digits of ZIP code |
| `customer_city` | string | Customer city |
| `customer_state` | string | Customer state (2-letter code, e.g. SP, RJ) |

### `olist_order_items_dataset.csv`

| Column | Type | Description |
|--------|------|-------------|
| `order_id` | string | Order key (joins to `orders`) |
| `order_item_id` | int | Item sequence within the order (1-based) |
| `product_id` | string | Product key (joins to `products`) |
| `seller_id` | string | Seller key (joins to `sellers`) |
| `shipping_limit_date` | datetime | Seller's shipping deadline |
| `price` | float | Item price |
| `freight_value` | float | Freight cost for the item |

### `olist_order_reviews_dataset.csv`

| Column | Type | Description |
|--------|------|-------------|
| `review_id` | string | Unique review identifier |
| `order_id` | string | Order key (joins to `orders`) |
| `review_score` | int | Rating 1–5 |
| `review_comment_title` | string | Review title (in Portuguese) |
| `review_comment_message` | string | Review comment (in Portuguese) |
| `review_creation_date` | datetime | When the review was created |
| `review_answer_timestamp` | datetime | When Olist responded |

### `olist_products_dataset.csv`

| Column | Type | Description |
|--------|------|-------------|
| `product_id` | string | Unique product identifier |
| `product_category_name` | string | Category in Portuguese (join to translation table) |
| `product_name_lenght` | int | Characters in the product name |
| `product_description_lenght` | int | Characters in the product description |
| `product_photos_qty` | int | Number of product photos |
| `product_weight_g` | int | Weight in grams |
| `product_length_cm` | int | Length in cm |
| `product_height_cm` | int | Height in cm |
| `product_width_cm` | int | Width in cm |

> Full schemas for all 9 tables are available in the [Kaggle dataset documentation](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce).

## Download Instructions

### Method 1: Manual (Kaggle Website)

1. Go to [Kaggle: Brazilian E-Commerce](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
2. Click **Download** (you'll need a Kaggle account)
3. Unzip the archive into `data/raw/`

### Method 2: Automated (Kaggle CLI)

Requires the [Kaggle API](https://www.kaggle.com/docs/api) and Python:

```bash
# Install the Kaggle CLI
pip install kaggle

# Set up authentication (download kaggle.json from your Kaggle account settings)
mkdir -p ~/.kaggle
# Place your kaggle.json in ~/.kaggle/

# Run the download script (recommended)
./scripts/fetch_olist_data.sh

# Or directly:
kaggle datasets download -d olistbr/brazilian-ecommerce -p data/raw/ --unzip
```

## Attribution

**Data by Olist — Licensed under CC BY-NC-SA 4.0**

```
Olist: Brazilian E-Commerce Public Dataset by Olist
Copyright (c) 2018 Olist
Licensed under Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International
```

When using this dataset in publications or projects, please cite:

```
@misc{olist_brazilian_ecommerce_2018,
  author = {Olist},
  title = {Brazilian E-Commerce Public Dataset by Olist},
  year = {2018},
  publisher = {Kaggle},
  howpublished = {\url{https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce}}
}
```
