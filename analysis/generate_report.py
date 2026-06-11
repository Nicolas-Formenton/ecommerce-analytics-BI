"""
Olist Brazilian E-Commerce — Report Generation

Generates Markdown and PDF report files from the Olist customer analytics pipeline.
Must be run AFTER (or imports from) olist_cx_analytics.py.

Originally from Hex cells 9 ("Export Markdown and PDF report") and 10 ("Download report files").

Requirements:
    pip install -r requirements.txt

Usage:
    python analysis/generate_report.py
"""

import textwrap
import zipfile
from pathlib import Path

import numpy as np
import pandas as pd
from matplotlib.backends.backend_pdf import PdfPages

# Guard IPython imports — not available in standalone Python
try:
    from IPython.display import HTML  # noqa: F401
    _has_ipython = True
except ImportError:
    _has_ipython = False

# Import all analysis results (triggers the full pipeline)
from olist_cx_analytics import (  # noqa: F402
    OUTPUT_DIR,
    executive_summary_df,
    forecast_model_used,
    model_metrics_df,
    plot_files,
    report_manifest_df,
    segment_summary_df,
    # scalars
    churn_rate,
    customers_count,
    late_delivery_rate,
    orders_count,
    repeat_customer_rate,
    total_revenue,
)


def generate_report():
    """Generate Markdown report and multi-page PDF with executive summary, model metrics, and visualizations."""
    report_md_path = OUTPUT_DIR / "olist_customer_analytics_report.md"
    report_pdf_path = OUTPUT_DIR / "olist_customer_analytics_report.pdf"

    summary_lines = [
        "# Olist Brazilian E-Commerce Customer Analytics Report",
        "",
        "## Executive summary",
        "",
        executive_summary_df.to_markdown(index=False),
        "",
        "## Model performance",
        "",
        model_metrics_df.to_markdown(index=False),
        "",
        "## RFM segment summary",
        "",
        segment_summary_df.to_markdown(index=False),
        "",
        "## Forecast methodology",
        "",
        f"Forecast model used: {forecast_model_used}",
        "",
        "## Exported analysis artifacts",
        "",
        report_manifest_df.to_markdown(index=False),
        "",
        "## Visualizations",
        "",
    ]

    for plot_file in plot_files:
        plot_path = Path(plot_file)
        summary_lines.extend([
            f"### {plot_path.stem.replace('_', ' ').title()}",
            "",
            f"![{plot_path.stem}]({plot_path.name})",
            "",
        ])

    report_md_path.write_text("\n".join(summary_lines), encoding="utf-8")
    print(f"Markdown report saved: {report_md_path}")

    # --- PDF generation ---

    def _pdf_text_page(pdf, title, lines, fontsize=11):
        fig = plt.figure(figsize=(11, 8.5))
        ax = fig.add_axes([0, 0, 1, 1])
        ax.axis("off")
        y = 0.94
        ax.text(0.05, y, title, fontsize=18, fontweight="bold", va="top")
        y -= 0.07
        for line in lines:
            wrapped = textwrap.wrap(str(line), width=115) or [""]
            for chunk in wrapped:
                ax.text(0.05, y, chunk, fontsize=fontsize, va="top")
                y -= 0.028
                if y < 0.06:
                    pdf.savefig(fig, bbox_inches="tight")
                    plt.close(fig)
                    fig = plt.figure(figsize=(11, 8.5))
                    ax = fig.add_axes([0, 0, 1, 1])
                    ax.axis("off")
                    y = 0.94
        pdf.savefig(fig, bbox_inches="tight")
        plt.close(fig)

    def _pdf_dataframe_page(pdf, title, df, max_rows=12):
        display_df = df.head(max_rows).copy()
        fig, ax = plt.subplots(figsize=(11, 8.5))
        ax.axis("off")
        ax.set_title(title, fontsize=18, fontweight="bold", pad=20)
        table = ax.table(
            cellText=display_df.astype(str).values,
            colLabels=display_df.columns,
            loc="center",
            cellLoc="left",
            colLoc="left",
        )
        table.auto_set_font_size(False)
        table.set_fontsize(7.5)
        table.scale(1, 1.35)
        pdf.savefig(fig, bbox_inches="tight")
        plt.close(fig)

    def _pdf_image_page(pdf, title, image_path):
        img = plt.imread(image_path)
        fig, ax = plt.subplots(figsize=(11, 8.5))
        ax.imshow(img)
        ax.axis("off")
        ax.set_title(title, fontsize=16, fontweight="bold", pad=12)
        pdf.savefig(fig, bbox_inches="tight")
        plt.close(fig)

    import matplotlib.pyplot as plt  # noqa: F811

    with PdfPages(report_pdf_path) as pdf:
        _pdf_text_page(
            pdf,
            "Olist Brazilian E-Commerce Customer Analytics Report",
            [
                f"Revenue: BRL {total_revenue:,.0f}",
                f"Delivered orders: {orders_count:,}",
                f"Unique customers: {customers_count:,}",
                f"Repeat customer rate: {repeat_customer_rate:.1%}",
                f"Churn proxy rate: {churn_rate:.1%}",
                f"Late delivery rate: {late_delivery_rate:.1%}",
                f"Forecast method: {forecast_model_used}",
            ],
            fontsize=12,
        )
        _pdf_dataframe_page(pdf, "Executive insights and CX recommendations", executive_summary_df, max_rows=8)
        _pdf_dataframe_page(pdf, "Model performance", model_metrics_df, max_rows=8)
        _pdf_dataframe_page(pdf, "RFM segment summary", segment_summary_df, max_rows=8)
        for plot_file in plot_files:
            plot_path = Path(plot_file)
            if plot_path.exists():
                _pdf_image_page(pdf, plot_path.stem.replace("_", " ").title(), plot_path)
        _pdf_dataframe_page(pdf, "Export manifest", report_manifest_df, max_rows=4)

    print(f"PDF report saved: {report_pdf_path}")

    report_file_exports_df = pd.DataFrame([
        {"file_type": "Markdown", "file_path": str(report_md_path), "file_size_bytes": report_md_path.stat().st_size},
        {"file_type": "PDF", "file_path": str(report_pdf_path), "file_size_bytes": report_pdf_path.stat().st_size},
    ])

    print("\nReport files generated:")
    print(report_file_exports_df.to_string(index=False))

    return report_md_path, report_pdf_path


def package_download_files(report_md_path, report_pdf_path):
    """Create a ZIP archive of the report files."""
    report_zip_path = OUTPUT_DIR / "olist_customer_analytics_report_files.zip"
    files_to_zip = [report_md_path, report_pdf_path]

    with zipfile.ZipFile(report_zip_path, "w", compression=zipfile.ZIP_DEFLATED) as zf:
        for file_path in files_to_zip:
            zf.write(file_path, arcname=file_path.name)

    report_downloads_df = pd.DataFrame([
        {"file_type": "Markdown", "file_name": report_md_path.name, "file_path": str(report_md_path), "file_size_bytes": report_md_path.stat().st_size},
        {"file_type": "PDF", "file_name": report_pdf_path.name, "file_path": str(report_pdf_path), "file_size_bytes": report_pdf_path.stat().st_size},
        {"file_type": "ZIP", "file_name": report_zip_path.name, "file_path": str(report_zip_path), "file_size_bytes": report_zip_path.stat().st_size},
    ])

    # Write an HTML download page for local use
    links_html_path = OUTPUT_DIR / "download_links.html"
    links_html = "<h3>Download report files</h3><ul>" + "".join(
        f'<li><a href="{row.file_path}" download>{row.file_type}: {row.file_name}</a></li>'
        for row in report_downloads_df.itertuples()
    ) + "</ul>"
    links_html_path.write_text(links_html, encoding="utf-8")

    print(f"\nDownload archive saved: {report_zip_path}")
    print(f"Download page saved: {links_html_path}")
    print(report_downloads_df.to_string(index=False))


if __name__ == "__main__":
    md_path, pdf_path = generate_report()
    package_download_files(md_path, pdf_path)
