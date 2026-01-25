import pandas as pd

# =========================
# 1. LOAD DATA
# =========================

shipments = pd.read_csv("shipments.csv", parse_dates=["shipped_date","delivered_date"])
orders = pd.read_csv("orders.csv", parse_dates=["order_date","expected_delivery_date"])
suppliers = pd.read_csv("suppliers.csv")

# =========================
# 2. JOIN TABLES
# =========================

df = shipments.merge(orders, on="order_id") \
              .merge(suppliers, on="supplier_id")

# =========================
# 3. DELAY CALCULATION
# =========================

df["delay_days"] = (df["delivered_date"] - df["expected_delivery_date"]).dt.days

# =========================
# 4. ONLY DELAYED SHIPMENTS
# =========================

delayed_df = df[df["delay_days"] > 0]

# =========================
# 5. SUPPLIER-WISE DELAY TREND
# =========================

supplier_trend = df.groupby("supplier_name").agg(
    total_shipments=("shipment_id","count"),
    avg_delay_days=("delay_days","mean"),
    delayed_shipments=("delay_days", lambda x: (x > 0).sum())
).reset_index()

supplier_trend = supplier_trend.sort_values("avg_delay_days", ascending=False)

# =========================
# 6. LOCATION-WISE DELAY TREND
# =========================

location_trend = df.groupby("location")["delay_days"].mean().reset_index()
location_trend = location_trend.sort_values("delay_days", ascending=False)

# =========================
# 7. MONTHLY DELAY TREND
# =========================

df["order_month"] = df["order_date"].dt.to_period("M")

monthly_trend = df.groupby("order_month")["delay_days"].mean().reset_index()

# =========================
# 8. HIGH-RISK SUPPLIERS
# =========================

high_risk = supplier_trend[supplier_trend["avg_delay_days"] > 3]

# =========================
# 9. OUTPUT
# =========================

print("\n--- DELAYED SHIPMENTS ---")
print(delayed_df[["shipment_id","supplier_name","delay_days"]].head())

print("\n--- SUPPLIER TREND ---")
print(supplier_trend.head())

print("\n--- LOCATION TREND ---")
print(location_trend.head())

print("\n--- MONTHLY TREND ---")
print(monthly_trend.head())

print("\n--- HIGH RISK SUPPLIERS ---")
print(high_risk)
