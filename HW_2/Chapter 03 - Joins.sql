---------------------------------------------------------------------
-- Microsoft SQL Server T-SQL Fundamentals
-- Chapter 03 - Joins
-- � Itzik Ben-Gan 
---------------------------------------------------------------------

---------------------------------------------------------------------
-- CROSS Joins
---------------------------------------------------------------------

-- Instructions 

-- Create a proposition describing each query in the file Chapter 03 - Joins.sql
-- Execute each of the corrected queries using Northwinds2019TSQLV5
-- Create screen shots of the execution of the examples. Submit as one pdf (paste each screen shot into a word and export the word document as a pdf)
-- Export 5 queries as a flat file (CSV format)  using the Import\export wizard into a folder. Save in a folder of your choice for each chapter ( Example: \CSCI331\Chapter3)
--    Do the same for the  Chapter 03 - Joins - Exercises.sql by writing the queries and creating a single pdf of the output.
-- The submission should include 2 PDF's and all of the import export files or an MP4 video explaining the homework


-- Predicate: a joined table containing the cross product of all the 
-- customer ids and employee ids from Sales.Customers and HR.Employees, respectively 

USE TSQLV4;

-- SQL-92
SELECT C.custid, E.empid
FROM Sales.Customers AS C
  CROSS JOIN HR.Employees AS E;


USE Northwinds2022TSQLV7;
GO
-- SQL-92
SELECT C.CustomerId, E.EmployeeId
FROM Sales.Customer AS C
  CROSS JOIN HumanResources.Employee AS E;


-- SQL-89
USE TSQLV4;
SELECT C.custid, E.empid
FROM Sales.Customers AS C, HR.Employees AS E;

-- SQL-89
USE Northwinds2022TSQLV7;
SELECT C.CustomerId, E.EmployeeId
FROM Sales.Customer AS C, HumanResources.Employee AS E;



-- Predicate: self cross-join two instances of the same table producing the cross product 
-- of employee id, first name, and last name 

-- Self Cross-Join
USE TSQLV4;

SELECT
  E1.empid, E1.firstname, E1.lastname,
  E2.empid, E2.firstname, E2.lastname
FROM HR.Employees AS E1 
  CROSS JOIN HR.Employees AS E2;
GO

USE Northwinds2022TSQLV7;

SELECT
  E1.EmployeeId, E1.EmployeeFirstName, E1.EmployeeLastName,
  E2.EmployeeId, E2.EmployeeFirstName, E2.EmployeeLastName
FROM HumanResources.Employee AS E1 
  CROSS JOIN HumanResources.Employee AS E2;
GO

-- Predicate: produces a sequence of numbers from 1 to 1000

-- All numbers from 1 - 1000
-- Auxiliary table of digits
USE TSQLV4;

DROP TABLE IF EXISTS dbo.Digits;
CREATE TABLE dbo.Digits(digit INT NOT NULL PRIMARY KEY);
INSERT INTO dbo.Digits(digit)
  VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9);
SELECT digit FROM dbo.Digits;
GO

-- All numbers from 1 - 1000
SELECT D3.digit * 100 + D2.digit * 10 + D1.digit + 1 AS n
FROM         dbo.Digits AS D1
  CROSS JOIN dbo.Digits AS D2
  CROSS JOIN dbo.Digits AS D3
ORDER BY n;

-- Auxiliary table of digits
USE Northwinds2022TSQLV7;
DROP TABLE IF EXISTS dbo.Digits;
CREATE TABLE dbo.Digits(digit INT NOT NULL PRIMARY KEY);

INSERT INTO dbo.Digits(digit)
  VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9);
SELECT digit FROM dbo.Digits;
GO

-- All numbers from 1 - 1000
SELECT D3.digit * 100 + D2.digit * 10 + D1.digit + 1 AS n
FROM         dbo.Digits AS D1
  CROSS JOIN dbo.Digits AS D2
  CROSS JOIN dbo.Digits AS D3
ORDER BY n;


---------------------------------------------------------------------
-- INNER Joins
---------------------------------------------------------------------

-- Predicate: inner join producing a cross product between employee id, 
-- first name, last name, and order id, and filtering out employees who did not
-- have any orders 

USE TSQLV4;

-- SQL-92
SELECT E.empid, E.firstname, E.lastname, O.orderid
FROM HR.Employees AS E
  INNER JOIN Sales.Orders AS O
    ON E.empid = O.empid;

-- SQL-89
SELECT E.empid, E.firstname, E.lastname, O.orderid
FROM HR.Employees AS E, Sales.Orders AS O
WHERE E.empid = O.empid;
GO

USE Northwinds2022TSQLV7;

-- SQL-92
SELECT E.EmployeeId, E.EmployeeFirstName, E.EmployeeLastName, O.OrderId
FROM HumanResources.Employee AS E
  INNER JOIN Sales.[Order] AS O
    ON E.EmployeeId = O.EmployeeId;

-- SQL-89
SELECT E.EmployeeId, E.EmployeeFirstName, E.EmployeeLastName, O.OrderId
FROM HumanResources.Employee AS E, Sales.[Order] AS O
WHERE E.EmployeeId = O.EmployeeId;
GO



-- Inner Join Safety

-- Predicate: unintentional cross join containing the cross product of all the 
-- customer ids and employee ids from Sales.Customers and HR.Employees, respectively 

/* Produces an error because the join filter was not included:

SELECT E.empid, E.firstname, E.lastname, O.orderid
FROM HR.Employees AS E
  INNER JOIN Sales.Orders AS O;
GO
*/

USE TSQLV4;

SELECT E.empid, E.firstname, E.lastname, O.orderid
FROM HR.Employees AS E, Sales.Orders AS O;
GO


USE Northwinds2022TSQLV7;

SELECT E.EmployeeId, E.EmployeeFirstName, E.EmployeeLastName, O.OrderId
FROM HumanResources.Employee AS E, Sales.[Order] AS O;
GO

---------------------------------------------------------------------
-- More Join Examples
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Composite Joins
---------------------------------------------------------------------

-- Predicate: Audit table for all value changes that took place in the column qty.

-- Audit table for updates against OrderDetails
USE TSQLV4;

DROP TABLE IF EXISTS Sales.OrderDetailsAudit;
CREATE TABLE Sales.OrderDetailsAudit
(
  lsn        INT            NOT NULL IDENTITY,
  orderid    INT            NOT NULL,
  productid  INT            NOT NULL,
  dt         DATETIME       NOT NULL,
  loginname  sysname        NOT NULL,
  columnname sysname        NOT NULL,
  oldval     SQL_VARIANT,
  newval     SQL_VARIANT,
  CONSTRAINT PK_OrderDetailsAudit PRIMARY KEY(lsn),
  CONSTRAINT FK_OrderDetailsAudit_OrderDetails
    FOREIGN KEY(orderid, productid)
    REFERENCES Sales.OrderDetails(orderid, productid)
);

SELECT OD.orderid, OD.productid, OD.qty,
  ODA.dt, ODA.loginname, ODA.oldval, ODA.newval
FROM Sales.OrderDetails AS OD
  INNER JOIN Sales.OrderDetailsAudit AS ODA
    ON OD.orderid = ODA.orderid
    AND OD.productid = ODA.productid
WHERE ODA.columnname = N'qty';

USE Northwinds2022TSQLV7;

DROP TABLE IF EXISTS Sales.OrderDetailsAudit;
CREATE TABLE Sales.OrderDetailsAudit
(
  lsn        INT            NOT NULL IDENTITY,
  orderid    INT            NOT NULL,
  productid  INT            NOT NULL,
  dt         DATETIME       NOT NULL,
  loginname  sysname        NOT NULL,
  columnname sysname        NOT NULL,
  oldval     SQL_VARIANT,
  newval     SQL_VARIANT,
  CONSTRAINT PK_OrderDetailsAudit PRIMARY KEY(lsn),
  CONSTRAINT FK_OrderDetailsAudit_OrderDetails
    FOREIGN KEY(orderid, productid)
    REFERENCES Sales.OrderDetail(OrderId, ProductId)
);

SELECT OD.OrderId, OD.ProductId, OD.Quantity,
  ODA.dt, ODA.loginname, ODA.oldval, ODA.newval
FROM Sales.OrderDetail AS OD
  INNER JOIN Sales.OrderDetailsAudit AS ODA
    ON OD.OrderId = ODA.orderid
    AND OD.ProductId = ODA.productid
WHERE ODA.columnname = N'qty';



---------------------------------------------------------------------
-- Non-Equi Joins
---------------------------------------------------------------------

-- Predicate: unique pairs of employees

-- Unique pairs of employees

USE TSQLV4; 

SELECT
  E1.empid, E1.firstname, E1.lastname,
  E2.empid, E2.firstname, E2.lastname
FROM HR.Employees AS E1
  INNER JOIN HR.Employees AS E2
    ON E1.empid < E2.empid;


USE Northwinds2022TSQLV7; 

SELECT
  E1.EmployeeId, E1.EmployeeFirstName, E1.EmployeeLastName,
  E2.EmployeeId, E2.EmployeeFirstName, E2.EmployeeLastName
FROM HumanResources.Employee AS E1
  INNER JOIN HumanResources.Employee AS E2
    ON E1.EmployeeId < E2.EmployeeId;

---------------------------------------------------------------------
-- Multi-Join Queries
---------------------------------------------------------------------

-- Predicate: customers who placed orders, and those matches' order details 

USE TSQLV4;

SELECT
  C.custid, C.companyname, O.orderid,
  OD.productid, OD.qty
FROM Sales.Customers AS C
  INNER JOIN Sales.Orders AS O
    ON C.custid = O.custid
  INNER JOIN Sales.OrderDetails AS OD
    ON O.orderid = OD.orderid;


USE Northwinds2022TSQLV7;

SELECT
  C.CustomerId, C.CustomerCompanyName, O.OrderId,
  OD.ProductId, OD.Quantity
FROM Sales.Customer AS C
  INNER JOIN Sales.[Order] AS O
    ON C.CustomerId = O.CustomerId
  INNER JOIN Sales.OrderDetail AS OD
    ON O.OrderId = OD.OrderId;

---------------------------------------------------------------------
-- Fundamentals of Outer Joins 
---------------------------------------------------------------------

-- Predicate: Customers and their orders, including customers with no orders
USE TSQLV4;

SELECT C.custid, C.companyname, O.orderid
FROM Sales.Customers AS C
  LEFT OUTER JOIN Sales.Orders AS O
    ON C.custid = O.custid;

USE TSQLV4;

-- Predicate: Customers with no orders
SELECT C.custid, C.companyname
FROM Sales.Customers AS C
  LEFT OUTER JOIN Sales.Orders AS O
    ON C.custid = O.custid
WHERE O.orderid IS NULL;

USE Northwinds2022TSQLV7;

SELECT C.CustomerId, C.CustomerCompanyName, O.orderid
FROM Sales.Customer AS C
  LEFT OUTER JOIN Sales.[Order] AS O
    ON C.CustomerId = O.CustomerId;


USE Northwinds2022TSQLV7;

SELECT C.CustomerId, C.CustomerCompanyName
FROM Sales.Customer AS C
  LEFT OUTER JOIN Sales.[Order] AS O
    ON C.CustomerId = O.CustomerId
WHERE O.orderid IS NULL;



---------------------------------------------------------------------
-- Beyond the Fundamentals of Outer Joins
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Including Missing Values
---------------------------------------------------------------------
USE TSQLV4;

-- Predicate: sequence of all dates in the range Jan 1 2014 - Dec 31 2016
SELECT DATEADD(day, n-1, CAST('20140101' AS DATE)) AS orderdate
FROM dbo.Nums
WHERE n <= DATEDIFF(day, '20140101', '20161231') + 1
ORDER BY orderdate;

-- Predicate: all dates in range where orders were placed, and if no orders
-- were placed on that date, return Null

SELECT DATEADD(day, Nums.n - 1, CAST('20140101' AS DATE)) AS orderdate,
  O.orderid, O.custid, O.empid
FROM dbo.Nums
  LEFT OUTER JOIN Sales.Orders AS O
    ON DATEADD(day, Nums.n - 1, CAST('20140101' AS DATE)) = O.orderdate
WHERE Nums.n <= DATEDIFF(day, '20140101', '20161231') + 1
ORDER BY orderdate;


USE Northwinds2022TSQLV7;

-- Predicate: sequence of all dates in the range
SELECT DATEADD(day, n-1, CAST('20140101' AS DATE)) AS orderdate
FROM dbo.Nums
WHERE n <= DATEDIFF(day, '20140101', '20161231') + 1
ORDER BY orderdate;

-- Predicate: all dates in range where orders were placed, and if no orders
-- were placed on that date, return Null

SELECT DATEADD(day, Nums.n - 1, CAST('20140101' AS DATE)) AS orderdate,
  O.OrderId, O.CustomerId, O.EmployeeId
FROM dbo.Nums
  LEFT OUTER JOIN Sales.[Order] AS O
    ON DATEADD(day, Nums.n - 1, CAST('20140101' AS DATE)) = O.orderdate
WHERE Nums.n <= DATEDIFF(day, '20140101', '20161231') + 1
ORDER BY orderdate;

---------------------------------------------------------------------
-- Filtering Attributes from Non-Preserved Side of Outer Join
---------------------------------------------------------------------

-- Predicate: all orders placed on or after Jan 1, 2016

USE TSQLV4;

SELECT C.custid, C.companyname, O.orderid, O.orderdate
FROM Sales.Customers AS C
  LEFT OUTER JOIN Sales.Orders AS O
    ON C.custid = O.custid
WHERE O.orderdate >= '20160101';


USE Northwinds2022TSQLV7;

SELECT C.CustomerId, C.CustomerCompanyName, O.OrderId, O.orderdate
FROM Sales.Customer AS C
  LEFT OUTER JOIN Sales.[Order] AS O
    ON C.CustomerId = O.CustomerId
WHERE O.orderdate >= '20160101';

---------------------------------------------------------------------
-- Using Outer Joins in a Multi-Join Query
---------------------------------------------------------------------

-- Predicate: return customers and their orders, as well as those that did not place orders yet, 
-- but then the second join filters out the customers that did not place any orders yet

USE TSQLV4;

SELECT C.custid, O.orderid, OD.productid, OD.qty
FROM Sales.Customers AS C
  LEFT OUTER JOIN Sales.Orders AS O
    ON C.custid = O.custid
  INNER JOIN Sales.OrderDetails AS OD
    ON O.orderid = OD.orderid;

-- Option 1: use outer join all along
SELECT C.custid, O.orderid, OD.productid, OD.qty
FROM Sales.Customers AS C
  LEFT OUTER JOIN Sales.Orders AS O
    ON C.custid = O.custid
  LEFT OUTER JOIN Sales.OrderDetails AS OD
    ON O.orderid = OD.orderid;

-- Option 2: change join order
SELECT C.custid, O.orderid, OD.productid, OD.qty
FROM Sales.Orders AS O
  INNER JOIN Sales.OrderDetails AS OD
    ON O.orderid = OD.orderid
  RIGHT OUTER JOIN Sales.Customers AS C
     ON O.custid = C.custid;

-- Option 3: use parentheses
SELECT C.custid, O.orderid, OD.productid, OD.qty
FROM Sales.Customers AS C
  LEFT OUTER JOIN
      (Sales.Orders AS O
         INNER JOIN Sales.OrderDetails AS OD
           ON O.orderid = OD.orderid)
    ON C.custid = O.custid;


USE Northwinds2022TSQLV7;

SELECT C.CustomerId, O.OrderId, OD.ProductId, OD.Quantity
FROM Sales.Customer AS C
  LEFT OUTER JOIN Sales.[Order] AS O
    ON C.CustomerId = O.CustomerId
  INNER JOIN Sales.OrderDetail AS OD
    ON O.orderid = OD.orderid;

-- Option 1: use outer join all along
SELECT C.CustomerId, O.OrderId, OD.ProductId, OD.Quantity
FROM Sales.Customer AS C
  LEFT OUTER JOIN Sales.[Order] AS O
    ON C.CustomerId = O.CustomerId
  LEFT OUTER JOIN Sales.OrderDetail AS OD
    ON O.orderid = OD.orderid;

-- Option 2: change join order
SELECT C.CustomerId, O.OrderId, OD.ProductId, OD.Quantity
FROM Sales.[Order] AS O
  INNER JOIN Sales.OrderDetail AS OD
    ON O.OrderId = OD.OrderId
  RIGHT OUTER JOIN Sales.Customer AS C
     ON O.CustomerId = C.CustomerId;

-- Option 3: use parentheses
SELECT C.CustomerId, O.OrderId, OD.ProductId, OD.Quantity
FROM Sales.Customer AS C
  LEFT OUTER JOIN
      (Sales.[Order] AS O
         INNER JOIN Sales.OrderDetail AS OD
           ON O.OrderId = OD.OrderId)
    ON C.CustomerId = O.CustomerId;

---------------------------------------------------------------------
-- Using the COUNT Aggregate with Outer Joins
---------------------------------------------------------------------

-- Predicate: Counts all rows regardless of orders placed (NULL counts for 1)

USE TSQLV4;

SELECT C.custid, COUNT(*) AS numorders
FROM Sales.Customers AS C
  LEFT OUTER JOIN Sales.Orders AS O
    ON C.custid = O.custid
GROUP BY C.custid;

-- Predicate: counts only number of orders placed 

SELECT C.custid, COUNT(O.orderid) AS numorders
FROM Sales.Customers AS C
  LEFT OUTER JOIN Sales.Orders AS O
    ON C.custid = O.custid
GROUP BY C.custid;


USE Northwinds2022TSQLV7;

SELECT C.CustomerId, COUNT(*) AS numorders
FROM Sales.Customer AS C
  LEFT OUTER JOIN Sales.[Order] AS O
    ON C.CustomerId = O.CustomerId
GROUP BY C.CustomerId;

SELECT C.CustomerId, COUNT(O.orderid) AS numorders
FROM Sales.Customer AS C
  LEFT OUTER JOIN Sales.[Order] AS O
    ON C.CustomerId = O.CustomerId
GROUP BY C.CustomerId;