--1.1
SELECT ProductID, Name, ListPrice 
FROM SalesLT.Product 
WHERE ListPrice > (
      SELECT AVG(UnitPrice) 
      FROM SalesLT.SalesOrderDetail
)
ORDER BY ProductID;

--1.2
SELECT p.ProductID,
       p.Name,
       p.ListPrice
FROM SalesLT.Product AS p
WHERE p.ListPrice >= 100
  AND p.ProductID IN (
        SELECT sod.ProductID
        FROM SalesLT.SalesOrderDetail AS sod
        WHERE sod.UnitPrice < 100
      )
ORDER BY p.ProductID;

--1.3
SELECT 
     p.ProductID,
     p.Name,
     p.StandardCost,
     p.ListPrice,
     (
       SELECT AVG(sod.UnitPrice)
       FROM SalesLT.SalesOrderDetail AS sod
       WHERE sod.ProductID = p.ProductID
     ) AS AvgSellingPrice
FROM SalesLT.Product AS p
ORDER BY p.ProductID;

--1.4
SELECT p.ProductID,
       p.Name,
       p.StandardCost,
       p.ListPrice,
       (
         SELECT AVG(sod.UnitPrice)
         FROM SalesLT.SalesOrderDetail AS sod
         WHERE sod.ProductID = p.ProductID
       ) AS AvgSellingPrice
FROM SalesLT.Product AS p
WHERE p.StandardCost > (
        SELECT AVG(sod.UnitPrice)
        FROM SalesLT.SalesOrderDetail AS sod
        WHERE sod.ProductID = p.ProductID
      )
ORDER BY p.ProductID;

--2.1
SELECT soh.SalesOrderID,
       soh.CustomerID,
       ci.FirstName,
       ci.LastName,
       soh.TotalDue
FROM SalesLT.SalesOrderHeader AS soh
CROSS APPLY dbo.ufnGetCustomerInformation(soh.CustomerID) AS ci
ORDER BY soh.SalesOrderID;

--2.2
SELECT ca.CustomerID,
       ci.FirstName,
       ci.LastName,
       a.AddressLine1,
       a.City
FROM SalesLT.CustomerAddress AS ca
JOIN SalesLT.Address AS a
     ON a.AddressID = ca.AddressID
CROSS APPLY dbo.ufnGetCustomerInformation(ca.CustomerID) AS ci
ORDER BY ca.CustomerID;