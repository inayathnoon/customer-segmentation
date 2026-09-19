# Customer Segmentation via RFM

Segment customers into actionable groups using Recency, Frequency, Monetary (RFM) analysis. **Question:** Which customers are your most valuable? Which are at risk of churning?

RFM + clustering reveals behavioral segments with distinct value and engagement patterns.

---

## The RFM Framework

| Metric | Definition | Formula | Insight |
|--------|-----------|---------|---------|
| **Recency (R)** | Days since last purchase | `TODAY - MAX(order_date)` | Recently active customers engage more |
| **Frequency (F)** | Number of purchases | `COUNT(orders)` | Frequent buyers are loyal |
| **Monetary (M)** | Total spent | `SUM(order_value)` | High-spenders are most valuable |

**Scoring:** Each metric scored 1-5 (1 = worst, 5 = best).

---

## Segments

Based on RFM scores:

| Segment | Recency | Frequency | Monetary | Action |
|---------|---------|-----------|----------|--------|
| **Champions** | High | High | High | VIP treatment, loyalty programs, ask for referrals |
| **Loyal** | Any | High | Medium+ | Upsell, cross-sell, reward loyalty |
| **At Risk** | Low | Was high | Medium+ | Win-back campaign, special offer |
| **Potential** | High | Low | Low | Nurture, introductory offers, build engagement |
| **Lost** | Very low | Any | Any | Re-engagement campaign, or archive |

---

## Core Queries

### 1. RFM Calculation
```sql
sql/rfm_calculation.sql
```
Computes recency, frequency, monetary + RFM scores for every customer.

### 2. Customer Segments
```sql
sql/customer_segments.sql
```
Maps RFM scores to segments (Champions, Loyal, At Risk, Potential, Lost).

### 3. Segment Summary
```sql
sql/segment_summary.sql
```
High-level view: segment size, average LTV, average purchase count, inactivity rate.

---

## Python Module

`src/segmentation.py` provides:

- **RFMSegmentation** – KMeans clustering on RFM
- **rfm_scoring()** – Quantile-based RFM scoring

```python
from src.segmentation import rfm_scoring

df = rfm_scoring(df)  # Adds r_score, f_score, m_score, rfm_segment
```

---

## Notebook

`notebooks/01_rfm_segmentation.ipynb`:
- RFM statistics
- Segment distribution bar chart
- Monetary value by segment (box plot)
- Recency vs. Frequency scatter plot
- Segment summary table

---

## Use Cases

### Marketing
- **Champions:** VIP emails, exclusive deals, early access
- **Loyal:** Upsell higher-tier products
- **At Risk:** Win-back offer (20% off return purchase)
- **Potential:** Nurture sequence, educational content
- **Lost:** Archive or one-time re-engagement blast

### Product
- **Champions:** Beta test new features
- **Loyal:** Gather feedback via surveys
- **At Risk:** Exit surveys (why did they stop?)
- **Potential:** Onboarding improvements
- **Lost:** Analyze what went wrong

### Finance
- **Champions:** Highest LTV, target for upsell
- **Potential:** Growth opportunity (low spend, recent)
- **At Risk:** Risk of revenue loss
- **Lost:** Write-off, low CAC payback

---

## Metrics & Interpretation

**Segment Size**
- Large "Potential" segment = growth opportunity
- Large "Lost" segment = retention problem

**Average LTV by Segment**
- Champions should be 2-5x higher than Potential
- If gaps are small, segmentation isn't working well

**Recency Trend**
- If "Champions" recency is increasing (less recent activity), they're at risk
- Flag for immediate re-engagement

---

## Schema (Synthetic Data)

- **customers** – customer_id, email, signup_date
- **orders** – order_id, customer_id, order_date, order_value

100k+ synthetic customers with realistic RFM distributions.

---

## Next Steps

- Add **propensity modeling** – predict likelihood of purchase in next 30 days
- **Lifetime value projection** – forecast 12-month LTV per segment
- **A/B test segments** – measure win-back offer effectiveness
- **Real-time segmentation** – update segment assignments nightly

---

## License

MIT
