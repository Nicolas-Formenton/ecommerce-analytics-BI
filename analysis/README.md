# Olist Customer Analytics — Python Scripts

Extracted from the original Hex.tech project (`hex-analysis.yaml`) into standalone Python scripts.

## Files

| File | Origin | Purpose |
|------|--------|---------|
| `olist_cx_analytics.py` | Hex Cell 0 | Full pipeline: data loading, feature engineering, CLV regression, churn logistic regression, RFM K-Means segmentation, cohort analysis, Prophet-style forecasting, visualizations, CSV exports |
| `generate_report.py` | Hex Cells 9+10 | Generates Markdown report + multi-page PDF with executive summary, model metrics tables, and embedded PNG visualizations + ZIP archive download |

## SQL Cells (not extracted)

The original Hex project contained **8 SQL cells** that simply query in-memory DataFrames created by the main Python cell (e.g., `SELECT * FROM model_coefficients_df`). These are view-only previews in Hex and have no standalone value — the data is already computed and exported as CSVs by `olist_cx_analytics.py`.

## Requirements

```
pandas>=1.5.0
numpy>=1.23.0
matplotlib>=3.6.0
tabulate>=0.9.0
prophet>=1.1.0        # optional — falls back to additive trend if missing
```

Install with:

```bash
pip install -r requirements.txt
```

## Data

Place the Olist Brazilian E-Commerce CSV files in `data/raw/`:

```
data/raw/
├── olist_customers_dataset.csv
├── olist_geolocation_dataset.csv
├── olist_order_items_dataset.csv
├── olist_order_payments_dataset.csv
├── olist_order_reviews_dataset.csv
├── olist_orders_dataset.csv
├── olist_products_dataset.csv
├── olist_sellers_dataset.csv
└── product_category_name_translation.csv
```

The dataset is publicly available on [Kaggle: Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce).

> **Note:** In the original Hex project, files were loaded from Windows paths (`C:/Users/Nicolas/Dev/Datasets/...`).
> The standalone scripts use relative paths (`data/raw/...`) instead.

## Usage

Run the full pipeline analysis:

```bash
python analysis/olist_cx_analytics.py
```

This loads all CSVs, trains models, generates 6 PNG charts, and exports CSVs to `output/`.

Then generate the Markdown + PDF report:

```bash
python analysis/generate_report.py
```

This produces:
- `output/olist_customer_analytics_report.md` — full report in Markdown
- `output/olist_customer_analytics_report.pdf` — formatted multi-page PDF
- `output/olist_customer_analytics_report_files.zip` — ZIP of both files
- `output/download_links.html` — local download page

## Output structure

```
output/
├── olist_customer_analytics_outputs/   # (legacy, if created by earlier runs)
├── executive_summary.csv
├── model_metrics.csv
├── model_coefficients.csv
├── rfm_segments.csv
├── segment_summary.csv
├── cohort_retention.csv
├── monthly_sales.csv
├── forecast.csv
├── plot_files.csv
├── 01_clv_regression_actual_vs_predicted.png
├── 02_churn_logistic_calibration.png
├── 03_order_value_multiple_regression.png
├── 04_kmeans_rfm_segments.png
├── 05_cohort_retention_heatmap.png
├── 06_monthly_sales_forecast.png
├── olist_customer_analytics_report.md
├── olist_customer_analytics_report.pdf
├── olist_customer_analytics_report_files.zip
└── download_links.html
```

## Transformations from original Hex

| Original (Hex) | Standalone (this directory) |
|----------------|---------------------------|
| `get_ipython().run_line_magic(...)` / `%matplotlib inline` | Removed |
| `display(df)` | `print(df.to_string())` |
| `display(HTML(...))` | Writes `download_links.html` + prints summary |
| `plt.show()` | `plt.savefig('reports/...')` via `_save_fig()` |
| Windows paths (`C:/Users/...`) | Relative paths (`data/raw/`, `output/`) |
| `from IPython.display import HTML, display` | Wrapped in `try/except ImportError` |
| Cell-by-cell execution (Hex) | `if __name__ == '__main__'` guard |
