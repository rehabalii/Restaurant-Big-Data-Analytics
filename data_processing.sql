-- Merge data
CREATE TABLE restaurant_bronze AS 
SELECT * FROM restaurant1
UNION ALL
SELECT * FROM restaurant2;

-- Add date features
ALTER TABLE restaurant_bronze
ADD COLUMNS (
  year INT,
  month INT,
  day_name STRING
);

UPDATE restaurant_bronze
SET
  year = year(order_date),
  month = month(order_date),
  day_name = date_format(order_date,'EEEE');

-- Final table
CREATE OR REPLACE TABLE restaurant AS
SELECT *,
       date_format(order_date, 'MMM') AS month_name
FROM restaurant_bronze;

-- Add flags
ALTER TABLE restaurant 
ADD COLUMNS (weekend_flag STRING);

UPDATE restaurant
SET weekend_flag = 
    CASE 
        WHEN is_weekend = 1 THEN 'Yes'
        ELSE 'No'
    END;

ALTER TABLE restaurant
ADD COLUMNS (day_number INT);

UPDATE restaurant
SET day_number = dayofweek(order_date);