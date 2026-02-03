-- Create database 
CREATE DATABASE ABC_Sales; 

USE ABC_Sales; 
---------------------------------------------------------------------------------------------

-- Create Tables
-- CUSTOMER 
CREATE TABLE Customer ( 
	CustomerID INT IDENTITY(1,1) PRIMARY KEY, 
    CustomerName VARCHAR(200) NOT NULL, 
    Address1 VARCHAR(200) NULL, 
    Address2 VARCHAR(200) NULL, 
    City VARCHAR(100) NULL, 
    State VARCHAR(100) NULL, 
    Country VARCHAR(100) NULL, 
    Status VARCHAR(50) NOT NULL DEFAULT 'Active', 
    CreatedOn DATETIME NOT NULL DEFAULT SYSDATETIME(), 
    UpdatedOn DATETIME NULL 
    );   
-- Truncate Table Customer
TRUNCATE TABLE Customer;


-- PRODUCT 
CREATE TABLE Product ( 
	ProductID INT IDENTITY(1,1) PRIMARY KEY, 
    ProductName VARCHAR(200) NOT NULL, 
    ManufacturingDate DATE NULL, 
    ShelfLifeInMonths INT NULL, 
    Rate DECIMAL(18,2) NOT NULL, 
    Quantity INT NOT NULL DEFAULT 0,         -- current stock 
    CreatedOn DATETIME NOT NULL DEFAULT SYSDATETIME(), 
    UpdatedOn DATETIME NULL 
	); 
-- Truncate Table Product
TRUNCATE TABLE Product;


-- DISCOUNT 
CREATE TABLE Discount ( 
	DiscountID INT IDENTITY(1,1) PRIMARY KEY,                        
    DiscountAmount DECIMAL(18,2) NULL,        
    DiscountPercentage DECIMAL(5,2) NULL,      
    Status VARCHAR(50) NOT NULL DEFAULT 'Active', 
    CreatedOn DATETIME NOT NULL DEFAULT SYSDATETIME(), 
    UpdatedOn DATETIME NULL
    ); 
 -- Truncate Table Discount
TRUNCATE TABLE Discount;


-- TAXATION 
CREATE TABLE Taxation ( 
	TaxID INT IDENTITY(1,1) PRIMARY KEY, 
    TaxName VARCHAR(200) NOT NULL, 
    TaxTypeApplicable VARCHAR(50) NOT NULL CHECK (TaxTypeApplicable IN ('Orders','Products')), 
    TaxAmount DECIMAL(18,2) NULL,    
    ApplicableYorN CHAR(1) NOT NULL CHECK (ApplicableYorN IN ('Y','N')), 
    CreatedOn DATETIME NOT NULL DEFAULT SYSDATETIME(), 
    UpdatedOn DATETIME NULL 
    ); 
-- Truncate Table Taxation
TRUNCATE TABLE Taxation;


-- ORDER TRANSACTION 
CREATE TABLE OrderTransaction ( 
	OrderID INT IDENTITY(1,1) PRIMARY KEY, 
    CustomerID INT NOT NULL, 
    DiscountID INT NULL, 
    TaxID INT NULL,                              
    TotalAmount DECIMAL(18,2) NULL,              
    CreatedOn DATETIME NOT NULL DEFAULT SYSDATETIME(), 
    UpdatedOn DATETIME NULL, 
    CONSTRAINT FK_Order_Customer FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID), 
    CONSTRAINT FK_Order_Discount FOREIGN KEY (DiscountID) REFERENCES Discount(DiscountID), 
    CONSTRAINT FK_Order_Tax FOREIGN KEY (TaxID) REFERENCES Taxation(TaxID) 
    ); 
-- Truncate Table Order Transaction
TRUNCATE TABLE OrderTransaction;


-- ORDER LINE ITEMS  
CREATE TABLE OrderLineItems ( 
	OrderLineItemID INT IDENTITY(1,1) PRIMARY KEY, 
    OrderID INT NOT NULL, 
    ProductID INT NOT NULL, 
    Quantity INT NOT NULL CHECK (Quantity > 0), 
    UOM VARCHAR(50) NULL, 
    Rate DECIMAL(18,2) NOT NULL,
    TaxID INT NULL,                         
    Amount DECIMAL(18,2) NULL,              
    CreatedOn DATETIME NOT NULL DEFAULT SYSDATETIME(), 
    UpdatedOn DATETIME NULL, 
    CONSTRAINT FK_OLI_Order FOREIGN KEY (OrderID) REFERENCES OrderTransaction(OrderID), 
    CONSTRAINT FK_OLI_Product FOREIGN KEY (ProductID) REFERENCES Product(ProductID), 
    CONSTRAINT FK_OLI_Tax FOREIGN KEY (TaxID) REFERENCES Taxation(TaxID) 
    ); 
-- Truncate Table Order Line Items

ALTER TABLE OrderLineItems
DROP CONSTRAINT FK_OLI_Order;

TRUNCATE TABLE OrderLineItems;


ALTER TABLE OrderLineItems
ADD CONSTRAINT FK_OLI_Order
FOREIGN KEY (OrderID) REFERENCES OrderTransaction(OrderID);

---------------------------------------------------------------------------------------------------------


-- Insert into Customer 
INSERT INTO Customer (CustomerName, City, State, Country)
VALUES 
('Haynes', 'Gandhinagar', 'Gujrat', 'India'),
('Sneha', 'Bangalore', 'Karnataka', 'India'),
('Tamanna', 'Delhi', 'Delhi', 'India'),
('Janaki', 'Hyderabad', 'Telangana', 'India'),
('Krishna', 'Hyderabad', 'Telangana', 'India'),
('Rashmi', 'Noida', 'Uttar Pradesh', 'India'),
('Akhila', 'Gandhinagar', 'Gujrat', 'India'),
('Pranjali', 'Mumbai', 'Maharashtra', 'India'),
('Rohit', 'Gandhinagar', 'Gujrat', 'India'),
('Gaurav', 'Pune', 'Maharashtra', 'India');
Select *  from Customer;


-- Insert into Product
INSERT INTO Product (ProductName, ManufacturingDate, ShelfLifeInMonths, Rate, Quantity)
VALUES
('Laptop','2025-01-10', 24, 65000.00, 30),
('Smartphone','2025-02-15', 18, 45000.00, 50),
('Tablet','2025-03-20', 18, 30000.00, 40),
('Monitor','2025-01-05', 36, 12000.00, 25),
('Keyboard','2025-04-12', 48, 1500.00, 100),
('Mouse','2025-04-18', 48, 800.00, 120),
('Printer','2025-02-22', 24, 9000.00, 15),
('WiFi Router','2025-03-28', 36, 3500.00, 35),
('External Hard Drive','2025-01-09', 24, 6000.00, 20),
('Webcam','2025-02-11', 36, 2500.00, 60);
Select * from Product;


-- Insert into Taxation 
INSERT INTO Taxation (TaxName, TaxTypeApplicable, TaxAmount, ApplicableYorN)
VALUES
-- PRODUCT-LEVEL TAXES 
('GST 5%', 'Products', 5.00, 'Y'),
('GST 12%', 'Products', 12.00, 'Y'),
('GST 18%', 'Products', 18.00, 'Y'),
('GST 28%', 'Products', 28.00, 'Y'),

-- Non-Taxable Product 
('GST Exempt', 'Products', NULL, 'N'),

-- ORDER-LEVEL TAXES
('Service Charge 5%', 'Orders', 5.00, 'Y'),
('Service Charge 10%', 'Orders', 10.00, 'Y'),
('Packaging Tax 2%', 'Orders', 2.00, 'Y'),
('Delivery Tax', 'Orders', NULL, 'N');
Select * from Taxation;


-- Insert into Discount
INSERT INTO Discount (DiscountAmount, DiscountPercentage, Status)
VALUES       
(100.00, NULL, 'Active'),   
(NULL, 5.00, 'Active'),     
(1000.00, NULL, 'Active'),  
(NULL, 10.00, 'Active'),        
(500.00, NULL, 'Active'),
(NULL, 30.00, 'Active'),
(2000.00, NULL, 'Active'), 
(NULL, 50.00, 'Active');    
select * from Discount;
                 



CREATE OR ALTER FUNCTION dbo.GetTaxRate(@TaxID INT, @ExpectedType VARCHAR(50))
RETURNS DECIMAL(9,4)
AS
BEGIN
    DECLARE @Rate DECIMAL(9,4) = 0;

    IF @TaxID IS NULL
        RETURN 0;

    SELECT TOP (1)
        @Rate =
            CASE 
                WHEN t.TaxTypeApplicable <> @ExpectedType 
                  OR t.ApplicableYorN <> 'Y' 
                  OR t.TaxAmount IS NULL 
                THEN 0
                ELSE CAST(t.TaxAmount AS DECIMAL(9,4))
            END
    FROM dbo.Taxation t
    WHERE t.TaxID = @TaxID;

    RETURN COALESCE(@Rate, 0);
END
GO



CREATE OR ALTER FUNCTION dbo.CalcOrderTotal_v2(@OrderID INT)
RETURNS DECIMAL(18,2)
AS
BEGIN
    /* 1) BASE SUBTOTAL (NO TAX, NO DISCOUNT) */
    DECLARE @Subtotal DECIMAL(18,6) =
    (
        SELECT COALESCE(SUM(CAST(Quantity * Rate AS DECIMAL(18,6))), 0)
        FROM dbo.OrderLineItems
        WHERE OrderID = @OrderID
    );

    /* 2) PULL DISCOUNT AND ORDER-LEVEL TAX ID */
    DECLARE @DiscPct DECIMAL(9,4);
    DECLARE @DiscAmt DECIMAL(18,6);
    DECLARE @OrderTaxID INT;

    SELECT 
        @DiscPct = d.DiscountPercentage,
        @DiscAmt = d.DiscountAmount,
        @OrderTaxID = o.TaxID
    FROM dbo.OrderTransaction o
    LEFT JOIN dbo.Discount d 
        ON d.DiscountID = o.DiscountID
       AND d.Status = 'Active'
    WHERE o.OrderID = @OrderID;

    /* 3) RESOLVED (CAPPED) DISCOUNT */
    DECLARE @ResolvedDiscAmt DECIMAL(18,6) =
        CASE 
            WHEN @DiscPct IS NOT NULL THEN @Subtotal * @DiscPct / 100.0
            WHEN @DiscAmt IS NOT NULL THEN CASE WHEN @DiscAmt > @Subtotal THEN @Subtotal ELSE @DiscAmt END
            ELSE 0
        END;

    DECLARE @DiscountedSubtotal DECIMAL(18,6) = @Subtotal - @ResolvedDiscAmt;

    /* 4) PRODUCT-LEVEL TAX ON DISCOUNTED LINES */
    DECLARE @ProductTaxTotal DECIMAL(18,6) = 0;

    IF @Subtotal > 0
    BEGIN
        IF @DiscPct IS NOT NULL
        BEGIN
            -- Percentage discount: same factor for all lines
            DECLARE @DiscFactor DECIMAL(18,6) = 1 - (@DiscPct / 100.0);

            SELECT @ProductTaxTotal = COALESCE(SUM(
                CAST(oli.Quantity * oli.Rate * @DiscFactor AS DECIMAL(18,6))
                * COALESCE(dbo.GetTaxRate(oli.TaxID, 'Products'), 0) / 100.0
            ), 0)
            FROM dbo.OrderLineItems oli
            WHERE oli.OrderID = @OrderID;
        END
        ELSE IF @DiscAmt IS NOT NULL
        BEGIN
            -- Fixed discount: allocate the resolved (capped) amount proportionally
            SELECT @ProductTaxTotal = COALESCE(SUM(
                (
                    CAST(oli.Quantity * oli.Rate AS DECIMAL(18,6))
                    - ( @ResolvedDiscAmt * ( CAST(oli.Quantity * oli.Rate AS DECIMAL(18,6)) / NULLIF(@Subtotal,0) ) )
                )
                * COALESCE(dbo.GetTaxRate(oli.TaxID, 'Products'), 0) / 100.0
            ), 0)
            FROM dbo.OrderLineItems oli
            WHERE oli.OrderID = @OrderID;
        END
        ELSE
        BEGIN
            -- No discount: tax on full line bases
            SELECT @ProductTaxTotal = COALESCE(SUM(
                CAST(oli.Quantity * oli.Rate AS DECIMAL(18,6))
                * COALESCE(dbo.GetTaxRate(oli.TaxID, 'Products'), 0) / 100.0
            ), 0)
            FROM dbo.OrderLineItems oli
            WHERE oli.OrderID = @OrderID;
        END
    END

    /* 5) ORDER-LEVEL TAX ON DISCOUNTED SUBTOTAL */
    DECLARE @OrderTaxRate DECIMAL(9,4) = COALESCE(dbo.GetTaxRate(@OrderTaxID, 'Orders'), 0);
    DECLARE @OrderTaxAmount DECIMAL(18,6) = @DiscountedSubtotal * @OrderTaxRate / 100.0;

    /* 6) FINAL ORDER TOTAL — EXACT FORMULA */
    RETURN CAST(
        @DiscountedSubtotal
        + COALESCE(@ProductTaxTotal, 0)
        + COALESCE(@OrderTaxAmount, 0)
        AS DECIMAL(18,2)
    );
END
GO



CREATE OR ALTER TRIGGER dbo.trg_OLI_AUD
ON dbo.OrderLineItems
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Keep Amount as Quantity*Rate (no discount/tax)
    IF EXISTS (SELECT 1 FROM inserted)
    BEGIN
        UPDATE oli
        SET Amount = CAST(oli.Quantity * oli.Rate AS DECIMAL(18,2))
        FROM dbo.OrderLineItems oli
        JOIN inserted i ON i.OrderLineItemID = oli.OrderLineItemID;
    END

    UPDATE o
    SET o.TotalAmount = dbo.CalcOrderTotal_v2(o.OrderID)
    FROM dbo.OrderTransaction o
    WHERE o.OrderID IN (
        SELECT OrderID FROM inserted
        UNION
        SELECT OrderID FROM deleted
    );
END
GO





-- 50 Orders (2025-2026)
INSERT INTO OrderTransaction (CustomerID, DiscountID, TaxID, CreatedOn) VALUES
-- 2025 Orders
(1, 1, 6, '2025-01-05'),
(2, 2, 7, '2025-01-18'),
(3, NULL, 6, '2025-02-02'),
(4, 1, 8, '2025-02-17'),
(5, NULL, 9, '2025-03-03'),
(6, 3, 6, '2025-03-25'),
(7, NULL, 7, '2025-04-10'),
(8, 2, 6, '2025-04-28'),
(9, NULL, 7, '2025-05-06'),
(10, 4, 8, '2025-05-18'),
(1, NULL, 9, '2025-06-04'),
(2, 1, 8, '2025-06-30'),
(3, NULL, 7, '2025-07-05'),
(4, 2, 6, '2025-07-19'),
(5, 3, 6, '2025-08-03'),
(6, NULL, 8, '2025-08-27'),
(7, NULL, 9, '2025-09-04'),
(8, 1, 6, '2025-09-17'),
(9, 4, 7, '2025-10-03'),
(10, NULL, 8, '2025-10-22'),
(1, 2, 7, '2025-11-05'),
(2, NULL, 9, '2025-11-14'),
(3, 1, 6, '2025-12-02'),
(4, NULL, 6, '2025-12-18'),
(5, 3, 7, '2025-12-28'),

-- 2026 Orders
(6, 2, 7, '2026-01-05'),
(7, NULL, 9, '2026-01-24'),
(8, NULL, 6, '2026-02-01'),
(9, 1, 7, '2026-02-18'),
(10, NULL, 9, '2026-03-06'),
(1, NULL, 6, '2026-03-22'),
(2, 4, 8, '2026-04-10'),
(3, 2, 6, '2026-04-25'),
(4, NULL, 7, '2026-05-03'),
(5, NULL, 6, '2026-05-20'),
(6, 1, 8, '2026-06-02'),
(7, NULL, 9, '2026-06-16'),
(8, 2, 6, '2026-07-05'),
(9, 3, 6, '2026-07-29'),
(10, NULL, 7, '2026-08-08'),
(1, 3, 8, '2026-08-22'),
(2, NULL, 6, '2026-09-03'),
(3, NULL, 9, '2026-09-18'),
(4, 1, 6, '2026-10-05'),
(5, 2, 7, '2026-10-29'),
(6, NULL, 9, '2026-11-06'),
(7, 4, 8, '2026-11-21'),
(8, NULL, 7, '2026-12-04'),
(9, 2, 6, '2026-12-14'),
(10, NULL, 9, '2026-12-29');




INSERT INTO dbo.OrderLineItems (OrderID, ProductID, Quantity, UOM, Rate, TaxID)
SELECT
    o.OrderID,
    p.ProductID,
    CASE WHEN n.ItemNo = 1 
         THEN (ABS(CHECKSUM(NEWID())) % 5) + 1 
         ELSE (ABS(CHECKSUM(NEWID())) % 4) + 1 
    END AS Quantity,
    'Nos' AS UOM,
    p.Rate,
    tm.TaxID
FROM dbo.OrderTransaction o
CROSS JOIN (VALUES (1),(2)) AS n(ItemNo)
CROSS APPLY (
    -- Pick 1 product from the mapped list, but correlate the randomness
    SELECT TOP (1) p2.ProductID, tm2.TaxID
    FROM dbo.Product p2
    JOIN (
        VALUES
            (1, 3),(2, 3),(3, 2),(4, 2),(5, 1),
            (6, 1),(7, 3),(8, 2),(9, 3),(10, 5)
    ) AS tm2(ProductID, TaxID) ON tm2.ProductID = p2.ProductID
    ORDER BY CHECKSUM(NEWID(), o.OrderID, n.ItemNo, p2.ProductID)  -- <— correlated randomness
) pick
JOIN dbo.Product p ON p.ProductID = pick.ProductID
JOIN (
    VALUES
        (1, 3),(2, 3),(3, 2),(4, 2),(5, 1),
        (6, 1),(7, 3),(8, 2),(9, 3),(10, 5)
) AS tm(ProductID, TaxID) ON tm.ProductID = p.ProductID AND tm.TaxID = pick.TaxID;



TRUNCATE TABLE OrderLineItems;

SELECT * FROM OrderLineItems 
SELECT * FROM OrderTransaction 



CREATE OR ALTER VIEW v_OrderTaxCheck AS
SELECT
    OT.OrderID,
    OT.TaxID,
    C.CustomerName,
    T.TaxName,
    T.ApplicableYorN,
    T.TaxAmount,
    T.TaxTypeApplicable,

    CASE 
        WHEN OT.TaxID IS NULL THEN 'No order-level tax'
        WHEN T.ApplicableYorN = 'N' THEN 'Tax disabled'
        WHEN ISNULL(T.TaxAmount, 0) = 0 THEN 'Zero tax amount'
        WHEN T.TaxTypeApplicable <> 'Orders' THEN 'Tax type mismatch'
        ELSE 'OK'
    END AS OrderTaxStatus
FROM OrderTransaction OT
LEFT JOIN Taxation T ON T.TaxID = OT.TaxID
LEFT JOIN Customer C ON C.CustomerID = OT.CustomerID;


CREATE OR ALTER VIEW v_OrderLineTaxCheck AS
SELECT
    OLI.OrderLineItemID,
    OLI.OrderID,
    OLI.ProductID,
    P.ProductName,
    OLI.TaxID,
    T.TaxName,
    T.ApplicableYorN,
    T.TaxAmount,
    T.TaxTypeApplicable,

    CASE 
        WHEN OLI.TaxID IS NULL THEN 'No line tax'
        WHEN T.ApplicableYorN = 'N' THEN 'Tax disabled'
        WHEN ISNULL(T.TaxAmount, 0) = 0 THEN 'Zero tax amount'
        WHEN T.TaxTypeApplicable <> 'Products' THEN 'Tax type mismatch'
        ELSE 'OK'
    END AS LineTaxStatus
FROM OrderLineItems OLI
LEFT JOIN Product P ON P.ProductID = OLI.ProductID
LEFT JOIN Taxation T ON T.TaxID = OLI.TaxID;