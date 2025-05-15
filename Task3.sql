CREATE DATABASE ecommerce1;
USE ecommerce1;
CREATE TABLE ecommerce_table (
    InvoiceNo VARCHAR(20),
    StockCode VARCHAR(20),
    Description TEXT,
    Quantity INT,
    UnitPrice DECIMAL(10,2),
    CustomerID INT,
    Country VARCHAR(50)
);

Insert into ecommerce_table(InvoiceNo, StockCode, Description, Quantity, UnitPrice, CustomerID, Country)
Values(
('536365',	'85123A',	'WHITE HANGING HEART T-LIGHT HOLDER',	6,	2.55,	17850,	'United Kingdom'),
('536365', '71053',	'WHITE METAL LANTERN',	6,	3.39,	17850,	'United Kingdom'),
('536365',	'84406B',	'CREAM CUPID HEARTS COAT HANGER',	8,	2.75,	17850,	'United Kingdom'),
('536365',	'84029G',	'KNITTED UNION FLAG HOT WATER BOTTLE',	6,	3.39,	17850,	'United Kingdom'),
('536365',	'84029E',	'RED WOOLLY HOTTIE WHITE HEART',	6,	3.39,	17850,	'United Kingdom')
);


-- 3. Quick Preview
SELECT * FROM ecommerce LIMIT 10;

-- 4. Simple Filtered Query
SELECT * FROM ecommerce
WHERE Country = 'France'
ORDER BY UnitPrice DESC;

-- 5. Aggregation: Revenue by Country
SELECT Country, COUNT(*) AS Orders, SUM(Quantity * UnitPrice) AS TotalRevenue
FROM ecommerce
GROUP BY Country
ORDER BY TotalRevenue DESC;

-- 6. Subquery: Customers who spent more than average
SELECT DISTINCT CustomerID
FROM ecommerce
WHERE CustomerID IS NOT NULL
AND CustomerID IN (
    SELECT CustomerID
    FROM ecommerce
    GROUP BY CustomerID
    HAVING SUM(Quantity * UnitPrice) > (
        SELECT AVG(Total)
        FROM (
            SELECT SUM(Quantity * UnitPrice) AS Total
            FROM ecommerce
            WHERE CustomerID IS NOT NULL
            GROUP BY CustomerID
        ) AS CustomerTotals
    )
);

-- 7. Simulated JOIN with Product Table
CREATE TEMPORARY TABLE products (
    StockCode VARCHAR(20),
    Category VARCHAR(50)
);

INSERT INTO products VALUES 
('85123A', 'Home Decor'),
('71053', 'Lanterns'),
('84406B', 'Home Accessories');

SELECT e.InvoiceNo, e.Description, p.Category
FROM ecommerce e
INNER JOIN products p ON e.StockCode = p.StockCode;

-- 8. Create a View for Top Countries by Revenue
CREATE VIEW TopCountries AS
SELECT Country, SUM(Quantity * UnitPrice) AS Revenue
FROM ecommerce
GROUP BY Country
ORDER BY Revenue DESC
LIMIT 5;

-- 9. Use the View
SELECT * FROM TopCountries;

-- 10. Create Indexes for Optimization
CREATE INDEX idx_customer ON ecommerce (CustomerID);
CREATE INDEX idx_invoice ON ecommerce (InvoiceNo);
