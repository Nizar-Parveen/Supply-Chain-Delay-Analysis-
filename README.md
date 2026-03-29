# Supply-Chain-Delay-Analysis-
Identify causes of delays in supply chain operations (SQL + Python + Pandas)

# Supply Chain Delay Analysis

## Overview
This project analyzes supply chain shipment data to identify delivery delays and improve logistics performance using SQL, Python and Pandas.

## Objectives
- Identify delayed shipments
- Calculate delay duration
- Analyze supplier performance
- Find high-risk suppliers
- Analyze delay trends by location and month

## Tools Used
- SQL (MySQL)
- Python
- Pandas

## Dataset
The project uses 3 datasets:
- Suppliers (supplier_id, supplier_name, location)
- Orders (order_id, customer_id, order_date, expected_delivery_date)
- Shipments (shipment_id, order_id, supplier_id, shipped_date, delivered_date)

## Process
1. Load CSV data using Pandas
2. Merge datasets using order_id and supplier_id
3. Calculate delay:
   delay_days = delivered_date - expected_delivery_date
4. Filter delayed shipments (delay_days > 0)

## Analysis
- Supplier-wise delay trend
- Location-wise delay analysis
- Monthly delay trend
- High-risk suppliers (avg delay > 3 days)

## Outcome
- Identified delay patterns
- Found high-risk suppliers
- Provided insights to improve logistics efficiency


## Summary
This project uses SQL and Python to analyze supply chain delays and generate useful business insights.
