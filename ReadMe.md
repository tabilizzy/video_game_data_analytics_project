# Video Game Sales Data Cleaning and Visualization
Dual-approach data cleaning using SQL (PostgreSQL) and Python (Pandas) to initialize, clean, and standardize global video game sales information.

##  Project Overview
This repository contains workflows designed to transform raw video game sales datasets into clean, query-ready formats. It addresses data engineering challenges like duplication, handling missing values, standardizing dates, and filling gaps using numerical calculations (mean/median).

##  Tech Methods
This project offers two separate implementations :

   1. Database Approach: PostgreSQL for relational database environments.
   2. Scripting Approach: Python 3.x and Pandas .


##  1. PostgreSQL Workflow## Database Schema (Target)

| Column Name | Data Type | Constraints / Modifiers | Description |
|---|---|---|---|
| id | INTEGER | SERIAL PRIMARY KEY | Auto-incrementing internal system key |
| Rank | INTEGER | None | Original global sales ranking |
| Name | TEXT | NOT NULL | Title of the video game |
| Platform | TEXT | None | Console or hardware platform |
| Year | DATE | Evaluated using YYYY | Release year converted to ISO Date |
| Genre | TEXT | None | Game genre category |
| Publisher | TEXT | Default: 'Unknown' | Video game publisher |
| NA_Sales | DECIMAL | Imputed via AVG() | North American sales (in millions) |
| EU_Sales | DECIMAL | Imputed via AVG() | European Union sales (in millions) |
| JP_Sales | DECIMAL | Imputed via AVG() | Japan sales (in millions) |
| Other_Sales | DECIMAL | Imputed via AVG() | Other regional sales (in millions) |
| Global_Sales | DECIMAL | Imputed via AVG() | Worldwide sales total (in millions) |

## Execution Steps

* Creating table to contain input from the csv file.
* Uses COPY commands to pull records quickly from the CSV file.
* Duplicating raw data into a staging table (VG_sales_copy) to protect production records.
* Using window functions (ROW_NUMBER() OVER PARTITION BY) to track down and eliminate repeating records.
* Removing invalid values (e.g., 'N/A') for database NULL markers, reformats years into true DATE fields, and fills missing regional sales with the column's statistical mean (average).

##  2. Python & Pandas Workflow

* Drops precise duplicate rows using df.drop_duplicates().
* Replaces blank years with the dataset's median year to reduce the impact of extreme outliers. It then casts years into clean integers.
* Fills missing Publisher data fields with the fallback string 'Unknown'.
* Loops through all regional and global sales metrics, plugging remaining gaps with column-specific median sales figures.

## 3. Visulization with Tableau 
[Click here to View Dashboard](https://public.tableau.com/app/profile/isabel2946/viz/VisualisingSurveyData_16922855644490/VisualisingLikertScales)

* Sheet 1: Global Sales Trend Over Time using a Line chart
Insight:
Gaming sales surged between 2005–2010, driven largely by Wii, DS, Xbox 360, and PS3 releases

* Sheet 2: Top Platforms by Sales using a Horizontal Bar Chart
Insight:
Wii, PS2, DS, and Xbox 360 dominate lifetime sales

* Sheet 3: Genre Performance using a Treemap
Insight:
Action and Sports games contribute the largest share of global revenue.

* Sheet 4: Publisher Market Share using a Packed Bubble Chart
Insight:
Nintendo, Electronic Arts, and Activision control a significant portion of the market.

* Sheet 5: Top Selling Games using a Bar Chart
Insight:
Wii Sports remains the highest-selling game globally

* Sheet 6: Regional Sales Comparison using a Bar Chart
Insight:
North America consistently generates the highest sales volume, while Japan shows strong preference for specific franchises


