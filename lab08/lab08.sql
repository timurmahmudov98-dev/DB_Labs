--1.1
SELECT
    a.CountryRegion,
    a.StateProvince,
    SUM(soh.TotalDue) AS Revenue
FROM SalesLT.Address AS a
INNER JOIN SalesLT.CustomerAddress AS ca
    ON a.AddressID = ca.AddressID
INNER JOIN SalesLT.Customer AS c
    ON ca.CustomerID = c.CustomerID
INNER JOIN SalesLT.SalesOrderHeader AS soh
    ON c.CustomerID = soh.CustomerID
GROUP BY ROLLUP (a.CountryRegion, a.StateProvince)
ORDER BY a.CountryRegion, a.StateProvince;

--1.2
SELECT
    a.CountryRegion,
    a.StateProvince,
    SUM(soh.TotalDue) AS Revenue,
    CASE 
        WHEN GROUPING(a.CountryRegion) = 1
           THEN 'Total'
        WHEN GROUPING(a.StateProvince) = 1
           THEN a.CountryRegion + ' Subtotal'
        ELSE a.StateProvince + ' Subtotal'
    END AS Level
FROM SalesLT.Address AS a
INNER JOIN SalesLT.CustomerAddress AS ca
    ON a.AddressID = ca.AddressID
INNER JOIN SalesLT.Customer AS c
    ON ca.CustomerID = c.CustomerID
INNER JOIN SalesLT.SalesOrderHeader AS soh
    ON c.CustomerID = soh.CustomerID
GROUP BY ROLLUP(a.CountryRegion, a.StateProvince)
ORDER BY a.CountryRegion, a.StateProvince;

--1.3
SELECT
    a.CountryRegion,
    a.StateProvince,
    a.City,
    SUM(soh.TotalDue) AS Revenue,
    CASE 
        WHEN GROUPING(a.CountryRegion) = 1
           THEN 'Total'
        WHEN GROUPING(a.StateProvince) = 1
           THEN a.CountryRegion + ' Subtotal'
        WHEN GROUPING(a.City) = 1
           THEN a.StateProvince + ' Subtotal'
        ELSE a.City + ' Subtotal'
    END AS Level
FROM SalesLT.Address AS a
INNER JOIN SalesLT.CustomerAddress AS ca
    ON a.AddressID = ca.AddressID
INNER JOIN SalesLT.Customer AS c
    ON ca.CustomerID = c.CustomerID
INNER JOIN SalesLT.SalesOrderHeader AS soh
    ON c.CustomerID = soh.CustomerID
GROUP BY ROLLUP(a.CountryRegion, a.StateProvince, a.City)
ORDER BY a.CountryRegion, a.StateProvince, a.City;

--2.1
SELECT
    CompanyName,
    Accessories,
    Bikes,
    Clothing,
    Components
FROM
(
    SELECT
        c.CompanyName,
        pc_parent.Name AS CategoryName,
        sod.LineTotal
    FROM SalesLT.Customer AS c
    INNER JOIN SalesLT.SalesOrderHeader AS soh
        ON c.CustomerID = soh.CustomerID
    INNER JOIN SalesLT.SalesOrderDetail AS sod
        ON soh.SalesOrderID = sod.SalesOrderID
    INNER JOIN SalesLT.Product AS p
        ON sod.ProductID = p.ProductID
    INNER JOIN SalesLT.ProductCategory AS pc
        ON p.ProductCategoryID = pc.ProductCategoryID
    INNER JOIN SalesLT.ProductCategory AS pc_parent
        ON pc.ParentProductCategoryID = pc_parent.ProductCategoryID
) AS SourceTable
PIVOT
(
    SUM(LineTotal)
    FOR CategoryName IN
    (
        Accessories,
        Bikes,
        Clothing,
        Components
    )
) AS PivotTable
ORDER BY CompanyName;