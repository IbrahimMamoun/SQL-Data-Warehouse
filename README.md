# SQL Data Warehouse Project

## Project Overview

This project demonstrates the design and implementation of a modern SQL Server Data Warehouse using the Medallion Architecture (Bronze, Silver, and Gold layers).

The project integrates sales data from two source systems (CRM and ERP), processes and cleans the data through an ETL pipeline, and transforms it into an analytics-ready data model using a Star Schema.

## Technologies & Tools

- SQL Server
- SQL
- SQL Server Management Studio (SSMS)
- Draw.io
- Git & GitHub

## Data Architecture

The project follows the Medallion Architecture, consisting of three layers:

1. **Bronze Layer:** Stores raw data ingested from CRM and ERP CSV files into SQL Server.
2. **Silver Layer:** Performs data cleansing, standardization, validation, and transformation.
3. **Gold Layer:** Contains business-ready data modeled into fact and dimension tables using a Star Schema.
![Uploading data_architecture.png…]()


## Project Components

- Database architecture and design.
- ETL pipeline implementation.
- Data ingestion using BULK INSERT and Stored Procedures.
- Data cleansing and transformation.
- Fact and Dimension table development.
- Star Schema data modeling.
- SQL-based analytical queries and data quality checks.

## Repository Structure

- `datasets/` – CRM and ERP source data.
- `docs/` – Project documentation and architecture diagrams.
- `scripts/` – SQL scripts organized into Bronze, Silver, and Gold layers.
- `tests/` – Data quality checks and validation scripts.

## Learning Outcomes

Through this project, I gained hands-on experience in:

- Building a SQL Server Data Warehouse.
- Implementing ETL workflows.
- Applying Medallion Architecture.
- Data cleansing and transformation.
- Dimensional data modeling.
- Writing analytical SQL queries.

## Credits & Acknowledgment

This project was implemented as a hands-on learning project based on the tutorial created by **Baraa Khatib Salkini (Data with Baraa)**.

The original tutorial provided the project framework, requirements, and architectural guidance. Some diagrams and visual documentation were also referenced from the original project.

**Original Project:** [Data Warehouse and Analytics Project – GitHub](https://github.com/DataWithBaraa/sql-data-warehouse-project)

**Original Tutorial:** [SQL Data Warehouse from Scratch – YouTube](https://www.youtube.com/watch?v=9GVqKuTVANE)

