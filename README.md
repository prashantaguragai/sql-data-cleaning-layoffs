# sql-data-cleaning-layoffs

## 📌 Project Overview
This project focuses on cleaning and exploring a real-world dataset of tech company layoffs (2020–2023) using MySQL. The raw data contained duplicates, inconsistent values, NULL entries, and incorrect data types — all of which were systematically identified and resolved. After cleaning, exploratory data analysis was performed to uncover key trends.


## 🛠️ Tools Used
MySQL — data cleaning and transformation
MySQL Workbench — query execution and result verification


## 📁 Project Structure
sql-data-cleaning-layoffs/
│
├── README.md
├── layoffs.csv                        # Original uncleaned dataset
└── layoffs_data_cleaning_and_eda.sql  # All cleaning and EDA queries


## 🔍 Cleaning Steps

### 1. Remove Duplicates
- Created a staging table to preserve the original raw data
- Used `ROW_NUMBER()` window function with `PARTITION BY` across all columns to flag duplicate rows
- Deleted rows where `row_num > 1`

### 2. Standardize Data
- Trimmed leading/trailing whitespace from company names using `TRIM()`
- Standardized inconsistent industry values (e.g. `Crypto Currency` → `Crypto`)
- Fixed country names with trailing punctuation (e.g. `United States.` → `United States`)
- Converted `date` column from `TEXT` to proper `DATE` type using `STR_TO_DATE()`

### 3. Handle NULL & Blank Values
- Used a **self-join** to populate NULL/blank industry values from matching company rows
- Converted remaining blank strings to NULL for consistency

### 4. Final Cleanup
- Dropped the `row_num` helper column after duplicates were removed


## 📊 Exploratory Data Analysis

After cleaning, the following questions were explored:

- Which companies had the most layoffs?
- Which industries were hit hardest?
- Which countries had the most layoffs?
- What does the layoff trend look like over time?
- What is the rolling total of layoffs month by month?
- Which were the top 5 companies with most layoffs each year?

---

## 💡 Key SQL Concepts Used
- Window Functions (`ROW_NUMBER`, `DENSE_RANK`, `SUM OVER`)
- CTEs (Common Table Expressions)
- Self-Joins
- String Functions (`TRIM`, `STR_TO_DATE`, `SUBSTRING`)
- DDL (`ALTER TABLE`, `MODIFY COLUMN`, `DROP COLUMN`)
- DML (`UPDATE`, `DELETE`, `INSERT INTO SELECT`)

---

## 📂 Dataset
- **Source:** Alex Freberg's Data Analyst Bootcamp
- **Contents:** Tech company layoffs including company, location, industry, total laid off, percentage laid off, date, stage, country, and funds raised


## 👤 Author
**Prashanta Guragai**
