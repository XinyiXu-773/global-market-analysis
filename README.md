# Global Market Analysis & Trade Segmentation

This project analyses global manufacturing output, trade flows, and GDP patterns
to identify international market opportunities and structural trade differences
across countries.

The project combines **interactive Power BI dashboards** with **R-based k-means
segmentation** to support data-driven market expansion and entry strategy decisions.

---

## Dashboard Preview (no download required)

![Overview](images/01_overview.png)

### Interactive features
![Region filter](images/02_filter_region.png)
![Cluster comparison](images/03_cluster_comparison.png)
![Drill-through](images/04_drillthrough.png)

### Short interactive demo
![Interactive demo](images/05_interactive_demo.gif)

> The full interactive Power BI dashboard is available in  
> `powerbi/global_market_dashboard.pbix` (tracked via Git LFS).  
> Power BI Desktop is required to open the `.pbix` file.

---

## Analytical Approach

1. **Data collection & preparation**
   - Collected international datasets covering manufacturing output, trade balance,
     and GDP indicators
   - Cleaned, reshaped, and consolidated data using Excel and Power BI
   - Created analytical fields and measures using DAX

2. **Segmentation analysis (R)**
   - Applied **k-means clustering** in R to segment countries based on:
     - Manufacturing scale
     - Trade balance characteristics
     - Economic indicators
   - Evaluated cluster patterns and economic meaning
   - Exported cluster results for integration with BI visuals

3. **Visual analytics & interpretation**
   - Integrated segmentation results back into Power BI
   - Designed interactive dashboards with:
     - Slicers and cross-filtering
     - Comparative cluster views
     - Drill-through and tooltip interactions
   - Interpreted results to support market prioritisation and entry strategy insights

---

## Key Insights

- Countries can be grouped into distinct market segments with different
  manufacturing and trade profiles
- High manufacturing output does not always correspond to a trade surplus
- Segmentation highlights markets that may require differentiated entry
  strategies rather than a one-size-fits-all approach

---

## Repository Structure

```text
powerbi/        # Power BI dashboard (.pbix, Git LFS tracked)
analysis/       # R scripts for clustering and segmentation
data/           # Cleaned and merged datasets used for analysis
presentation/   # Project presentation slides
images/         # Dashboard screenshots and GIF demo
