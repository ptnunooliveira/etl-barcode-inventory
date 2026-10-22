# etl-barcode-inventory

**Food stock management system integrating barcode scanning and an ETL pipeline (Node-RED → KNIME → PostgreSQL → Grafana) for data extraction, transformation and loading.**

🎬 **Demo video:** [ETL-ISI-Stage1.mp4](https://alunosipca-my.sharepoint.com/personal/a31550_alunos_ipca_pt/_layouts/15/stream.aspx?id=%2Fpersonal%2Fa31550%5Falunos%5Fipca%5Fpt%2FDocuments%2FETL%2DISI%2DStage1%2Emp4&nav=eyJyZWZlcnJhbEluZm8iOnsicmVmZXJyYWxBcHAiOiJPbmVEcml2ZUZvckJ1c2luZXNzIiwicmVmZXJyYWxBcHBQbGF0Zm9ybSI6IldlYiIsInJlZmVycmFsTW9kZSI6InZpZXciLCJyZWZlcnJhbFZpZXciOiJNeUZpbGVzTGlua0NvcHkifX0&ga=1&referrer=StreamWebApp%2EWeb&referrerScenario=AddressBarCopied%2Eview%2E3789a15b%2D9a9a%2D4f4d%2D8a4c%2D9ff0421fd7d2)

📄 **Report:** [`doc/31550_doc.pdf`](doc/31550_doc.pdf)

---

## 👨‍💻 Author

| | |
|---|---|
| **Name** | Nuno Miguel Fernandes Oliveira |
| **Student number** | 31550 |
| **Course** | Information Systems Engineering (3rd year) – UPCA |
| **Course unit** | Information Systems Integration (ISI) – Practical Assignment I, 2026/27 |
| **Supervisor** | Prof. Luís Ferreira |

---

## 📌 Project context

This project is part of a larger system being developed for a **social organization that helps individuals and families in need**. The goal of this module is to optimize food stock management: barcode readings are enriched through an external REST API (Open Food Facts), normalized, validated and loaded into a relational database, so that expiration dates can be tracked and food waste reduced.

---

## 🏗️ Architecture & ETL phases

| Phase | Tool | What happens |
|---|---|---|
| **E – Extract** | Node-RED | Four HTTP endpoints receive barcode readings, call the Open Food Facts API and write intermediate files in **three formats**: CSV (confirmed stock), JSON Lines (API data) and XML (fresh products without barcode). |
| **T – Transform** | KNIME | Reading and validation (EAN-13), join of API and CSV data by EAN, duplicate removal, regex normalization of categories and product names (Rule Engine → code, dictionary → final name), unit conversion of the `size` field (Python script), missing values, error consolidation and execution metrics. |
| **L – Load** | KNIME + PostgreSQL | Ordered load (`products` before `inventory`, enforced with flow variables); quantities are summed through a staging table (`temp_inventory`) and `INSERT … ON CONFLICT`; rejected records go to `error_logs` and run metrics to `pipeline_executions`. |
| **Post-load** | KNIME | Excel report export, deletion of intermediate files and e-mail notification. |
| **Visualization** | Grafana | Dashboard with expiration dates, stock per category and pipeline execution statistics. |

The whole process is triggered by the `/end-session` endpoint: Node-RED launches KNIME (via an `exec` node) and the workflow runs automatically.

---

## 📁 Submitted files

```
tp01-31550/
├── README.md                     ← this file
├── doc/
│   └── 31550_doc.pdf             ← final report
├── dataintegration/
│   ├── knime/
│   │   ├── etl_food_stock/       ← KNIME workflow (transformations and jobs)
│   │   └── data/                 ← input and output files used by the workflow (relative paths)
│   └── node-red/                 ← Node-RED flows (extraction, endpoints, KNIME trigger)
├── src/
│   ├── sql/                      ← database schema / dump and load query
│   ├── python/                   ← Python script for unit conversion of the size field
│   ├── postman/                  ← Postman collection used to test the endpoints
│   └── grafana/                  ← Grafana dashboard export (JSON)
├── package.json                  ← Node.js dependencies (Node-RED)
└── package-lock.json
```

**About `data/input` and `data/output`:** the input and output files are kept in `dataintegration/knime/data/`, next to the workflow, because the KNIME workflow and the Node-RED flows use **relative paths** to that folder. It contains:
- **Inputs:** the normalization dictionaries (`categories_dictionary.xlsx`, `products_dictionary.xlsx`) and the files written by Node-RED during a session (CSV, JSON Lines, XML);
- **Outputs:** the Excel execution report.

Intermediate session files are deleted by the workflow at the end of each successful run.

---

## ⚙️ How to run

### Requirements
- **Node.js** (LTS) and npm
- **KNIME Analytics Platform** with the Python integration extension
- **PostgreSQL** (developed with version 18) and, optionally, pgAdmin
- **Grafana**
- **Postman**

### 1. Database
```bash
createdb -U postgres ISI-Stage1
psql -U postgres -d ISI-Stage1 -f src/sql/<dump_file>.sql
```

### 2. KNIME
1. Open KNIME and switch to the workspace `dataintegration/knime` (*File → Switch Workspace*).
2. Open the `etl_food_stock` workflow.
3. Configure the credentials in the **PostgreSQL Connector** and **Send Email** nodes.
4. Close KNIME **with the workflow open**, so that it is restored when Node-RED launches it.

### 3. Node-RED
```bash
npm install
npx node-red
```
Open http://localhost:1880 and, if needed, import the flows from `dataintegration/node-red/`.

In the **KNIME Start up** (`exec`) node, adjust the path to `knime.exe` and to the workspace for the machine where it runs. The command waits ~90 s for KNIME to open and then sends the shortcuts **Shift+F8** (reset) and **Shift+F7** (execute all); the waiting time may need to be increased on slower machines.

### 4. Run a counting session (Postman)
Import the collection from `src/postman/` and send the requests in this order:

| Request | Purpose |
|---|---|
| `POST /scan` – `{"ean": "5601049132995"}` | Looks up the product in the API |
| `POST /confirm-item` – `ean`, `quantity`, `expiration_date`, `api_data` (response of `/scan`) | Confirms the item (CSV + JSON) |
| `POST /add-fresh` – `product_name`, `category`, `quantity` | Registers a fresh product (XML) |
| `POST /end-session` – empty body | Closes the session and launches KNIME |

⚠️ Do not confirm the same product with the same expiration date twice in the same session.

### 5. Grafana
*Dashboards → New → Import*, upload the JSON from `src/grafana/` and select the PostgreSQL data source.

---

## ⚠️ Known limitations
- KNIME is launched through its **graphical interface** with simulated keyboard shortcuts, because batch mode returned errors; therefore Node-RED does not receive the result of the execution.
- Fresh products without an expiration date are stored with the conventional date **2099-12-31**, because `expiration_date` is part of the `inventory` key and cannot be null.
- The path to `knime.exe` in the `exec` node is machine-specific.

More details in the report (`doc/31550_doc.pdf`).

---

## 🛠️ Technologies
Node-RED · KNIME Analytics Platform · PostgreSQL · Grafana · Postman · Open Food Facts API · Python · GitHub
