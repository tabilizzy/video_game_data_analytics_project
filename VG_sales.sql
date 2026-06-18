CREATE TABLE VG_sales(
id SERIAL PRIMARY KEY,
Rank INTEGER,
Name TEXT,
Platform TEXT,
Year TEXT,
Genre TEXT,
Publisher TEXT,
NA_Sales DECIMAL,
EU_Sales DECIMAL,
JP_Sales DECIMAL,
Other_Sales DECIMAL,
Global_Sales DECIMAL
);

COPY VG_sales (Rank, Name, Platform, Year, Genre, Publisher, NA_Sales, EU_Sales, JP_Sales, Other_Sales, Global_Sales)
FROM 'C:\Program Files\PostgreSQL\VG Sales Dataset.csv'
DELIMITER ','
CSV HEADER;

SELECT * FROM VG_sales;

CREATE TABLE VG_sales_copy AS
SELECT *
FROM VG_sales;

SELECT * FROM VG_sales_copy;

WITH duplicates AS (
    SELECT *,
           ROW_NUMBER() OVER(
               PARTITION BY Name, Platform, Year
               ORDER BY Rank
           ) AS rn
    FROM VG_sales_copy
)
SELECT * FROM duplicates
WHERE rn > 1;

WITH duplicates AS (
    SELECT *,
           ROW_NUMBER() OVER(
               PARTITION BY Name, Platform, Year
               ORDER BY Rank
           ) AS rn
    FROM VG_sales_copy
)
DELETE FROM duplicates
WHERE rn > 1;
