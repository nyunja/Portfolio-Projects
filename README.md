# Data Analysis Projects

This repository contains a collection of data analysis projects showcasing SQL and Python skills for data exploration, cleaning, and visualization.

## Projects

### 1. COVID-19 Data Analysis

#### Overview
This project analyzes COVID-19 data to explore various aspects of the pandemic, including infection rates, death rates, vaccination progress, and correlations with socio-economic factors.

#### Key Features
- Joins data from multiple tables (CovidDeaths and CovidVaccinations)
- Calculates infection and death percentages
- Analyzes data by country and continent
- Explores correlations between COVID-19 impact and factors like poverty and healthcare infrastructure
- Creates views for later visualization

#### Technologies Used
- SQL (Microsoft SQL Server)

#### Notable Queries
- Comparison of extreme poverty levels with access to handwashing facilities
- Analysis of hospital bed availability vs. weekly hospital admissions
- Calculation of infection rates and death percentages
- Global and country-specific COVID-19 statistics

### 2. National Housing Data Cleaning

#### Overview
This project focuses on cleaning and standardizing a dataset of national housing information.

#### Key Features
- Removes duplicates
- Standardizes date formats
- Populates missing property addresses
- Breaks out address components (Address, City, State)
- Simplifies "Sold as Vacant" field values
- Removes unused columns

#### Technologies Used
- SQL (Microsoft SQL Server)

#### Notable Operations
- Using self-joins to populate missing data
- Leveraging PARSENAME for string splitting
- Employing CTEs and window functions for duplicate removal

## Setup and Usage

1. Ensure you have access to a SQL Server instance.
2. Import the provided datasets into your SQL Server.
3. Run the SQL scripts in your preferred SQL client (e.g., SQL Server Management Studio).

## Future Work

- Develop visualizations based on the created views
- Perform more advanced statistical analyses
- Integrate machine learning models for predictive analytics