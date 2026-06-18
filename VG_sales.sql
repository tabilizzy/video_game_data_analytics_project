
--Creating the Initial Table
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

-- Importing the CSV Data
COPY VG_sales (Rank, Name, Platform, Year, Genre, Publisher, NA_Sales, EU_Sales, JP_Sales, Other_Sales, Global_Sales)
FROM 'C:\Program Files\PostgreSQL\VG Sales Dataset.csv'
DELIMITER ','
CSV HEADER;

SELECT * FROM VG_sales;

--Creating a Copy
CREATE TABLE VG_sales_copy AS
SELECT *
FROM VG_sales;

SELECT * FROM VG_sales_copy;

-- Identifying Duplicates
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

-- removing Duplicates
WITH duplicates AS (
    SELECT Rank,
           ROW_NUMBER() OVER(
               PARTITION BY Name, Platform, Year
               ORDER BY Rank
           ) AS rn
    FROM VG_sales_copy
)
DELETE FROM VG_sales_copy
WHERE Rank IN (
    SELECT Rank 
    FROM duplicates 
    WHERE rn > 1
);

--Standardizing and Changing Data Types for the year and publisher
UPDATE VG_sales_copy 
SET "year" = NULL 
WHERE "year" = 'N/A' 
   OR "year" = 'null' 
   OR TRIM("year") = '';

ALTER TABLE VG_sales_copy 
ALTER COLUMN year
TYPE DATE USING (TO_DATE(year, 'YYYY'));

SELECT * FROM VG_sales_copy;

-- Handling Missing Text Data
UPDATE VG_sales_copy
SET publisher = 'Unknown'
WHERE publisher IS NULL;

--Puting Missing Sales Figures
UPDATE VG_sales_copy
SET na_sales = (
    SELECT AVG(na_sales)
    FROM VG_sales_copy
)
WHERE na_sales IS NULL;


UPDATE VG_sales_copy
SET eu_sales = (
    SELECT AVG(eu_sales)
    FROM VG_sales_copy
)
WHERE eu_sales IS NULL;

UPDATE VG_sales_copy
SET jp_sales = (
    SELECT AVG(jp_sales)
    FROM VG_sales_copy
)
WHERE jp_sales IS NULL;

UPDATE VG_sales_copy
SET other_sales = (
    SELECT AVG(other_sales)
    FROM VG_sales_copy
)
WHERE other_sales IS NULL;

UPDATE VG_Sales
SET global_sales = (
    SELECT AVG(global_sales)
    FROM VG_sales_copy
)
WHERE global_sales IS NULL;

SELECT * FROM VG_sales_copy;

