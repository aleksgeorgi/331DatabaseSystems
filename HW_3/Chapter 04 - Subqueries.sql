---------------------------------------------------------------------
-- Microsoft SQL Server T-SQL Fundamentals
-- Chapter 04 - Subqueries
-- � Itzik Ben-Gan 
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Self-Contained Subqueries
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Scalar Subqueries
---------------------------------------------------------------------

-- Order with the maximum order ID


USE TSQLV4;

DECLARE @maxid AS INT = (SELECT MAX(orderid)
                         FROM Sales.Orders);

SELECT orderid, orderdate, empid, custid
FROM Sales.Orders
WHERE orderid = @maxid;
GO

SELECT orderid, orderdate, empid, custid
FROM Sales.Orders
WHERE orderid = (SELECT MAX(O.orderid)
                 FROM Sales.Orders AS O);

-- PREDICATE: view table of orderid, orderdate, empid, and custid for just the max/highest order ID 

USE Northwinds2022TSQLV7;

DECLARE @maxid AS INT = (SELECT MAX(orderid)
                         FROM Sales.[Order]);

SELECT orderid, orderdate, EmployeeId, CustomerId
FROM Sales.[Order]
WHERE orderid = @maxid;
GO

SELECT orderid, orderdate, EmployeeId, CustomerId
FROM Sales.[Order]
WHERE orderid = (SELECT MAX(O.orderid)
                 FROM Sales.[Order] AS O);



-- Scalar subquery expected to return one value

USE TSQLV4;

SELECT orderid
FROM Sales.Orders
WHERE empid = 
  (SELECT E.empid
   FROM HR.Employees AS E
   WHERE E.lastname LIKE N'C%');
GO

-- BUG Subquery returned more than 1 value

-- SELECT orderid
-- FROM Sales.Orders
-- WHERE empid = 
--   (SELECT E.empid
--    FROM HR.Employees AS E
--    WHERE E.lastname LIKE N'D%');
-- GO

SELECT orderid
FROM Sales.Orders
WHERE empid = 
  (SELECT E.empid
   FROM HR.Employees AS E
   WHERE E.lastname LIKE N'A%');

-- PREDICATE: orders placed by employees whose last name starts with the letter C

USE Northwinds2022TSQLV7;

SELECT orderid
FROM Sales.[Order]
WHERE EmployeeId = 
  (SELECT E.EmployeeId
   FROM HumanResources.Employee AS E
   WHERE E.EmployeeLastName LIKE N'C%');
GO

-- PREDICATE: orders placed by employees whose last name starts with the letter D
-- BUG Subquery returned more than 1 value

-- SELECT orderid
-- FROM Sales.[Order]
-- WHERE EmployeeId = 
--   (SELECT E.EmployeeId
--    FROM HumanResources.Employee AS E
--    WHERE E.EmployeeLastName LIKE N'D%');
-- GO

-- PREDICATE: orders placed by employees whose last name starts with the letter A

SELECT orderid
FROM Sales.[Order]
WHERE EmployeeId = 
  (SELECT E.EmployeeId
   FROM HumanResources.Employee AS E
   WHERE E.EmployeeLastName LIKE N'A%');

---------------------------------------------------------------------
-- Multi-Valued Subqueries
---------------------------------------------------------------------

USE TSQLV4;

SELECT orderid
FROM Sales.Orders
WHERE empid IN
  (SELECT E.empid
   FROM HR.Employees AS E
   WHERE E.lastname LIKE N'D%');


USE Northwinds2022TSQLV7;

-- Predicate: orders placed by employees with a last name starting with D

SELECT orderid
FROM Sales.[Order]
WHERE EmployeeId IN
  (SELECT E.EmployeeId
   FROM HumanResources.Employee AS E
   WHERE E.EmployeeLastName LIKE N'D%');


USE TSQLV4;

SELECT O.orderid
FROM HR.Employees AS E
  INNER JOIN Sales.Orders AS O
    ON E.empid = O.empid
WHERE E.lastname LIKE N'D%';


-- Predicate: orders placed by employees with a last name starting with D
USE Northwinds2022TSQLV7;

SELECT O.orderid
FROM HumanResources.Employee AS E
  INNER JOIN Sales.[Order] AS O
    ON E.EmployeeId = O.EmployeeId
WHERE E.EmployeeLastName LIKE N'D%';




USE TSQLV4;

-- Orders placed by US customers
SELECT custid, orderid, orderdate, empid
FROM Sales.Orders
WHERE custid IN
  (SELECT C.custid
   FROM Sales.Customers AS C
   WHERE C.country = N'USA');


-- Predicate: Orders placed by US customers
USE Northwinds2022TSQLV7;

SELECT CustomerId, orderid, orderdate, EmployeeId
FROM Sales.[Order]
WHERE CustomerId IN
  (SELECT C.CustomerId
   FROM Sales.Customer AS C
   WHERE C.CustomerCountry = N'USA');





USE TSQLV4;

-- Customers who placed no orders
SELECT custid, companyname
FROM Sales.Customers
WHERE custid NOT IN
  (SELECT O.custid
   FROM Sales.Orders AS O);

-- Predicate: Customers who placed no orders
USE Northwinds2022TSQLV7;

SELECT CustomerId, CustomerCompanyName
FROM Sales.Customer
WHERE CustomerId NOT IN
  (SELECT O.CustomerId
   FROM Sales.[Order] AS O);




USe TSQLV4;

-- Missing order IDs
USE TSQLV4;
DROP TABLE IF EXISTS dbo.Orders;
CREATE TABLE dbo.Orders(orderid INT NOT NULL CONSTRAINT PK_Orders PRIMARY KEY);

INSERT INTO dbo.Orders(orderid)
  SELECT orderid
  FROM Sales.Orders
  WHERE orderid % 2 = 0;

SELECT n
FROM dbo.Nums
WHERE n BETWEEN (SELECT MIN(O.orderid) FROM dbo.Orders AS O)
            AND (SELECT MAX(O.orderid) FROM dbo.Orders AS O)
  AND n NOT IN (SELECT O.orderid FROM dbo.Orders AS O);

-- CLeanup
DROP TABLE IF EXISTS dbo.Orders;

-- Predicate: Missing order IDs
USE Northwinds2022TSQLV7;
DROP TABLE IF EXISTS dbo.Orders;
CREATE TABLE dbo.Orders(orderid INT NOT NULL CONSTRAINT PK_Orders PRIMARY KEY);

INSERT INTO dbo.Orders(orderid)
  SELECT orderid
  FROM Sales.[Order]
  WHERE orderid % 2 = 0;

SELECT n
FROM dbo.Nums
WHERE n BETWEEN (SELECT MIN(O.orderid) FROM dbo.Orders AS O)
            AND (SELECT MAX(O.orderid) FROM dbo.Orders AS O)
  AND n NOT IN (SELECT O.orderid FROM dbo.Orders AS O);

-- Cleanup
DROP TABLE IF EXISTS dbo.Orders;

---------------------------------------------------------------------
-- Correlated Subqueries
---------------------------------------------------------------------

-- Orders with maximum order ID for each customer
-- Listing 4-1: Correlated Subquery
USE TSQLV4;

SELECT custid, orderid, orderdate, empid
FROM Sales.Orders AS O1
WHERE orderid =
  (SELECT MAX(O2.orderid)
   FROM Sales.Orders AS O2
   WHERE O2.custid = O1.custid);

SELECT MAX(O2.orderid)
FROM Sales.Orders AS O2
WHERE O2.custid = 85;

-- Percentage of customer total
SELECT orderid, custid, val,
  CAST(100. * val / (SELECT SUM(O2.val)
                     FROM Sales.OrderValues AS O2
                     WHERE O2.custid = O1.custid)
       AS NUMERIC(5,2)) AS pct
FROM Sales.OrderValues AS O1
ORDER BY custid, orderid;

USE Northwinds2022TSQLV7;

SELECT CustomerId, orderid, orderdate, EmployeeId
FROM Sales.[Order] AS O1
WHERE orderid =
  (SELECT MAX(O2.orderid)
   FROM Sales.[Order] AS O2
   WHERE O2.CustomerId = O1.CustomerId);

SELECT MAX(O2.orderid)
FROM Sales.[Order] AS O2
WHERE O2.CustomerId = 85;

-- -- Percentage of customer total
-- SELECT orderid, custid, val,
--   CAST(100. * val / (SELECT SUM(O2.val)
--                      FROM Sales.OrderValues AS O2
--                      WHERE O2.custid = O1.custid)
--        AS NUMERIC(5,2)) AS pct
-- FROM Sales.OrderValues AS O1
-- ORDER BY custid, orderid;

---------------------------------------------------------------------
-- EXISTS
---------------------------------------------------------------------

USE TSQLV4;
-- Customers from Spain who placed orders
SELECT custid, companyname
FROM Sales.Customers AS C
WHERE country = N'Spain'
  AND EXISTS
    (SELECT * FROM Sales.Orders AS O
     WHERE O.custid = C.custid);

-- Customers from Spain who didn't place Orders
SELECT custid, companyname
FROM Sales.Customers AS C
WHERE country = N'Spain'
  AND NOT EXISTS
    (SELECT * FROM Sales.Orders AS O
     WHERE O.custid = C.custid);


USE Northwinds2022TSQLV7;
-- Predicate: Customers from Spain who placed orders
SELECT CustomerId, CustomerCompanyName
FROM Sales.Customer AS C
WHERE CustomerCountry = N'Spain'
  AND EXISTS
    (SELECT * FROM Sales.[Order] AS O
     WHERE O.CustomerId = C.CustomerId);

-- Predicate: Customers from Spain who didn't place Orders
SELECT CustomerId, CustomerCompanyName
FROM Sales.Customer AS C
WHERE CustomerCountry = N'Spain'
  AND NOT EXISTS
    (SELECT * FROM Sales.[Order] AS O
     WHERE O.CustomerId = C.CustomerId);


---------------------------------------------------------------------
-- Beyond the Fundamentals of Subqueries
-- (Optional, Advanced)
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Returning "Previous" or "Next" Value
---------------------------------------------------------------------

USE TSQLV4;

SELECT orderid, orderdate, empid, custid,
  (SELECT MAX(O2.orderid)
   FROM Sales.Orders AS O2
   WHERE O2.orderid < O1.orderid) AS prevorderid
FROM Sales.Orders AS O1;

SELECT orderid, orderdate, empid, custid,
  (SELECT MIN(O2.orderid)
   FROM Sales.Orders AS O2
   WHERE O2.orderid > O1.orderid) AS nextorderid
FROM Sales.Orders AS O1;


USE Northwinds2022TSQLV7;
Go

-- Predicate: for each order, information about the current order and also the previous order ID
SELECT orderid, orderdate, EmployeeId, CustomerId,
  (SELECT MAX(O2.orderid)
   FROM Sales.[Order] AS O2
   WHERE O2.orderid < O1.orderid) AS prevorderid
FROM Sales.[Order] AS O1;

-- Predicate: for each order, information about the current order and also the next order ID

SELECT orderid, orderdate, EmployeeId, CustomerId,
  (SELECT MIN(O2.orderid)
   FROM Sales.[Order] AS O2
   WHERE O2.orderid > O1.orderid) AS nextorderid
FROM Sales.[Order] AS O1;

---------------------------------------------------------------------
-- Running Aggregates
---------------------------------------------------------------------

USE TSQLV4;
GO 

SELECT orderyear, qty
FROM Sales.OrderTotalsByYear;

SELECT orderyear, qty,
  (SELECT SUM(O2.qty)
   FROM Sales.OrderTotalsByYear AS O2
   WHERE O2.orderyear <= O1.orderyear) AS runqty
FROM Sales.OrderTotalsByYear AS O1
ORDER BY orderyear;

-- USE Northwinds2022TSQLV7;
-- GO 

-- SELECT orderyear, qty
-- FROM Sales.OrderTotalsByYear;

-- SELECT orderyear, qty,
--   (SELECT SUM(O2.qty)
--    FROM Sales.OrderTotalsByYear AS O2
--    WHERE O2.orderyear <= O1.orderyear) AS runqty
-- FROM Sales.OrderTotalsByYear AS O1
-- ORDER BY orderyear;

---------------------------------------------------------------------
-- Misbehaving Subqueries
---------------------------------------------------------------------

---------------------------------------------------------------------
-- NULL Trouble
---------------------------------------------------------------------

-- Customers who didn't place orders

-- Using NOT IN

USE TSQLV4;

SELECT custid, companyname
FROM Sales.Customers
WHERE custid NOT IN(SELECT O.custid
                    FROM Sales.Orders AS O);

-- Add a row to the Orders table with a NULL custid
INSERT INTO Sales.Orders
  (custid, empid, orderdate, requireddate, shippeddate, shipperid,
   freight, shipname, shipaddress, shipcity, shipregion,
   shippostalcode, shipcountry)
  VALUES(NULL, 1, '20160212', '20160212',
         '20160212', 1, 123.00, N'abc', N'abc', N'abc',
         N'abc', N'abc', N'abc');

-- Following returns an empty set
SELECT custid, companyname
FROM Sales.Customers
WHERE custid NOT IN(SELECT O.custid
                    FROM Sales.Orders AS O);

-- Exclude NULLs explicitly
SELECT custid, companyname
FROM Sales.Customers
WHERE custid NOT IN(SELECT O.custid 
                    FROM Sales.Orders AS O
                    WHERE O.custid IS NOT NULL);

-- Using NOT EXISTS
SELECT custid, companyname
FROM Sales.Customers AS C
WHERE NOT EXISTS
  (SELECT * 
   FROM Sales.Orders AS O
   WHERE O.custid = C.custid);

-- Cleanup
DELETE FROM Sales.Orders WHERE custid IS NULL;
GO


USE Northwinds2022TSQLV7;
GO
-- Predicate: customers who did not place any orders

SELECT CustomerId, CustomerCompanyName
FROM Sales.Customer
WHERE CustomerId NOT IN(SELECT O.CustomerId
                    FROM Sales.[Order] AS O);

-- Predicate: Add a row to the Orders table with a NULL custid
INSERT INTO Sales.[Order]
  (CustomerId, EmployeeId, orderdate, RequiredDate, ShipToDate, shipperid,
   freight, ShipToName, ShipToAddress, ShipToCity, ShipToRegion,
   ShipToPostalCode, ShipToCountry)
  VALUES(NULL, 1, '20160212', '20160212',
         '20160212', 1, 123.00, N'abc', N'abc', N'abc',
         N'abc', N'abc', N'abc');

--Predicate: returns an empty set because we're asking to return customerIds that are not in the Sales.Order table 
SELECT CustomerId, CustomerCompanyName
FROM Sales.Customer
WHERE CustomerId NOT IN(SELECT O.CustomerId
                    FROM Sales.[Order] AS O);

-- Predicate: Exclude NULLs explicitly/return customerIDs that are not in the Sales.Order table ie have not placed an order
SELECT CustomerId, CustomerCompanyName
FROM Sales.Customer
WHERE CustomerId NOT IN(SELECT O.CustomerId 
                    FROM Sales.[Order] AS O
                    WHERE O.CustomerId IS NOT NULL);

-- Predicate: Using NOT EXISTS to return customers that have not placed an order
SELECT CustomerId, CustomerCompanyName
FROM Sales.Customer AS C
WHERE NOT EXISTS
  (SELECT * 
   FROM Sales.[Order] AS O
   WHERE O.CustomerId = C.CustomerId);

-- Cleanup
DELETE FROM Sales.[Order] WHERE CustomerId IS NULL;
GO

---------------------------------------------------------------------
-- Substitution Error in a Subquery Column Name
---------------------------------------------------------------------

-- Create and populate table Sales.MyShippers
USE TSQLV4;

DROP TABLE IF EXISTS Sales.MyShippers;

CREATE TABLE Sales.MyShippers
(
  shipper_id  INT          NOT NULL,
  companyname NVARCHAR(40) NOT NULL,
  phone       NVARCHAR(24) NOT NULL,
  CONSTRAINT PK_MyShippers PRIMARY KEY(shipper_id)
);

INSERT INTO Sales.MyShippers(shipper_id, companyname, phone)
  VALUES(1, N'Shipper GVSUA', N'(503) 555-0137'),
	      (2, N'Shipper ETYNR', N'(425) 555-0136'),
				(3, N'Shipper ZHISN', N'(415) 555-0138');
GO

-- Shippers who shipped orders to customer 43

-- Bug
SELECT shipper_id, companyname
FROM Sales.MyShippers
WHERE shipper_id IN
  (SELECT shipper_id
   FROM Sales.Orders
   WHERE custid = 43);
GO

-- The safe way using aliases, bug identified
SELECT shipper_id, companyname
FROM Sales.MyShippers
WHERE shipper_id IN
  (SELECT O.shipper_id
   FROM Sales.Orders AS O
   WHERE O.custid = 43);
GO

-- Bug corrected
SELECT shipper_id, companyname
FROM Sales.MyShippers
WHERE shipper_id IN
  (SELECT O.shipperid
   FROM Sales.Orders AS O
   WHERE O.custid = 43);

-- Cleanup
DROP TABLE IF EXISTS Sales.MyShippers;


-- Create and populate table Sales.MyShippers
USE Northwinds2022TSQLV7;

DROP TABLE IF EXISTS Sales.MyShippers;

CREATE TABLE Sales.MyShippers
(
  shipper_id  INT          NOT NULL,
  companyname NVARCHAR(40) NOT NULL,
  phone       NVARCHAR(24) NOT NULL,
  CONSTRAINT PK_MyShippers PRIMARY KEY(shipper_id)
);

INSERT INTO Sales.MyShippers(shipper_id, companyname, phone)
  VALUES(1, N'Shipper GVSUA', N'(503) 555-0137'),
	      (2, N'Shipper ETYNR', N'(425) 555-0136'),
				(3, N'Shipper ZHISN', N'(415) 555-0138');
GO

-- Shippers who shipped orders to customer 43

-- -- Bug
-- SELECT shipper_id, companyname
-- FROM Sales.MyShippers
-- WHERE shipper_id IN
--   (SELECT shipper_id
--    FROM Sales.[Order]
--    WHERE CustomerId = 43);
-- GO

-- -- The safe way using aliases, bug identified
-- SELECT shipper_id, companyname
-- FROM Sales.MyShippers
-- WHERE shipper_id IN
--   (SELECT O.shipper_id
--    FROM Sales.[Order] AS O
--    WHERE O.CustomerId = 43);
-- GO

-- Bug corrected
SELECT shipper_id, companyname
FROM Sales.MyShippers
WHERE shipper_id IN
  (SELECT O.shipperid
   FROM Sales.[Order] AS O
   WHERE O.CustomerId = 43);

-- Cleanup
DROP TABLE IF EXISTS Sales.MyShippers;
