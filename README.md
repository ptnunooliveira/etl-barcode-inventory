# etl-barcode-inventory

**Food stock management system integrating barcode scanning and ETL pipelines for data extraction, transformation, and loading.**

---

## 📌 Project Context & Social Impact

This project is part of a larger system currently being developed for a **social organization dedicated to helping individuals and families in need**. 

The main goal of this module is to optimize food stock management. By automating barcode scanning and enriching the data through an external API (Open Food Facts), the system prevents food waste, tracks expiration dates efficiently, and ensures that the organization can better manage its inventory to serve vulnerable families.

This repository was also developed as the **Practical Assignment I** for the **Information Systems Integration (ISI)** course in the Information Systems Engineering degree at **UPCA** (2026/27).

## 🚀 Objectives
- Consolidate concepts related to Data Integration.
- Analyze and implement practical ETL (Extract, Transform, Load) scenarios.
- Explore middleware technologies (Node-RED) and data processing tools (KNIME).
- Provide a scalable architecture that bridges physical scanning with database persistence.

## 🏗️ Architecture & ETL Phases

This project implements a complete data lifecycle divided into three mandatory phases:

### Phase 1: Data Extraction & Preparation ("E")
- **Node-RED Middleware:** Acts as the entry point, listening for incoming barcode scans.
- **External API Rest:** Fetches detailed product information dynamically from the Open Food Facts API based on the scanned EAN/Barcode.
- **Local Storage / Raw Data:** The Node-RED flow writes the raw JSON responses into a `.jsonl` file (JSON Lines) as an initial staging area.
- **Manual Data Source:** A secondary `CSV` file is maintained for expiration dates and batch details, demonstrating the ingestion of multiple, heterogeneous data formats.

### Phase 2: Data Processing & Transformation ("T")
- **KNIME Analytics Platform:** Serves as the core ETL engine.
- **Data Merging (Joins):** Uses the barcode as a matching key to join the API's JSON data with the manual CSV data.
- **Data Cleansing:** Filters out unnecessary fields, handles null values, and normalizes text properties (e.g., product names, brands) using Regular Expressions (Regex).
- **Data Conversion:** Transforms strings to proper Date&Time formats for the expiration dates.

### Phase 3: Persistence & Loading ("L")
- **PostgreSQL Database:** The transformed and unified data is loaded into a relational database, making it available for the social entity's main management dashboards.
- **Error Handling (Try/Catch):** The KNIME workflow implements error trapping during the database insertion.
- **Log Generation:** Any failed inserts are caught and exported to a secondary `CSV` log file for auditing purposes.

## 🛠️ Technologies & Tools
- **Node-RED:** Event-driven data ingestion and API requests.
- **KNIME:** Batch processing, data transformation, and cleaning.
- **PostgreSQL:** Final persistence layer.
- **Open Food Facts API:** External REST API for product cataloging.

## 👨‍💻 Author
- *Nuno Oliveira - 31550*
- **Course:** Information Systems Engineering (3rd Year) - UPCA
- **Course Unit:** Information Systems Integration (ISI)
