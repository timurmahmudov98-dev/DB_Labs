--1.
SELECT
    p.ProductID,
    p.Name AS ProductName,
    p.Name AS ProductModel,
    v.Summary
FROM SalesLT.Product AS p
INNER JOIN SalesLT.vProductModelCatalogDescription AS v
    ON p.ProductModelID = v.ProductModelID
ORDER BY p.ProductID;