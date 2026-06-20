# 🍽️ Zomato Restaurant Analytics Project

## 📖 Project Overview

This project focuses on analyzing Zomato restaurant data to uncover insights related to restaurant performance, customer preferences, ratings, cuisines, pricing, and city-wise trends.

The project follows a complete end-to-end data analytics workflow:

**Excel → Python (Jupyter Notebook) → MySQL → Power BI**

The final output is an interactive Power BI dashboard that provides valuable business insights for restaurant owners and decision-makers.

---

# 🎯 Business Problem

Restaurant businesses generate large volumes of operational data. Without proper analysis, it becomes difficult to answer important business questions such as:

* Which cities have the highest number of restaurants?
* Which cuisines are most popular?
* Which restaurants receive the highest ratings?
* How do prices vary across locations?
* Which countries contribute the most restaurants?
* What factors influence restaurant ratings?

This project transforms raw Zomato data into actionable business insights.

---

# 🛠 Tools & Technologies

| Tool             | Purpose               |
| ---------------- | --------------------- |
| Excel            | Data Cleaning         |
| Python (Pandas)  | Data Transformation   |
| Jupyter Notebook | Data Processing       |
| MySQL            | Data Storage          |
| SQL              | Data Analysis         |
| Power BI         | Dashboard Development |

---

# 📂 Project Workflow

## Step 1: Data Cleaning in Excel

Performed:

* Removed duplicates
* Handled missing values
* Standardized column names
* Corrected data inconsistencies
* Prepared dataset for analysis

---

## Step 2: Data Processing using Python

Imported Excel data into Jupyter Notebook and performed:

* Feature engineering
* Data transformation
* Data type conversion
* Missing value handling
* Column renaming
* Dataset preparation for SQL

Libraries used:

```python
import pandas as pd
import numpy as np
```

---

## Step 3: Data Storage in MySQL

Created database:

```sql
CREATE DATABASE zomato_db;
```

Imported processed data from Python into MySQL.

---

## Step 4: SQL Analysis

Used SQL queries to answer business questions such as:

* Top-rated restaurants
* Restaurant count by city
* Cuisine popularity analysis
* Average cost analysis
* Country-wise distribution
* Rating distribution
* Online delivery analysis

---

## Step 5: Power BI Dashboard

Built an interactive dashboard containing:

### KPI Cards

* Total Restaurants
* Average Rating
* Average Cost
* Number of Cities
* Number of Countries

### Visualizations

* Restaurants by City
* Rating Distribution
* Cuisine Analysis
* Country-wise Restaurants
* Online Delivery Analysis
* Price Range Analysis

---

# 📈 Key Insights

### Customer Preferences

* Certain cuisines dominate customer demand.
* High-rated restaurants are concentrated in specific cities.

### Pricing Analysis

* Restaurant costs vary significantly across regions.
* Mid-range restaurants form the majority.

### Geographic Analysis

* A few countries account for most restaurants.
* Major cities contribute the largest share.

### Service Analysis

* Online delivery availability differs considerably across locations.

---

# 📊 Dashboard

The Power BI dashboard provides interactive analysis for:

* Restaurant Performance
* Cuisine Popularity
* Rating Trends
* Geographic Distribution
* Pricing Insights

---

# Future Enhancements

* Restaurant recommendation system
* Sentiment analysis on reviews
* Predictive rating models
* Customer segmentation
* Real-time dashboard integration

---

# 👩‍💻 Author

**Dr. Monika Yadav**

### Skills Demonstrated

* Excel
* Python
* Pandas
* SQL
* MySQL
* Power BI
* Data Cleaning
* Data Analysis
* Data Visualization
* Dashboard Development

This project demonstrates an end-to-end data analytics workflow from raw data preparation to business intelligence reporting.

