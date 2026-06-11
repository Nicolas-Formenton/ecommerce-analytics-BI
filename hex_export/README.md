# Hex.tech Export

**Hex.tech** is a cloud data analytics platform where this project was originally built. It provides a collaborative notebook environment for data science and analytics work using Python, SQL, and visualizations.

## Contents

| File | Description |
|------|-------------|
| `hex-analysis.yaml` | Full Hex project export — can be re-imported into any Hex workspace. Contains all code cells, SQL cells, and display configuration for the Olist customer analytics pipeline. |
| `hex-ai-prompt.md` | The AI prompt that was used to generate the initial Hex project via Hex's AI assistant. Includes the full specification: dataset loading, regression models, RFM segmentation, cohort analysis, time series forecasting, and deliverable requirements. |

## How to Re-import

```bash
# In a Hex workspace, run:
hex project import hex_export/hex-analysis.yaml
```

Or use the Hex UI: **Settings → Import Project** and select the YAML file.

## Limitations

- **SQL cells** use Hex-specific syntax (`SELECT * FROM pandas_df`) and will not run outside Hex.
- For local execution, use the Python scripts in `analysis/` which implement the same logic using standard pandas/numpy workflows.
- The YAML contains Hex-specific metadata (cell IDs, project IDs, connection configs) — these are handled automatically on re-import and should not be manually edited.

## Note on Personal Information

This export has been reviewed and contains no personal email addresses, passwords, API keys, or other sensitive information. The original dataset (Olist Brazilian E-Commerce Public Dataset) is publicly available on Kaggle.
