/*
Query 1:

We are using the Northwids database and selecting 3 colums from the Sales.Order table: EmployeeID, OrderDate which is being renamed as OrderYear, and creating a COUNT to count the number of occurances and renaming it as numOrders. 

From those 3 columns we are asking to return just the CustomerID that equals 71 and have sold 2 or more orders

Finally we want to order by EmployeeID first then OrderYear second
*/

USE Northwinds2022TSQLV7;

SELECT EmployeeID, YEAR(OrderDate) AS OrderYear, COUNT(*) AS numOrders
FROM Sales.[Order]
WHERE CustomerID=71
GROUP BY EmployeeID, YEAR(OrderDate)
HAVING COUNT(*) > 1
ORDER BY EmployeeId, OrderYear;

/*
Query 2:

Less filtered query that returns just the Employee ID and Order Year for Customer ID 71
*/

SELECT EmployeeID, YEAR(OrderDate) AS OrderYear
FROM Sales.[Order]
WHERE CustomerID = 71;

/*
Query 3:

Returns 3 tables

The first is showing distinct sales employees made per order year for customer 71

The second is showing the 3 different shipper companies used

The third is selecting the OrderIDs for the Order Year and then creating another column for the following year
*/

SELECT DISTINCT EmployeeID, YEAR(OrderDate) AS OrderYear
FROM Sales.[Order]
WHERE CustomerID = 71;

SELECT *
FROM Sales.[Shipper];

SELECT OrderId,
  YEAR(OrderDate) AS OrderYear,
  YEAR(OrderDate) + 1 AS NextYear
FROM Sales.[Order];

/*
Query 4:

Returns two tables:

The first is the standard query we've already done for CustomerID 71

The second uses a different table, HumanResources.Employee and pulls 4 columns: <span style="color: rgb(33, 33, 33); font-family: Menlo, Monaco, &quot;Courier New&quot;, monospace; font-size: 12px; white-space: pre;">EmployeeId, EmployeeFirstName, EmployeeLastName, EmployeeCountry</span>

<span style="color: rgb(33, 33, 33); font-family: Menlo, Monaco, &quot;Courier New&quot;, monospace; font-size: 12px; white-space: pre;">sorting them by hiredate</span>
*/

SELECT EmployeeId, YEAR(OrderDate) AS OrderYear, COUNT(*) AS NumOrders
FROM Sales.[Order]
WHERE CustomerId = 71
GROUP BY EmployeeId, YEAR(OrderDate)
HAVING COUNT(*) > 1
ORDER BY EmployeeId, OrderYear;

SELECT EmployeeId, EmployeeFirstName, EmployeeLastName, EmployeeCountry
FROM HumanResources.[Employee]
ORDER BY HireDate;

/*
Query 5: 

Returns two tables that show the top 5 queries and the top 1 percent of queries, respectfully, ordered in Descending order by OrderDate
*/

SELECT TOP (5) OrderId, OrderDate, CustomerId, EmployeeId
FROM Sales.[Order]
ORDER BY OrderDate DESC;

SELECT TOP (1) PERCENT OrderId, OrderDate, CustomerId, EmployeeId
FROM Sales.[Order]
ORDER BY OrderDate DESC;

/*
Query 6:

The first query returns the top 5 as we have shown

The second uses WITH TIES which <span style="background-color: rgb(255, 255, 255); color: rgb(82, 89, 96); font-family: -apple-system, system-ui, &quot;Segoe UI Adjusted&quot;, &quot;Segoe UI&quot;, &quot;Liberation Sans&quot;, sans-serif; font-size: 15px;">returns two or more rows that tie for last place in the limited results set</span>
*/

SELECT TOP (5) OrderId, OrderDate, CustomerId, EmployeeId
FROM Sales.[Order]
ORDER BY OrderDate DESC, OrderId DESC;

SELECT TOP (5) WITH TIES OrderId, OrderDate, CustomerId, EmployeeId
FROM Sales.[Order]
ORDER BY OrderDate DESC;

/*
Query 7:

Offests the starting row by 50 and shows only the next 25 rows
*/

SELECT OrderId, OrderDate, CustomerId, EmployeeId
FROM Sales.[Order]
ORDER BY OrderDate, OrderId
OFFSET 50 ROWS FETCH NEXT 25 ROWS ONLY;

/*
Query 8:

Query uses the Over clause with the Partition By clause to specify the column on which we need to perform aggrigation
*/

SELECT OrderId, CustomerId, Freight,
  ROW_NUMBER() OVER(PARTITION BY CustomerId
                    ORDER BY Freight) AS rownum
FROM Sales.[Order]
ORDER BY CustomerId, Freight;


/*
Query 9:

These multiple queries show the use of various predicates, comparison, logical, and arithmentic operators on the columns called
*/

-- Predicates: IN, BETWEEN, LIKE
SELECT OrderId, EmployeeId, OrderDate
FROM Sales.[Order]
WHERE OrderId IN(10248, 10249, 10250);

SELECT OrderId, EmployeeId, OrderDate
FROM Sales.[Order]
WHERE OrderId BETWEEN 10300 AND 10310;

SELECT EmployeeId, EmployeeFirstName, EmployeeLastName
FROM HumanResources.[Employee]
WHERE EmployeeLastName LIKE N'D%';

-- Comparison operators: =, >, <, >=, <=, <>, !=, !>, !< 
SELECT OrderId, EmployeeId, OrderDate
FROM Sales.[Order]
WHERE OrderDate >= '20160101';

-- Logical operators: AND, OR, NOT
SELECT OrderId, EmployeeId, OrderDate
FROM Sales.[Order]
WHERE OrderDate >= '20160101'
  AND EmployeeId IN(1, 3, 5);

-- Arithmetic operators: +, -, *, /, %
SELECT OrderId, ProductId, Quantity, UnitPrice, DiscountPercentage,
  Quantity * UnitPrice * (1 - DiscountPercentage) AS val
FROM Sales.[OrderDetail];

-- Operator Precedence

-- AND precedes OR
SELECT OrderId, CustomerId, EmployeeId, OrderDate
FROM Sales.[Order]
WHERE
        CustomerId = 1
    AND EmployeeId IN(1, 3, 5)
    OR  CustomerId = 85
    AND EmployeeId IN(2, 4, 6);

-- Equivalent to
SELECT OrderId, CustomerId, EmployeeId, OrderDate
FROM Sales.[Order]
WHERE
      ( CustomerId = 1
        AND EmployeeId IN(1, 3, 5) )
    OR
      ( CustomerId = 85
        AND EmployeeId IN(2, 4, 6) );

-- *, / precedes +, -
SELECT 10 + 2 * 3   -- 16

SELECT (10 + 2) * 3 -- 36

/*
Query 10:
1st query lets us create cases to describe the elements in CategoryId by creating a column called CategoryName accoring to the CategoryId
2nd query creates a cateogry called ValueCategory which uses the Freight column to bucket sales according to the comparison operators
*/

SELECT ProductId, ProductName, CategoryId,
  CASE CategoryId
    WHEN 1 THEN 'Beverages'
    WHEN 2 THEN 'Condiments'
    WHEN 3 THEN 'Confections'
    WHEN 4 THEN 'Dairy Products'
    WHEN 5 THEN 'Grains/Cereals'
    WHEN 6 THEN 'Meat/Poultry'
    WHEN 7 THEN 'Produce'
    WHEN 8 THEN 'Seafood'
    ELSE 'Unknown Category'
  END AS CategoryName
FROM Production.[Product];

-- Searched
SELECT OrderId, CustomerId, Freight,
  CASE 
    WHEN Freight < 1000.00                   THEN 'Less than 1000'
    WHEN Freight BETWEEN 1000.00 AND 3000.00 THEN 'Between 1000 and 3000'
    WHEN Freight > 3000.00                   THEN 'More than 3000'
    ELSE 'Unknown'
  END AS ValueCategory
FROM Sales.[Order];