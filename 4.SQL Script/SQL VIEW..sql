-- 1. CUSTOMERS DIMENSION VIEW
CREATE VIEW v_Dim_Customers AS
SELECT 
    customerID AS [Customer ID],
    companyName AS [Company Name],
    contactName AS [Contact Name],
    contactTitle AS [Contact Title],
    city AS [City],
    country AS [Country]
FROM [Northwind_Traders].[dbo].[Customers_Clean_Data];
GO

-- 2. PRODUCTS DIMENSION VIEW
CREATE VIEW v_Dim_Products AS
SELECT 
    productID AS [Product ID],
    productName AS [Product Name],
    categoryID AS [Category ID],
    categoryName As [Category Name],
    quantityPerUnit AS [Quantity Per Unit],
    COALESCE(unitPrice, 0.00) AS [Standard Price], 
    discontinued AS [Is Discontinued]
FROM [Northwind_Traders].[dbo].[Products_Clean_Data];
GO

-- 3. EMPLOYEES DIMENSION VIEW
CREATE VIEW v_Dim_Employees AS
SELECT 
    employeeID AS [Employee ID],
    employeeName AS [Employee Name],
    title AS [Job Title],
    city AS [Office City],
    reportsTo AS [Manager ID]
FROM [Northwind_Traders].[dbo].[Employees_Clean_Data];
GO

-- 4. SHIPPERS DIMENSION VIEW
CREATE VIEW v_Dim_Shippers AS
SELECT 
    shipperID AS [Shipper ID],
    ISNULL(companyName, 'Unknown Carrier') AS [Company Name] 
FROM [Northwind_Traders].[dbo].[shippers];
GO

-- 5. FACT ORDERS VIEW
CREATE VIEW v_Fact_Orders AS
SELECT 
    orderID AS [Order ID],
    customerID AS [Customer ID],
    employeeID AS [Employee ID],
    shipperID AS [Shipper ID],
    orderDate AS [Order Date],
    requiredDate AS [Required Date],
    shippedDate AS [Shipped Date],
    COALESCE(freight, 0.00) AS [Freight Cost], 
    DATEDIFF(day, orderDate, shippedDate) AS [Days to Ship]
FROM [Northwind_Traders].[dbo].[Orders_Clean_Data];
GO

-- 6. FACT ORDER DETAILS VIEW
CREATE VIEW v_Fact_Order_Details AS
SELECT 
    orderID AS [Order ID],
    productID AS [Product ID],
    COALESCE(unitPrice, 0.00) AS [Unit Price], 
    COALESCE(quantity, 0) AS [Quantity],       
    ISNULL(discount, 0) AS [Discount Percentage], 
    (COALESCE(unitPrice, 0.00) * COALESCE(quantity, 0)) AS [Gross Revenue],
    (COALESCE(unitPrice, 0.00) * COALESCE(quantity, 0) * ISNULL(discount, 0)) AS [Discount Amount],
    ((COALESCE(unitPrice, 0.00) * COALESCE(quantity, 0)) - 
     (COALESCE(unitPrice, 0.00) * COALESCE(quantity, 0) * ISNULL(discount, 0))) AS [Net Revenue],
CASE 
        WHEN ISNULL(discount, 0) = 0 THEN '0'
        WHEN ISNULL(discount, 0) <= 0.05 THEN '1-5%'
        WHEN ISNULL(discount, 0) <= 0.15 THEN '5-15%'
        ELSE '15%+'
    END AS [Discount Bin],
    
    CASE 
        WHEN ISNULL(discount, 0) = 0 THEN 1
        WHEN ISNULL(discount, 0) <= 0.05 THEN 2
        WHEN ISNULL(discount, 0) <= 0.15 THEN 3
        ELSE 4
    END AS [Discount Bin Sort]
FROM [Northwind_Traders].[dbo].[Orders_Details_Clean_Data];
GO
