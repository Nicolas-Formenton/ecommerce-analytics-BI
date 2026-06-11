"""
Olist Brazilian E-Commerce — Customer Analytics Pipeline

Originally built in Hex.tech as "Análise Estatística".
Extracted and adapted for standalone execution.
See hex_export/ for the original Hex project export.

All regressions built from scratch with NumPy (no scikit-learn).
Prophet was unavailable in the Hex environment — fallback
additive forecast implementation used instead.

Requirements:
    pip install -r requirements.txt

Usage:
    python analysis/olist_cx_analytics.py
"""

import os
import math
import json
import warnings
from pathlib import Path

import matplotlib
matplotlib.use("Agg")

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

warnings.filterwarnings("ignore")
plt.style.use("seaborn-v0_8-whitegrid")

OUTPUT_DIR = Path("output")
OUTPUT_DIR.mkdir(exist_ok=True)

RANDOM_SEED = 42
np.random.seed(RANDOM_SEED)

# -----------------------------------------------------------------------------
# 1. Load all 9 project CSV files
# -----------------------------------------------------------------------------
orders = pd.read_csv("data/raw/olist_orders_dataset.csv", parse_dates=[
    "order_purchase_timestamp",
    "order_approved_at",
    "order_delivered_carrier_date",
    "order_delivered_customer_date",
    "order_estimated_delivery_date",
])
customers = pd.read_csv("data/raw/olist_customers_dataset.csv")
order_items = pd.read_csv("data/raw/olist_order_items_dataset.csv", parse_dates=["shipping_limit_date"])
order_payments = pd.read_csv("data/raw/olist_order_payments_dataset.csv")
order_reviews = pd.read_csv("data/raw/olist_order_reviews_dataset.csv", parse_dates=["review_creation_date", "review_answer_timestamp"])
products = pd.read_csv("data/raw/olist_products_dataset.csv")
sellers = pd.read_csv("data/raw/olist_sellers_dataset.csv")
geolocation = pd.read_csv("data/raw/olist_geolocation_dataset.csv")
category_translation = pd.read_csv("data/raw/product_category_name_translation.csv")

# -----------------------------------------------------------------------------
# 2. Data preparation and feature engineering
# -----------------------------------------------------------------------------
products = products.merge(category_translation, on="product_category_name", how="left")
products["product_category_name_english"] = products["product_category_name_english"].fillna(products["product_category_name"])
products["product_volume_cm3"] = (
    products["product_length_cm"].fillna(0)
    * products["product_height_cm"].fillna(0)
    * products["product_width_cm"].fillna(0)
)

items_products = order_items.merge(products, on="product_id", how="left").merge(sellers, on="seller_id", how="left")

item_agg = items_products.groupby("order_id").agg(
    item_count=("order_item_id", "count"),
    seller_count=("seller_id", "nunique"),
    product_count=("product_id", "nunique"),
    category_count=("product_category_name_english", "nunique"),
    price_total=("price", "sum"),
    freight_total=("freight_value", "sum"),
    avg_item_price=("price", "mean"),
    avg_product_weight_g=("product_weight_g", "mean"),
    avg_product_volume_cm3=("product_volume_cm3", "mean"),
    primary_category=("product_category_name_english", lambda x: x.mode().iloc[0] if not x.mode().empty else "unknown"),
    primary_seller_state=("seller_state", lambda x: x.mode().iloc[0] if not x.mode().empty else "unknown"),
).reset_index()

payment_agg = order_payments.groupby("order_id").agg(
    payment_value=("payment_value", "sum"),
    payment_installments=("payment_installments", "mean"),
    payment_type_count=("payment_type", "nunique"),
    primary_payment_type=("payment_type", lambda x: x.mode().iloc[0] if not x.mode().empty else "unknown"),
).reset_index()

review_agg = order_reviews.groupby("order_id").agg(
    review_score=("review_score", "mean"),
    review_count=("review_id", "count"),
).reset_index()

orders_enriched = (
    orders
    .merge(customers, on="customer_id", how="left")
    .merge(item_agg, on="order_id", how="left")
    .merge(payment_agg, on="order_id", how="left")
    .merge(review_agg, on="order_id", how="left")
)

orders_enriched["delivery_days"] = (
    orders_enriched["order_delivered_customer_date"] - orders_enriched["order_purchase_timestamp"]
).dt.total_seconds() / 86400
orders_enriched["estimated_delivery_days"] = (
    orders_enriched["order_estimated_delivery_date"] - orders_enriched["order_purchase_timestamp"]
).dt.total_seconds() / 86400
orders_enriched["delivery_delta_days"] = (
    orders_enriched["order_delivered_customer_date"] - orders_enriched["order_estimated_delivery_date"]
).dt.total_seconds() / 86400
orders_enriched["was_late"] = (orders_enriched["delivery_delta_days"] > 0).astype(int)
orders_enriched["order_month"] = orders_enriched["order_purchase_timestamp"].dt.to_period("M").dt.to_timestamp()
orders_enriched["order_date"] = orders_enriched["order_purchase_timestamp"].dt.date

orders_enriched["payment_value"] = orders_enriched["payment_value"].fillna(0)
orders_enriched["price_total"] = orders_enriched["price_total"].fillna(0)
orders_enriched["freight_total"] = orders_enriched["freight_total"].fillna(0)
orders_enriched["item_count"] = orders_enriched["item_count"].fillna(0)
orders_enriched["review_score"] = orders_enriched["review_score"].fillna(orders_enriched["review_score"].median())

analysis_orders = orders_enriched[
    (orders_enriched["order_status"] == "delivered")
    & orders_enriched["order_purchase_timestamp"].notna()
    & (orders_enriched["payment_value"] > 0)
].copy()

max_purchase_date = analysis_orders["order_purchase_timestamp"].max()
snapshot_date = max_purchase_date + pd.Timedelta(days=1)

customer_features = analysis_orders.groupby("customer_unique_id").agg(
    customer_state=("customer_state", "first"),
    customer_city=("customer_city", "first"),
    first_order_date=("order_purchase_timestamp", "min"),
    last_order_date=("order_purchase_timestamp", "max"),
    frequency=("order_id", "nunique"),
    monetary=("payment_value", "sum"),
    avg_order_value=("payment_value", "mean"),
    total_items=("item_count", "sum"),
    avg_items_per_order=("item_count", "mean"),
    total_freight=("freight_total", "sum"),
    avg_freight=("freight_total", "mean"),
    avg_review_score=("review_score", "mean"),
    late_delivery_rate=("was_late", "mean"),
    avg_delivery_days=("delivery_days", "mean"),
    category_diversity=("category_count", "sum"),
    payment_type_diversity=("payment_type_count", "mean"),
    avg_installments=("payment_installments", "mean"),
).reset_index()

customer_features["recency_days"] = (snapshot_date - customer_features["last_order_date"]).dt.days
customer_features["tenure_days"] = (customer_features["last_order_date"] - customer_features["first_order_date"]).dt.days.clip(lower=0)
customer_features["clv"] = customer_features["monetary"]
customer_features["churned"] = (customer_features["recency_days"] > 180).astype(int)
customer_features["customer_state"] = customer_features["customer_state"].fillna("unknown")
customer_features["customer_city"] = customer_features["customer_city"].fillna("unknown")

# -----------------------------------------------------------------------------
# 3. Reusable statistical modeling helpers using NumPy only
# -----------------------------------------------------------------------------
def _prepare_matrix(df, feature_cols):
    X = df[feature_cols].copy()
    for col in feature_cols:
        X[col] = pd.to_numeric(X[col], errors="coerce")
        X[col] = X[col].fillna(X[col].median())
    return X.astype(float)


def _train_test_indices(n, test_size=0.25, seed=RANDOM_SEED):
    rng = np.random.default_rng(seed)
    idx = np.arange(n)
    rng.shuffle(idx)
    split = int(n * (1 - test_size))
    return idx[:split], idx[split:]


def _standardize_train_test(X_train, X_test):
    mu = X_train.mean(axis=0)
    sigma = X_train.std(axis=0)
    sigma[sigma == 0] = 1
    return (X_train - mu) / sigma, (X_test - mu) / sigma, mu, sigma


def _linear_regression(df, target_col, feature_cols, model_name):
    modeling_df = df[[target_col] + feature_cols].replace([np.inf, -np.inf], np.nan).dropna(subset=[target_col]).copy()
    X = _prepare_matrix(modeling_df, feature_cols).to_numpy()
    y = modeling_df[target_col].astype(float).to_numpy()
    train_idx, test_idx = _train_test_indices(len(modeling_df))
    X_train, X_test = X[train_idx], X[test_idx]
    y_train, y_test = y[train_idx], y[test_idx]
    X_train_scaled, X_test_scaled, mu, sigma = _standardize_train_test(X_train, X_test)
    X_design = np.column_stack([np.ones(len(X_train_scaled)), X_train_scaled])
    beta = np.linalg.pinv(X_design.T @ X_design) @ X_design.T @ y_train
    y_pred = np.column_stack([np.ones(len(X_test_scaled)), X_test_scaled]) @ beta
    residuals = y_test - y_pred
    rmse = float(np.sqrt(np.mean(residuals ** 2)))
    mae = float(np.mean(np.abs(residuals)))
    r2 = float(1 - np.sum(residuals ** 2) / np.sum((y_test - y_test.mean()) ** 2)) if np.sum((y_test - y_test.mean()) ** 2) > 0 else np.nan
    coef_df = pd.DataFrame({
        "model": model_name,
        "feature": ["intercept"] + feature_cols,
        "coefficient": beta,
    })
    pred_df = pd.DataFrame({
        "model": model_name,
        "actual": y_test,
        "predicted": y_pred,
        "residual": residuals,
    })
    metrics = {
        "model": model_name,
        "target": target_col,
        "rows": len(modeling_df),
        "train_rows": len(train_idx),
        "test_rows": len(test_idx),
        "rmse": rmse,
        "mae": mae,
        "r2": r2,
    }
    return metrics, coef_df, pred_df


def _sigmoid(z):
    z = np.clip(z, -35, 35)
    return 1 / (1 + np.exp(-z))


def _auc_score(y_true, y_score):
    order = np.argsort(y_score)
    ranks = np.empty_like(order, dtype=float)
    ranks[order] = np.arange(1, len(y_score) + 1)
    pos = y_true == 1
    n_pos = pos.sum()
    n_neg = len(y_true) - n_pos
    if n_pos == 0 or n_neg == 0:
        return np.nan
    return float((ranks[pos].sum() - n_pos * (n_pos + 1) / 2) / (n_pos * n_neg))


def _logistic_regression(df, target_col, feature_cols, model_name, lr=0.05, n_iter=2500, l2=0.01):
    modeling_df = df[[target_col] + feature_cols].replace([np.inf, -np.inf], np.nan).dropna(subset=[target_col]).copy()
    X = _prepare_matrix(modeling_df, feature_cols).to_numpy()
    y = modeling_df[target_col].astype(int).to_numpy()
    train_idx, test_idx = _train_test_indices(len(modeling_df))
    X_train, X_test = X[train_idx], X[test_idx]
    y_train, y_test = y[train_idx], y[test_idx]
    X_train_scaled, X_test_scaled, mu, sigma = _standardize_train_test(X_train, X_test)
    X_train_design = np.column_stack([np.ones(len(X_train_scaled)), X_train_scaled])
    X_test_design = np.column_stack([np.ones(len(X_test_scaled)), X_test_scaled])
    beta = np.zeros(X_train_design.shape[1])
    for _ in range(n_iter):
        p = _sigmoid(X_train_design @ beta)
        grad = X_train_design.T @ (p - y_train) / len(y_train)
        grad[1:] += l2 * beta[1:] / len(y_train)
        beta -= lr * grad
    y_prob = _sigmoid(X_test_design @ beta)
    y_pred = (y_prob >= 0.5).astype(int)
    tp = int(((y_pred == 1) & (y_test == 1)).sum())
    tn = int(((y_pred == 0) & (y_test == 0)).sum())
    fp = int(((y_pred == 1) & (y_test == 0)).sum())
    fn = int(((y_pred == 0) & (y_test == 1)).sum())
    accuracy = float((tp + tn) / len(y_test))
    precision = float(tp / (tp + fp)) if tp + fp else 0.0
    recall = float(tp / (tp + fn)) if tp + fn else 0.0
    f1 = float(2 * precision * recall / (precision + recall)) if precision + recall else 0.0
    auc = _auc_score(y_test, y_prob)
    coef_df = pd.DataFrame({
        "model": model_name,
        "feature": ["intercept"] + feature_cols,
        "coefficient": beta,
        "odds_ratio": np.exp(np.clip(beta, -10, 10)),
    })
    pred_df = pd.DataFrame({
        "model": model_name,
        "actual": y_test,
        "predicted_probability": y_prob,
        "predicted_class": y_pred,
    })
    metrics = {
        "model": model_name,
        "target": target_col,
        "rows": len(modeling_df),
        "train_rows": len(train_idx),
        "test_rows": len(test_idx),
        "accuracy": accuracy,
        "precision": precision,
        "recall": recall,
        "f1": f1,
        "auc": auc,
        "true_positive": tp,
        "true_negative": tn,
        "false_positive": fp,
        "false_negative": fn,
    }
    return metrics, coef_df, pred_df

# -----------------------------------------------------------------------------
# 4. Linear Regression: Customer Lifetime Value prediction
# -----------------------------------------------------------------------------
clv_features = [
    "frequency", "avg_order_value", "total_items", "avg_review_score", "late_delivery_rate",
    "avg_delivery_days", "category_diversity", "avg_installments", "tenure_days", "recency_days"
]
clv_metrics, clv_coefficients_df, clv_predictions_df = _linear_regression(
    customer_features, "clv", clv_features, "Linear regression - CLV"
)

# -----------------------------------------------------------------------------
# 5. Logistic Regression: Churn prediction
# -----------------------------------------------------------------------------
churn_features = [
    "frequency", "monetary", "avg_order_value", "total_items", "avg_review_score", "late_delivery_rate",
    "avg_delivery_days", "category_diversity", "avg_installments", "tenure_days"
]
churn_metrics, churn_coefficients_df, churn_predictions_df = _logistic_regression(
    customer_features, "churned", churn_features, "Logistic regression - Churn"
)

# -----------------------------------------------------------------------------
# 6. Multiple Regression: Order value prediction
# -----------------------------------------------------------------------------
order_model_df = analysis_orders.copy()
order_model_df["avg_product_weight_g"] = order_model_df["avg_product_weight_g"].fillna(order_model_df["avg_product_weight_g"].median())
order_model_df["avg_product_volume_cm3"] = order_model_df["avg_product_volume_cm3"].fillna(order_model_df["avg_product_volume_cm3"].median())
order_value_features = [
    "item_count", "seller_count", "product_count", "category_count", "freight_total",
    "payment_installments", "review_score", "delivery_days", "avg_product_weight_g", "avg_product_volume_cm3"
]
order_value_metrics, order_value_coefficients_df, order_value_predictions_df = _linear_regression(
    order_model_df, "payment_value", order_value_features, "Multiple regression - Order value"
)

# -----------------------------------------------------------------------------
# 7. K-Means RFM segmentation
# -----------------------------------------------------------------------------
def _kmeans(X, k=4, max_iter=100, seed=RANDOM_SEED):
    rng = np.random.default_rng(seed)
    centroids = X[rng.choice(len(X), size=k, replace=False)].copy()
    labels = np.zeros(len(X), dtype=int)
    for _ in range(max_iter):
        distances = ((X[:, None, :] - centroids[None, :, :]) ** 2).sum(axis=2)
        new_labels = distances.argmin(axis=1)
        new_centroids = np.array([
            X[new_labels == cluster].mean(axis=0) if np.any(new_labels == cluster) else centroids[cluster]
            for cluster in range(k)
        ])
        if np.array_equal(new_labels, labels) and np.allclose(new_centroids, centroids):
            break
        labels = new_labels
        centroids = new_centroids
    return labels, centroids

rfm = customer_features[["customer_unique_id", "recency_days", "frequency", "monetary", "avg_review_score", "customer_state"]].copy()
rfm_log = pd.DataFrame({
    "recency_score": np.log1p(rfm["recency_days"].max() - rfm["recency_days"] + 1),
    "frequency": np.log1p(rfm["frequency"].clip(lower=0)),
    "monetary": np.log1p(rfm["monetary"].clip(lower=0)),
})
rfm_scaled = (rfm_log - rfm_log.mean()) / rfm_log.std().replace(0, 1)
rfm["cluster"] = _kmeans(rfm_scaled.to_numpy(), k=4)[0]

cluster_profile = rfm.groupby("cluster").agg(
    customers=("customer_unique_id", "nunique"),
    avg_recency_days=("recency_days", "mean"),
    avg_frequency=("frequency", "mean"),
    avg_monetary=("monetary", "mean"),
    total_revenue=("monetary", "sum"),
    avg_review_score=("avg_review_score", "mean"),
).reset_index()
cluster_profile["value_score"] = (
    cluster_profile["avg_frequency"].rank(pct=True)
    + cluster_profile["avg_monetary"].rank(pct=True)
    + (1 - cluster_profile["avg_recency_days"].rank(pct=True))
)
ranked_clusters = cluster_profile.sort_values("value_score", ascending=False)["cluster"].tolist()
segment_names = ["Champions", "Loyal high value", "Potential loyalists", "At risk / low value"]
cluster_to_segment = dict(zip(ranked_clusters, segment_names))
rfm["segment"] = rfm["cluster"].map(cluster_to_segment)
rfm_segments_df = rfm.merge(customer_features[["customer_unique_id", "first_order_date", "last_order_date", "avg_order_value", "late_delivery_rate"]], on="customer_unique_id", how="left")
segment_summary_df = rfm_segments_df.groupby("segment").agg(
    customers=("customer_unique_id", "nunique"),
    avg_recency_days=("recency_days", "mean"),
    avg_frequency=("frequency", "mean"),
    avg_monetary=("monetary", "mean"),
    total_revenue=("monetary", "sum"),
    avg_review_score=("avg_review_score", "mean"),
    late_delivery_rate=("late_delivery_rate", "mean"),
).reset_index().sort_values("total_revenue", ascending=False)
segment_summary_df["revenue_share"] = segment_summary_df["total_revenue"] / segment_summary_df["total_revenue"].sum()

# -----------------------------------------------------------------------------
# 8. Cohort analysis with retention rates
# -----------------------------------------------------------------------------
cohort_base = analysis_orders[["customer_unique_id", "order_month"]].dropna().drop_duplicates()
first_cohort = cohort_base.groupby("customer_unique_id")["order_month"].min().rename("cohort_month")
cohort_base = cohort_base.merge(first_cohort, on="customer_unique_id", how="left")
cohort_base["cohort_index"] = (
    (cohort_base["order_month"].dt.year - cohort_base["cohort_month"].dt.year) * 12
    + (cohort_base["order_month"].dt.month - cohort_base["cohort_month"].dt.month)
)
cohort_counts = cohort_base.groupby(["cohort_month", "cohort_index"]).agg(customers=("customer_unique_id", "nunique")).reset_index()
cohort_sizes = cohort_counts[cohort_counts["cohort_index"] == 0][["cohort_month", "customers"]].rename(columns={"customers": "cohort_size"})
cohort_retention_df = cohort_counts.merge(cohort_sizes, on="cohort_month", how="left")
cohort_retention_df["retention_rate"] = cohort_retention_df["customers"] / cohort_retention_df["cohort_size"]
cohort_retention_df["cohort_month"] = cohort_retention_df["cohort_month"].dt.strftime("%Y-%m")

# -----------------------------------------------------------------------------
# 9. Prophet-style monthly sales forecasting
# -----------------------------------------------------------------------------
monthly_sales_df = analysis_orders.groupby("order_month").agg(
    monthly_sales=("payment_value", "sum"),
    orders=("order_id", "nunique"),
    customers=("customer_unique_id", "nunique"),
    avg_order_value=("payment_value", "mean"),
).reset_index().sort_values("order_month")
monthly_sales_df["ds"] = monthly_sales_df["order_month"]
monthly_sales_df["y"] = monthly_sales_df["monthly_sales"]

forecast_model_used = "Prophet"
try:
    from prophet import Prophet
    prophet_df = monthly_sales_df[["ds", "y"]].copy()
    model = Prophet(yearly_seasonality=True, weekly_seasonality=False, daily_seasonality=False, interval_width=0.8)
    model.fit(prophet_df)
    future = model.make_future_dataframe(periods=12, freq="MS")
    forecast = model.predict(future)
    forecast_df = forecast[["ds", "yhat", "yhat_lower", "yhat_upper"]].copy()
except Exception as exc:
    forecast_model_used = f"Additive trend + month seasonality fallback ({type(exc).__name__}: Prophet unavailable)"
    temp = monthly_sales_df[["ds", "y"]].copy().reset_index(drop=True)
    temp["t"] = np.arange(len(temp))
    temp["month"] = temp["ds"].dt.month
    month_dummies = pd.get_dummies(temp["month"], prefix="month", drop_first=True).astype(float)
    X = pd.concat([pd.Series(1.0, index=temp.index, name="intercept"), temp[["t"]].astype(float), month_dummies], axis=1)
    beta = np.linalg.pinv(X.to_numpy().T @ X.to_numpy()) @ X.to_numpy().T @ temp["y"].to_numpy()
    future_dates = pd.date_range(temp["ds"].min(), periods=len(temp) + 12, freq="MS")
    future_temp = pd.DataFrame({"ds": future_dates, "t": np.arange(len(future_dates))})
    future_temp["month"] = future_temp["ds"].dt.month
    future_dummies = pd.get_dummies(future_temp["month"], prefix="month", drop_first=True).astype(float)
    future_X = pd.concat([pd.Series(1.0, index=future_temp.index, name="intercept"), future_temp[["t"]].astype(float), future_dummies], axis=1)
    future_X = future_X.reindex(columns=X.columns, fill_value=0)
    fitted = X.to_numpy() @ beta
    residual_std = float(np.std(temp["y"].to_numpy() - fitted))
    yhat = future_X.to_numpy() @ beta
    forecast_df = pd.DataFrame({
        "ds": future_dates,
        "yhat": np.maximum(yhat, 0),
        "yhat_lower": np.maximum(yhat - 1.28 * residual_std, 0),
        "yhat_upper": np.maximum(yhat + 1.28 * residual_std, 0),
    })

forecast_df["period_type"] = np.where(forecast_df["ds"] <= monthly_sales_df["ds"].max(), "historical", "forecast")
forecast_df["forecast_model"] = forecast_model_used
forecast_df = forecast_df.merge(monthly_sales_df[["ds", "monthly_sales", "orders", "customers", "avg_order_value"]], on="ds", how="left")
forecast_df["ds"] = forecast_df["ds"].dt.strftime("%Y-%m-%d")
monthly_sales_df["order_month"] = monthly_sales_df["order_month"].dt.strftime("%Y-%m-%d")
monthly_sales_df["ds"] = monthly_sales_df["ds"].dt.strftime("%Y-%m-%d")

# -----------------------------------------------------------------------------
# 10. Publication-ready visualizations saved as PNG files
# -----------------------------------------------------------------------------
def _save_fig(fig, filename):
    path = OUTPUT_DIR / filename
    fig.tight_layout()
    fig.savefig(path, dpi=180, bbox_inches="tight")
    plt.close(fig)
    return str(path)

plot_files = []

fig, ax = plt.subplots(figsize=(8, 6))
sample = clv_predictions_df.sample(min(3000, len(clv_predictions_df)), random_state=RANDOM_SEED)
ax.scatter(sample["actual"], sample["predicted"], alpha=0.35, s=14, color="#2563eb")
line_max = float(np.nanpercentile(sample[["actual", "predicted"]].to_numpy(), 99))
ax.plot([0, line_max], [0, line_max], color="#111827", lw=1.5, linestyle="--")
ax.set_title("Customer Lifetime Value: Actual vs Predicted")
ax.set_xlabel("Actual CLV (BRL)")
ax.set_ylabel("Predicted CLV (BRL)")
plot_files.append(_save_fig(fig, "01_clv_regression_actual_vs_predicted.png"))

fig, ax = plt.subplots(figsize=(8, 6))
prob_bins = pd.cut(churn_predictions_df["predicted_probability"], bins=np.linspace(0, 1, 11), include_lowest=True)
calibration = churn_predictions_df.groupby(prob_bins).agg(actual_churn_rate=("actual", "mean"), customers=("actual", "count")).reset_index()
ax.bar(range(len(calibration)), calibration["actual_churn_rate"], color="#dc2626", alpha=0.8)
ax.set_xticks(range(len(calibration)))
ax.set_xticklabels([str(x) for x in calibration["predicted_probability"]], rotation=45, ha="right")
ax.set_title("Churn Model Calibration by Predicted Probability")
ax.set_xlabel("Predicted churn probability bin")
ax.set_ylabel("Observed churn rate")
plot_files.append(_save_fig(fig, "02_churn_logistic_calibration.png"))

fig, ax = plt.subplots(figsize=(8, 6))
sample = order_value_predictions_df.sample(min(3000, len(order_value_predictions_df)), random_state=RANDOM_SEED)
ax.scatter(sample["actual"], sample["predicted"], alpha=0.25, s=12, color="#16a34a")
line_max = float(np.nanpercentile(sample[["actual", "predicted"]].to_numpy(), 99))
ax.plot([0, line_max], [0, line_max], color="#111827", lw=1.5, linestyle="--")
ax.set_title("Order Value: Actual vs Predicted")
ax.set_xlabel("Actual order value (BRL)")
ax.set_ylabel("Predicted order value (BRL)")
plot_files.append(_save_fig(fig, "03_order_value_multiple_regression.png"))

fig, ax = plt.subplots(figsize=(9, 6))
for segment, seg_df in rfm_segments_df.groupby("segment"):
    sample_seg = seg_df.sample(min(2500, len(seg_df)), random_state=RANDOM_SEED)
    ax.scatter(sample_seg["recency_days"], sample_seg["monetary"], s=12, alpha=0.35, label=segment)
ax.set_title("K-Means RFM Customer Segments")
ax.set_xlabel("Recency days")
ax.set_ylabel("Monetary value (BRL)")
ax.legend(frameon=True)
plot_files.append(_save_fig(fig, "04_kmeans_rfm_segments.png"))

cohort_heatmap = cohort_retention_df.pivot(index="cohort_month", columns="cohort_index", values="retention_rate").fillna(np.nan)
fig, ax = plt.subplots(figsize=(12, 7))
im = ax.imshow(cohort_heatmap.to_numpy(), aspect="auto", cmap="Blues", vmin=0, vmax=min(0.25, np.nanmax(cohort_heatmap.to_numpy())))
ax.set_title("Monthly Cohort Retention Rates")
ax.set_xlabel("Months since first purchase")
ax.set_ylabel("Acquisition cohort")
ax.set_xticks(range(len(cohort_heatmap.columns)))
ax.set_xticklabels(cohort_heatmap.columns)
ax.set_yticks(range(len(cohort_heatmap.index)))
ax.set_yticklabels(cohort_heatmap.index)
fig.colorbar(im, ax=ax, label="Retention rate")
plot_files.append(_save_fig(fig, "05_cohort_retention_heatmap.png"))

fig, ax = plt.subplots(figsize=(10, 6))
forecast_plot_df = forecast_df.copy()
forecast_plot_df["ds_dt"] = pd.to_datetime(forecast_plot_df["ds"])
ax.plot(forecast_plot_df["ds_dt"], forecast_plot_df["yhat"], color="#7c3aed", lw=2, label="Forecast / fitted")
ax.fill_between(forecast_plot_df["ds_dt"], forecast_plot_df["yhat_lower"], forecast_plot_df["yhat_upper"], color="#c4b5fd", alpha=0.35, label="80% interval")
hist = forecast_plot_df[forecast_plot_df["period_type"] == "historical"]
ax.scatter(hist["ds_dt"], hist["monthly_sales"], color="#111827", s=28, label="Historical sales")
ax.set_title("Monthly Sales Forecast")
ax.set_xlabel("Month")
ax.set_ylabel("Sales (BRL)")
ax.legend(frameon=True)
plot_files.append(_save_fig(fig, "06_monthly_sales_forecast.png"))

plot_files_df = pd.DataFrame({"plot_file": plot_files})

# -----------------------------------------------------------------------------
# 11. Executive insights and recommendations
# -----------------------------------------------------------------------------
repeat_customer_rate = float((customer_features["frequency"] > 1).mean())
churn_rate = float(customer_features["churned"].mean())
late_delivery_rate = float(analysis_orders["was_late"].mean())
avg_review = float(analysis_orders["review_score"].mean())
total_revenue = float(analysis_orders["payment_value"].sum())
orders_count = int(analysis_orders["order_id"].nunique())
customers_count = int(customer_features["customer_unique_id"].nunique())
best_segment = segment_summary_df.sort_values("total_revenue", ascending=False).iloc[0]
champions = segment_summary_df[segment_summary_df["segment"] == "Champions"].iloc[0]
forecast_tail = forecast_df[forecast_df["period_type"] == "forecast"].copy()
next_12m_forecast = float(forecast_tail["yhat"].sum()) if len(forecast_tail) else np.nan
last_12m_sales = float(monthly_sales_df.tail(12)["monthly_sales"].sum()) if len(monthly_sales_df) >= 12 else float(monthly_sales_df["monthly_sales"].sum())
forecast_growth = (next_12m_forecast / last_12m_sales - 1) if last_12m_sales else np.nan

executive_summary_df = pd.DataFrame([
    {"section": "Business scale", "insight": f"Delivered-order revenue totals BRL {total_revenue:,.0f} across {orders_count:,} orders and {customers_count:,} unique customers.", "recommendation": "Use customer_unique_id as the CX analytics grain and prioritize retention plays around high-value repeat buyers."},
    {"section": "Retention", "insight": f"Only {repeat_customer_rate:.1%} of customers purchased more than once; churn proxy rate is {churn_rate:.1%} using >180 days since last purchase.", "recommendation": "Launch post-purchase lifecycle campaigns within 30-90 days, with stronger incentives before customers cross the 180-day inactivity threshold."},
    {"section": "RFM segmentation", "insight": f"The largest revenue segment is {best_segment['segment']} with BRL {best_segment['total_revenue']:,.0f}; Champions average BRL {champions['avg_monetary']:,.0f} monetary value.", "recommendation": "Protect Champions with premium service and early access; target Potential loyalists with cross-sell bundles and free-shipping thresholds."},
    {"section": "Delivery experience", "insight": f"Late deliveries occur on {late_delivery_rate:.1%} of delivered orders; average review score is {avg_review:.2f}/5.", "recommendation": "Prioritize proactive delivery alerts, seller SLA monitoring, and recovery offers for late orders to reduce churn risk."},
    {"section": "Model performance", "insight": f"CLV regression R²={clv_metrics['r2']:.3f}; order value regression R²={order_value_metrics['r2']:.3f}; churn model AUC={churn_metrics['auc']:.3f}.", "recommendation": "Use model scores for prioritization, not automated decisioning; validate on more recent holdout data before production use."},
    {"section": "Forecast", "insight": f"Next 12-month forecast totals BRL {next_12m_forecast:,.0f}, implying {forecast_growth:.1%} vs the latest comparable 12-month sales baseline. Forecast method: {forecast_model_used}.", "recommendation": "Use the forecast as a planning baseline and refresh monthly; install Prophet in the environment for the canonical Prophet model if the fallback was used."},
])

model_metrics_df = pd.DataFrame([clv_metrics, churn_metrics, order_value_metrics])
model_coefficients_df = pd.concat([clv_coefficients_df, churn_coefficients_df, order_value_coefficients_df], ignore_index=True)
model_predictions_sample_df = pd.concat([
    clv_predictions_df.sample(min(1000, len(clv_predictions_df)), random_state=RANDOM_SEED),
    order_value_predictions_df.sample(min(1000, len(order_value_predictions_df)), random_state=RANDOM_SEED),
], ignore_index=True)

# Export metrics, segment data, cohorts, forecasts, and plot index as CSV files.
exports = {
    "executive_summary.csv": executive_summary_df,
    "model_metrics.csv": model_metrics_df,
    "model_coefficients.csv": model_coefficients_df,
    "rfm_segments.csv": rfm_segments_df,
    "segment_summary.csv": segment_summary_df,
    "cohort_retention.csv": cohort_retention_df,
    "monthly_sales.csv": monthly_sales_df,
    "forecast.csv": forecast_df,
    "plot_files.csv": plot_files_df,
}
for filename, df in exports.items():
    df.to_csv(OUTPUT_DIR / filename, index=False)

# Compact report manifest for downstream app generation.
report_manifest_df = pd.DataFrame([{
    "output_directory": str(OUTPUT_DIR),
    "csv_files_saved": ", ".join(exports.keys()),
    "png_files_saved": ", ".join(Path(p).name for p in plot_files),
    "forecast_model_used": forecast_model_used,
    "source_files_loaded": "olist_geolocation_dataset.csv, olist_products_dataset.csv, olist_order_reviews_dataset.csv, olist_order_payments_dataset.csv, olist_sellers_dataset.csv, olist_order_items_dataset.csv, product_category_name_translation.csv, olist_customers_dataset.csv, olist_orders_dataset.csv",
}])

if __name__ == "__main__":
    print("=" * 72)
    print("Olist Brazilian E-Commerce — Customer Analytics Pipeline")
    print("=" * 72)
    print()
    print(f"Output directory: {OUTPUT_DIR.resolve()}")
    print(f"CSV files saved:  {len(exports)}")
    print(f"PNG charts saved: {len(plot_files)}")
    print(f"Forecast model:   {forecast_model_used}")
    print()
    print("Executive Summary:")
    print("-" * 72)
    print(executive_summary_df.to_string(index=False))
    print()
    print("Model Metrics:")
    print("-" * 72)
    print(model_metrics_df.to_string(index=False))
    print()
    print("Segment Summary:")
    print("-" * 72)
    print(segment_summary_df.to_string(index=False))
    print()
    print(f"All outputs saved to: {OUTPUT_DIR.resolve()}")
