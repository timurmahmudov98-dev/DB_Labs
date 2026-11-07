--1.1
INSERT INTO SalesLT.Product (Name, ProductNumber, StandardCost, ListPrice, ProductCategoryID, SellStartDate)
VALUES ('LED Lights', 'LT-L123', 2.56, 12.99, 37, GETDATE());
-- Только для ProductID:
SELECT SCOPE_IDENTITY() AS ProductID;
-- Для того чтобы вывести всю строчку:
SELECT *
FROM SalesLT.Product
WHERE ProductID = SCOPE_IDENTITY();

--1.2
INSERT INTO SalesLT.ProductCategory (ParentProductCategoryID, Name)
VALUES (4, 'Bells and Horns');
DECLARE @CategoryID INT = SCOPE_IDENTITY();

INSERT INTO SalesLT.Product (Name, ProductNumber, StandardCost, ListPrice, ProductCategoryID, SellStartDate)
VALUES ('Bicycle Bell', 'BB-RING', 2.47, 4.99, @CategoryID, GETDATE()),
       ('Bicycle Horn', 'BB-PARP', 1.29, 3.75, @CategoryID, GETDATE());

SELECT c.ProductCategoryID,
       c.Name AS CategoryName,
       c.ParentProductCategoryID,
       p.ProductID,
       p.Name AS ProductName,
       p.ProductNumber,
       p.StandardCost,
       p.ListPrice,
       p.SellStartDate
FROM SalesLT.ProductCategory AS c
INNER JOIN SalesLT.Product AS p
    ON p.ProductCategoryID = c.ProductCategoryID
WHERE c.Name = 'Bells and Horns';


--2.1
UPDATE SalesLT.Product
SET ListPrice = ListPrice * 1.10
WHERE ProductCategoryID = (SELECT ProductCategoryID FROM SalesLT.ProductCategory WHERE Name = 'Bells and Horns');


SELECT p.ProductID, p.Name, p.ListPrice
FROM SalesLT.Product AS p
INNER JOIN SalesLT.ProductCategory AS c
    ON p.ProductCategoryID = c.ProductCategoryID
WHERE c.Name = 'Bells and Horns';

--2.2
UPDATE SalesLT.Product
SET DiscontinuedDate = GETDATE()
WHERE ProductCategoryID = 37 AND ProductNumber <> 'LT-L123';

SELECT ProductID, Name, ProductNumber, DiscontinuedDate
FROM SalesLT.Product
WHERE ProductCategoryID = 37;

--3.1
DELETE FROM SalesLT.Product
WHERE ProductCategoryID = (SELECT ProductCategoryID
                        FROM SalesLT.ProductCategory
                        WHERE Name = 'Bells and Horns');


DELETE FROM SalesLT.ProductCategory
WHERE Name = 'Bells and Horns';


SELECT * FROM SalesLT.ProductCategory WHERE Name = 'Bells and Horns';
SELECT * FROM SalesLT.Product WHERE ProductNumber IN ('BB-RING', 'BB-PARP');