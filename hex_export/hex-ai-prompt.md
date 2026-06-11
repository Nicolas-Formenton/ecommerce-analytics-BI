# Hex.tech AI Prompt — Olist Brazilian E-Commerce CX Analytics Project

---

## Context
You are a data analyst building an end-to-end customer analytics project using the Olist Brazilian E-Commerce dataset. This project will be used to demonstrate statistical expertise (regression, segmentation, forecasting) for a Data Analyst Specialist role in Customer Experience (CX) Insights.

## Dataset Files
All CSV files are located in: `C:/Users/Nicolas/Dev/Datasets/Brazilian E-Commerce Public Dataset by Olist/`

**Files to load:**
1. `olist_customers_dataset.csv` — customer demographics and location
2. `olist_orders_dataset.csv` — order details, timestamps, status
3. `olist_order_items_dataset.csv` — items per order, price, shipping
4. `olist_order_payments_dataset.csv` — payment methods, installments
5. `olist_order_reviews_dataset.csv` — review scores, comments
6. `olist_products_dataset.csv` — product categories, dimensions
7. `olist_sellers_dataset.csv` — seller location
8. `olist_geolocation_dataset.csv` — zip code geolocation
9. `product_category_name_translation.csv` — Portuguese to English category names

## Objective
Build a comprehensive Python analytics app that performs statistical analysis on customer behavior data and produces actionable insights for a CX team. The app should be modular, well-documented, and produce publication-ready visualizations.

## Required Analyses

### Phase 1: Data Exploration & Cleaning
1. Load all 9 CSVs and inspect schema, missing values, data types
2. Clean data:
   - Handle missing values (impute or drop)
   - Remove duplicates
   - Convert dates to datetime
   - Fix data type issues
3. Join tables into a unified analytical dataset:
   - orders + customers + order_items + products + payments + reviews
   - Create customer-level aggregated features
   - Create order-level enriched dataset
4. Compute basic descriptive statistics:
   - Total customers, orders, revenue, products
   - Average order value, items per order
   - Geographic distribution (state, city)
   - Temporal distribution (orders by month, weekday, hour)

### Phase 2: Regression Analysis

#### 2.1 Linear Regression — Predict Customer Lifetime Value (CLV)
- **Target:** total revenue per customer (sum of all order values)
- **Features:** 
  - number of orders (frequency)
  - average order value
  - days since first purchase (tenure)
  - number of product categories purchased
  - payment method diversity (count unique payment types)
  - average review score given
  - total items purchased
  - average shipping cost
  - installment usage ratio (orders with installments / total orders)
- **Steps:**
  - Train-test split (80/20)
  - Standardize features
  - Fit Linear Regression with scikit-learn
  - Evaluate: R², MAE, RMSE, adjusted R²
  - Interpret coefficients (which features drive higher CLV?)
  - Visualize: actual vs predicted scatter plot, residual plot, feature importance bar chart

#### 2.2 Logistic Regression — Predict Customer Churn
- **Define churn:** customer with no purchase in the last 6 months from the max order date in dataset
- **Target:** churn (1 = churned, 0 = active)
- **Features:**
  - recency (days since last purchase)
  - frequency (total orders)
  - monetary (total revenue)
  - average order value
  - number of product categories
  - average review score
  - average shipping time (days)
  - complaint rate (orders with review score < 3 / total orders)
  - payment method count
  - installment usage
- **Steps:**
  - Train-test split (80/20)
  - Handle class imbalance (use class_weight='balanced' or SMOTE)
  - Fit Logistic Regression
  - Evaluate: accuracy, precision, recall, F1-score, AUC-ROC
  - Plot: confusion matrix, ROC curve, precision-recall curve, feature coefficients
  - Identify top 5 risk factors for churn

#### 2.3 Multiple Regression — Predict Order Value
- **Target:** order total value (sum of item prices + shipping)
- **Features:**
  - product category (encoded)
  - number of items in order
  - shipping cost
  - payment installments
  - customer state (encoded)
  - seller state (encoded)
  - review score (if available before order)
  - product weight/dimensions
  - purchase month (seasonality)
- **Steps:**
  - Fit Multiple Linear Regression
  - Evaluate: R², MAE, RMSE
  - Check for multicollinearity (VIF scores)
  - Visualize: predicted vs actual, residual distribution, feature importance

### Phase 3: Segmentation Analysis

#### 3.1 RFM Segmentation (K-Means Clustering)
- **Compute RFM metrics per customer:**
  - Recency (R): days since last purchase (lower = better)
  - Frequency (F): total number of orders
  - Monetary (M): total revenue
- **Steps:**
  - Standardize RFM values (z-score)
  - Determine optimal K using elbow method and silhouette score (K=3 to 6)
  - Fit K-Means clustering with optimal K
  - Name segments: Champions, Loyal Customers, At Risk, Lost, etc.
  - Analyze each segment: average R, F, M values, size, revenue contribution
  - Visualize: 3D scatter plot (R-F-M), segment distribution pie chart, segment characteristics heatmap

#### 3.2 Cohort Analysis
- **Create cohorts:** group customers by first purchase month
- **Compute:** monthly retention rates (percentage of customers from each cohort who made a purchase in subsequent months)
- **Visualize:** cohort retention matrix (heatmap), average retention curve
- **Calculate:** cohort lifetime value (total revenue per cohort over time)

### Phase 4: Time Series Forecasting

#### 4.1 Monthly Sales Forecasting
- **Aggregate data:** monthly revenue, order count, unique customers
- **Steps:**
  - Decompose time series (trend, seasonality, residual)
  - Fit Prophet model (Facebook) for forecasting
  - Forecast next 6 months
  - Evaluate: MAPE, MAE, RMSE on hold-out test set
  - Visualize: historical + forecasted values with confidence intervals, trend decomposition

#### 4.2 Weekly Pattern Analysis
- **Aggregate:** orders and revenue by day of week
- **Identify:** peak days, seasonal patterns
- **Visualize:** weekly revenue pattern, monthly growth rate

### Phase 5: Summary Dashboard & Insights

Create a summary section that outputs:

1. **Executive Summary** (3-4 bullet points):
   - Total customers analyzed
   - Average customer lifetime value
   - Churn rate
   - Top performing segment
   - Sales forecast trend

2. **Key Findings** (5-7 insights):
   - What drives higher CLV?
   - What are the top churn risk factors?
   - Which customer segments are most valuable?
   - What are the seasonal patterns?
   - Which states have highest AOV?
   - What is the relationship between review scores and churn?

3. **CX Recommendations** (3-4 actionable recommendations):
   - How to reduce churn?
   - How to increase CLV?
   - Which segments to prioritize?
   - When to run marketing campaigns?

4. **Visual Summary Dashboard** (combining key charts):
   - Revenue trend + forecast
   - Segment distribution
   - Churn risk factors
   - Top states by revenue
   - Monthly retention rates

## Technical Requirements
- Use **pandas** for data manipulation
- Use **scikit-learn** for regression and clustering
- Use **statsmodels** for detailed regression statistics
- Use **matplotlib** and **seaborn** for static visualizations
- Use **plotly** for interactive visualizations
- Use **fbprophet** or **neuralprophet** for forecasting
- Use **numpy** for numerical operations
- All code must be in a single Python app/script with clear sections
- Include comments and markdown headers
- Handle errors gracefully (try/except blocks)
- Save all visualizations as PNG files in a `plots/` folder
- Save model metrics and summary statistics as CSV files in a `outputs/` folder

## Deliverables
1. Single Python script/app with all analyses
2. `plots/` folder containing:
   - CLV regression (actual vs predicted, residuals, feature importance)
   - Churn prediction (confusion matrix, ROC curve, feature coefficients)
   - RFM segmentation (3D scatter, segment distribution, characteristics heatmap)
   - Cohort analysis (retention heatmap, retention curve)
   - Sales forecasting (historical + forecast, trend decomposition)
   - Weekly patterns (bar chart)
   - Summary dashboard (combined chart)
3. `outputs/` folder containing:
   - model_metrics.csv (all regression and classification metrics)
   - segment_summary.csv (segment characteristics)
   - cohort_retention.csv (retention matrix data)
   - forecast_results.csv (6-month forecast)
   - customer_rfm.csv (customer-level RFM scores and segments)
   - churn_predictions.csv (customer-level churn probabilities)

## Notes
- The dataset is in Portuguese (Brazil) — use product_category_name_translation.csv to get English category names
- Dates are in Brazilian timezone (America/Sao_Paulo)
- Monetary values are in Brazilian Reals (BRL)
- Some orders may have multiple items, multiple payments, multiple reviews
- Handle edge cases: orders with 0 items, customers with 1 order, cancelled orders
- For the churn analysis, consider order status ('delivered', 'shipped', 'canceled', etc.)

## Output Format
Structure the app as a single Python script with clearly defined sections, each wrapped in functions. The script should be executable top-to-bottom and produce all outputs automatically when run.

---

**PROMPT FOR HEX.AI:**

"Build an end-to-end customer analytics Python app using the Olist Brazilian E-Commerce dataset. Load all 9 CSV files from `C:/Users/Nicolas/Dev/Datasets/Brazilian E-Commerce Public Dataset by Olist/`. Perform comprehensive statistical analysis including: (1) Linear Regression to predict Customer Lifetime Value, (2) Logistic Regression to predict customer churn, (3) Multiple Regression to predict order value, (4) K-Means RFM segmentation, (5) Cohort analysis with retention rates, (6) Prophet time series forecasting for monthly sales. Create publication-ready visualizations for each analysis. Save all plots as PNG files and all metrics/segment data as CSV files. Include a summary section with executive insights and actionable CX recommendations. Use pandas, scikit-learn, statsmodels, matplotlib, seaborn, plotly, and Prophet. Structure as a single executable Python script with clear sections and comments."
