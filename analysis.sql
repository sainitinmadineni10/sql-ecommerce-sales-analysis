-- =====================================
-- E-commerce Sales Analysis Project
-- =====================================

-- 1. Total Revenue & Profit
SELECT ROUND(SUM(sales),2) AS total_sales, ROUND(SUM(profit),2) AS total_profit
FROM samplesuperstore

-- 2. Profit Margin
SELECT ROUND(SUM(profit)*100/SUM(sales),2) AS Profit_Margin
FROM samplesuperstore

-- 3. If business is profitable overall...why are some area still loosing money-Profit by region
SELECT Region, ROUND(SUM(Profit),2) AS Profit
FROM samplesuperstore
GROUP BY Region
ORDER BY Profit DESC

ALTER TABLE samplesuperstore
RENAME COLUMN `Sub-Category` TO sub_category;

-- 4. Loss Making Category
SELECT Category, ROUND(SUM(Profit),2) as profit
FROM samplesuperstore
GROUP BY Category
Having profit<0
ORDER BY profit

-- 5. LOSS Making Sub-Category
SELECT Sub_Category, ROUND(SUM(Profit),2) as Profit
FROM samplesuperstore
GROUP BY Sub_Category
HAVING profit<0
ORDER BY profit

-- 6. Impact of discount on profit
SELECT Discount, ROUND(AVG(profit),2) AS Avgprofit
FROM samplesuperstore
GROUP BY Discount
ORDER BY Discount

-- 7. Top 5 profitable cities
SELECT City, Round(SUM(Profit),2) AS totalprofit
FROM samplesuperstore
GROUP BY City
ORDER BY totalprofit DESC
LIMIT 5

-- 8. Worst 5 performing cities
SELECT City, Round(SUM(Profit),2) AS totalprofit
FROM samplesuperstore
GROUP BY City
ORDER BY totalprofit 
LIMIT 5

-- 9. Top product in each region
SELECT *
FROM
(
SELECT Region,Sub_Category, ROUND(SUM(Sales),2) AS Total_sales, ROW_NUMBER() OVER (PARTITION BY Region ORDER BY ROUND(SUM(sales),2)DESC) AS RNK1
FROM samplesuperstore
GROUP BY Region, Sub_Category
) t
WHERE RNK1=1

-- 10. Top 3 product in each region
SELECT *
FROM
(
SELECT Region,Sub_Category, ROUND(SUM(Sales),2) AS Total_sales, ROW_NUMBER() OVER (PARTITION BY Region ORDER BY ROUND(SUM(sales),2)DESC) AS RNK1
FROM samplesuperstore
GROUP BY Region, Sub_Category
) t
WHERE RNK1<=3

-- 11. Profit Ratio
SELECT Category, ROUND(SUM(SALES),2) AS Total_sales, ROUND(SUM(Profit),2) AS Total_Profit, ROUND(SUM(Profit)/SUM(Sales),2) AS Profit_ratio
FROM samplesuperstore
GROUP BY Category
ORDER BY  Profit_ratio DESC

-- 12. Most Loss-Making Products per Category
SELECT *
FROM
(
SELECT Category, Sub_Category, ROUND(SUM(PROFIT),2) AS total_profit, RANK() OVER(PARTITION BY Category ORDER BY SUM(Profit) ASC) AS RNK1
FROM samplesuperstore
GROUP BY Category, Sub_Category
) t
WHERE RNK1=1

-- 13. Discounts vs Profit
SELECT ROUND(Discount,1) as discount_level, COUNT(*) as Orders, ROUND(AVG(Profit),2) as Avg_profit
FROM samplesuperstore
GROUP BY discount_level
ORDER BY discount_level

-- 14. Best City in each Region
SELECT *
FROM (
  SELECT 
    Region,
    City,
    ROUND(SUM(Profit),2) AS total_profit,
    ROW_NUMBER() OVER (
      PARTITION BY Region
      ORDER BY SUM(Profit) DESC
    ) AS rn
  FROM samplesuperstore
  GROUP BY Region, City
) t
WHERE rn = 1

-- 15. Most Profitable States
SELECT 
  State, ROUND(SUM(Profit),2) AS total_profit
FROM samplesuperstore
GROUP BY State
ORDER BY total_profit DESC
LIMIT 10

-- 16. Loss Making States
SELECT State, Round(SUM(Profit),2) AS total_Profit
FROM samplesuperstore
GROUP BY State
HAVING total_Profit<0
ORDER BY total_Profit
LIMIT 10