DROP DATABASE IF EXISTS ecommerce;

create database ecommerce;
use ecommerce;

--Customer table
CREATE TABLE Customer(
    Customer_ID INT IDENTITY(1,1) PRIMARY KEY,
    First_Name VARCHAR(50) NOT NULL,
    Last_Name VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Phone VARCHAR(15) NOT NULL UNIQUE,
    C_Password VARCHAR(255) NOT NULL,
    C_Address VARCHAR(255) NOT NULL,
    Created_At DATETIME DEFAULT GETDATE()
);

INSERT INTO Customer 
(First_Name, Last_Name, Email, Phone, C_Password, C_Address)
VALUES
('Shaiju','Maharjan','shaijumaharjan@gmail.com','9840755703','shaiju123','Kilagal, Kathmandu'),
('Swornim','Maharjan','swornimmaharjan@gmail.com','9841187102','swornim123','Sanokhokana, Lalitpur'),
('Aakristha','Bista','aakristhabista@gmail.com','9841016852','aakristha123','Chunikhel, Lalitpur'),
('Shrena','Maharjan','shrenamaharjan@gmail.com','9861752984','shrena123','Thankot, Kathmandu');

Select * from Customer;


-- Supplier table
CREATE TABLE Suppliers (
    Supplier_ID INT IDENTITY(1,1) PRIMARY KEY,
    Supplier_Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Phone VARCHAR(15) NOT NULL UNIQUE,
    S_Address VARCHAR(255) NOT NULL
);


INSERT INTO Suppliers
(Supplier_Name, Email, Phone, S_Address)
VALUES
('Apple Inc.', 'sales@apple.com', '9800000001', 'Cupertino, California, USA'),

('Samsung Electronics', 'contact@samsung.com', '9800000002', 'Seoul, South Korea'),

('Nike', 'support@nike.com', '9800000003', 'Beaverton, Oregon, USA'),

('Penguin Random House', 'info@penguinrandomhouse.com', '9800000004', 'New York, USA'),

('Philips', 'service@philips.com', '9800000005', 'Amsterdam, Netherlands'),

('Yonex', 'sales@yonex.com', '9800000006', 'Tokyo, Japan'),

('L''Oreal Paris', 'care@loreal.com', '9800000007', 'Paris, France'),

('Dell Technologies', 'support@dell.com', '9800000008', 'Texas, USA'),

('IKEA', 'contact@ikea.com', '9800000009', 'Delft, Netherlands'),

('Adidas', 'help@adidas.com', '9800000010', 'Herzogenaurach, Germany');

SELECT  * FROM Suppliers;

--Product table
CREATE TABLE Products(
    Product_ID INT IDENTITY(1,1) PRIMARY KEY,
    Supplier_ID INT NOT NULL,
    Product_Name VARCHAR(100) NOT NULL,
    P_Description VARCHAR(255),
    Price DECIMAL(10,2) NOT NULL CHECK (Price >= 0),
    Category VARCHAR(50) NOT NULL,
    Created_At DATETIME DEFAULT GETDATE(),

    CONSTRAINT FK_Product_Supplier
        FOREIGN KEY (Supplier_ID)
        REFERENCES Suppliers(Supplier_ID)
);

INSERT INTO Products
(Supplier_ID, Product_Name, P_Description, Price, Category)
VALUES
(1, 'iPhone 16', 'Latest Apple smartphone with advanced features', 1450.00, 'Electronics'),

(3, 'Nike Air Max Shoes', 'Lightweight running shoes for men', 149.99, 'Fashion'),

(4, 'Atomic Habits', 'Best-selling self-improvement book by James Clear', 18.50, 'Books'),

(5, 'Philips Air Fryer', 'Digital air fryer with 4.1L capacity', 129.99, 'Home & Kitchen'),

(6, 'Yonex Badminton Racket', 'Professional lightweight badminton racket', 89.99, 'Sports'),

(7, 'L''Oreal Paris Face Wash', 'Deep cleansing face wash for all skin types', 12.99, 'Beauty'),

(8, 'Dell Inspiron 15 Laptop', '15.6-inch laptop with Intel Core i7 processor', 899.99, 'Electronics'),

(9, 'Wooden Study Desk', 'Modern wooden computer study table', 185.00, 'Furniture'),

(10, 'Adidas Football', 'Official size 5 football for training and matches', 34.99, 'Sports'),

(2, 'Coffee Maker', 'Automatic coffee maker with 12-cup capacity', 75.00, 'Home & Kitchen');

Select * from Products;

--inventory table
CREATE TABLE Inventory (
    Inventory_ID INT IDENTITY(1,1) PRIMARY KEY,
    Product_ID INT NOT NULL,
    Supplier_ID INT NOT NULL,
    Stock_Quantity INT NOT NULL CHECK (Stock_Quantity >= 0),
    Reorder_Level INT NOT NULL CHECK (Reorder_Level >= 0),
    Last_Updated DATETIME DEFAULT GETDATE(),

    CONSTRAINT FK_Inventory_Product
        FOREIGN KEY (Product_ID)
        REFERENCES Products(Product_ID),

    CONSTRAINT FK_Inventory_Supplier
        FOREIGN KEY (Supplier_ID)
        REFERENCES Suppliers(Supplier_ID)
);

INSERT INTO Inventory
(Product_ID, Supplier_ID, Stock_Quantity, Reorder_Level)
VALUES
(1, 1, 25, 5),
(2, 2, 40, 10),
(3, 4, 60, 15),
(4, 5, 18, 5),
(5, 6, 35, 8),
(6, 7, 80, 20),
(7, 8, 15, 5),
(8, 9, 10, 3),
(9, 10, 50, 10),
(10, 5, 22, 5);

Select * from Inventory;

-- Shopping cart table

CREATE TABLE Cart (
    Cart_ID INT IDENTITY(1,1) PRIMARY KEY,
    Customer_ID INT NOT NULL,
    Product_ID INT NOT NULL,
    Quantity INT NOT NULL,
    Created_At DATETIME DEFAULT GETDATE(),

    CONSTRAINT FK_Cart_Customer
        FOREIGN KEY (Customer_ID)
        REFERENCES Customer(Customer_ID),

    CONSTRAINT FK_Cart_Products
        FOREIGN KEY (Product_ID)
        REFERENCES Products(Product_ID)
);


INSERT INTO Cart (Customer_ID, Product_ID, Quantity)
VALUES
(1, 1, 2),
(1, 2, 1),
(1, 3, 1),

(2, 4, 2),
(2, 5, 1),

(3, 6, 1),
(3, 7, 3),

(4, 8, 1),
(4, 9, 2),
(4, 10, 1);


SELECT * FROM Cart;


-- order table
CREATE TABLE Orders (
    Order_ID INT PRIMARY KEY IDENTITY(1,1),
    Customer_ID INT NOT NULL,
    Order_Date DATE NOT NULL,
    O_Status VARCHAR(20) NOT NULL,
    Total_Amount DECIMAL(10,2) NOT NULL,
    Shipping_Address VARCHAR(255) NOT NULL,

    FOREIGN KEY (Customer_ID)
    REFERENCES Customer(Customer_ID)
);

INSERT INTO Orders 
(Customer_ID, Order_Date, O_Status, Total_Amount, Shipping_Address)
VALUES
(1, '2026-08-01', 'Pending', 3650.00, 'Kathmandu, Nepal'),
(2, '2026-08-02', 'Shipped', 4500.50, 'Lalitpur, Nepal'),
(3, '2026-08-03', 'Delivered', 1200.00, 'Bhaktapur, Nepal'),
(4, '2026-08-04', 'Processing', 3200.75, 'Pokhara, Nepal'),
(1, '2026-08-05', 'Cancelled', 800.00, 'Kathmandu, Nepal'),
(2, '2026-08-05', 'Delivered', 5600.00, 'Chitwan, Nepal'),
(3, '2026-08-06', 'Pending', 1750.25, 'Butwal, Nepal'),
(4, '2026-08-06', 'Shipped', 2900.00, 'Dharan, Nepal'),
(1, '2026-08-07', 'Processing', 4100.00, 'Kathmandu, Nepal'),
(2, '2026-08-07', 'Delivered', 6700.50, 'Biratnagar, Nepal');O

Select * from Orders;


--Order_Detail table
CREATE TABLE Order_Detail (
    Order_D_ID INT PRIMARY KEY IDENTITY(1,1),
    Order_ID INT NOT NULL,
    Product_ID INT NOT NULL,
    Quantity INT NOT NULL,
    Unit_Price DECIMAL(10,2) NOT NULL,
    Subtotal DECIMAL(10,2) NOT NULL,

    CONSTRAINT FK_OrderDetail_Order
        FOREIGN KEY (Order_ID)
        REFERENCES Orders(Order_ID),

    CONSTRAINT FK_OrderDetail_Product
        FOREIGN KEY (Product_ID)
        REFERENCES Products(Product_ID)
);

INSERT INTO Order_Detail
(Order_ID, Product_ID, Quantity, Unit_Price, Subtotal)
VALUES
(1, 1, 2, 1450.00, 2900.00),
(1, 2, 1, 750.00, 750.00),

(2, 3, 2, 1200.00, 2400.00),
(2, 4, 1, 2100.50, 2100.50),

(3, 5, 1, 1200.00, 1200.00),

(4, 6, 2, 800.00, 1600.00),
(4, 7, 1, 1600.75, 1600.75),

(5, 8, 1, 800.00, 800.00),

(6, 9, 2, 2800.00, 5600.00),

(7, 10, 1, 1750.25, 1750.25),

(8, 1, 3, 500.00, 1500.00),

(9, 3, 2, 1200.00, 2400.00),
(10, 5, 3, 1200.00, 3600.00);

Select * from Order_Detail;



--payment table
Create TABLE Payment (
  Payment_ID INT PRIMARY KEY IDENTITY(1,1),
  Order_ID INT NOT NULL,
  Payment_Date DATE NOT NULL,
  Amount DECIMAL(10,2) NOT nuLl,
  Pay_Method VARCHAR(50) NOT NULL,
  Pay_Status VARCHAR(20) NOt NULL,
  Transaction_ID VARCHAR(100) UNIQUE NOT NULl,

  CONSTRAINT FK_Payment_Order 
     FOREIGN KEY (Order_ID)
     REFERENCES Orders(Order_ID)
);

INSERT INTO Payment
(Order_ID, Payment_Date, Amount, Pay_Method, Pay_Status, Transaction_ID)
VALUES
(1, '2026-08-01', 2500.00, 'Credit Card', 'Completed', 'TXN10001'),
(2, '2026-08-02', 4500.50, 'Esewa', 'Completed', 'TXN10002'),
(3, '2026-08-03', 1200.00, 'Cash on Delivery', 'Pending', 'TXN10003'),
(4, '2026-08-04', 3200.75, 'Khalti', 'Completed', 'TXN10004'),
(5, '2026-08-05', 800.00, 'Debit Card', 'Failed', 'TXN10005'),
(6, '2026-08-05', 5600.00, 'Esewa', 'Completed', 'TXN10006'),
(7, '2026-08-06', 1750.25, 'Cash on Delivery', 'Pending', 'TXN10007'),
(8, '2026-08-06', 2900.00, 'Credit Card', 'Completed', 'TXN10008'),
(9, '2026-08-07', 4100.00, 'Khalti', 'Completed', 'TXN10009'),
(10, '2026-08-07', 6700.50, 'Debit Card', 'Completed', 'TXN10010');

select * from Payment;



--review table
CREATE TABLE Reviews (
   Review_ID INT PRIMARY KEY,
   Customer_ID INT,
   Product_ID INT,
   Rating INT,
   Review_Text VARCHAR(500),
   Review_Date DATE,

   FOREIGN KEY (Customer_ID) REFERENCES Customer (Customer_Id),
   FOREIGN KEY (Product_ID) REFERENCES Products (Product_ID)
);

INSERT INTO Reviews
(Review_ID, Customer_ID, Product_ID, Rating, Review_Text, Review_Date)
VALUES
(1, 1, 1, 5, 'Excellent product, very good quality.', '2026-08-01'),
(2, 2, 2, 4, 'Good product but delivery was late.', '2026-08-02'),
(3, 3, 3, 5, 'Amazing quality and worth the price.', '2026-08-03'),
(4, 4, 4, 3, 'Average product, needs improvement.', '2026-08-04'),
(5, 1, 5, 4, 'Satisfied with the purchase.', '2026-08-05'),
(6, 2, 6, 5, 'Highly recommended product.', '2026-08-05'),
(7, 3, 7, 2, 'Product quality was not as expected.', '2026-08-06'),
(8, 4, 8, 4, 'Good value for money.', '2026-08-06'),
(9, 1, 9, 5, 'Perfect product, loved it.', '2026-08-07'),
(10, 2, 10, 3, 'Product is okay for the price.', '2026-08-07');

Select * from Reviews;

--filtering

--filteration by price
Select * from Products where price > 1000;

Select * from Products where price between 1000 and 3000;

--filteration by stock
Select * from Inventory where Stock_Quantity > 10;

Select * from Inventory where Stock_Quantity  =0;

--fileration by city
Select * from Customer where C_Address LIKE '%Kathmandu%';

--filteration by name 
Select * from Customer where First_Name LIKE 'A%';

--filteration by Date
Select * from Orders where Order_Date ='2026-08-01';

--filteration by payments by methods
Select * from Payment where Pay_Method = 'Cash on Delivery';


--sorting
--sort product by price 
Select * from Products
Order By Price ASC;

--sort product by alphabetically
Select * from Products Order By Product_Name  ASC;

--sort product by total amount 
Select * from Orders Order By Total_Amount DESC;

--sort suppliers by company name
Select * from Suppliers Order By Supplier_Name ASC;


--aggregation
--total number of customers
Select Count(*) As TotalCustomers from Customer;

--total number of products
Select Count(*) As TotalProducts from Products;

--average product rating        
Select AVG(Rating) As AverageRating from Reviews;

--highest order amount
Select MAX(Total_Amount) As HighestOrder from Orders;

-- Find the lowest product price
SELECT MIN(Price) AS Lowest_Product_Price FROM Products;

-- Calculate total sales from all orders
SELECT SUM(Total_Amount) AS Total_Sales FROM Orders;

-- Product price summary
SELECT
    COUNT(*) AS Total_Products,
    AVG(Price) AS Average_Price,
    MIN(Price) AS Lowest_Price,
    MAX(Price) AS Highest_Price
FROM Products;

---------------------------------------------------------------------------
-- GROUP BY : Products by category
SELECT Category, COUNT(*) AS Number_of_Products
FROM Products
GROUP BY Category;


-- GROUP BY : Orders by customer
SELECT Customer_ID, COUNT(*) AS Number_of_Orders
FROM Orders
GROUP BY Customer_ID;


-- GROUP BY : Payments by payment method
SELECT Pay_Method, COUNT(*) AS Number_of_Payments
FROM Payment
GROUP BY Pay_Method;

--------------------------------------------------------------
-- HAVING with COUNT
-- Find categories having more than 1 product
SELECT
    Category, COUNT(*) AS Number_of_Products
FROM Products
GROUP BY Category
HAVING COUNT(*) > 1;

--------------------------------------------------------------------
-- INNER JOIN
-- Display customer name, order ID and total amount
SELECT
    CONCAT(C.First_Name, ' ', C.Last_Name) AS Customer_Name,
    O.Order_ID,
    O.Total_Amount
FROM Customer C
INNER JOIN Orders O
    ON C.Customer_ID = O.Customer_ID;

-- INNER JOIN
-- Display order ID, product name, quantity and subtotal
SELECT
    O.Order_ID,
    P.Product_Name,
    OD.Quantity,
    OD.Subtotal
FROM Orders O
INNER JOIN Order_Detail OD
    ON O.Order_ID = OD.Order_ID
INNER JOIN Products P
    ON OD.Product_ID = P.Product_ID;

----------------------------------------------------------------------
-- SCALAR SUBQUERY
-- Find products whose price is greater than the average product price
SELECT
    Product_ID,
    Product_Name,
    Price
FROM Products
WHERE Price > (
    SELECT AVG(Price)
    FROM Products
);

-- SUBQUERY
-- Find customers who have placed orders above 4000
SELECT
    Customer_ID,
    First_Name,
    Last_Name,
    Email
FROM Customer
WHERE Customer_ID IN (
    SELECT Customer_ID
    FROM Orders
    WHERE Total_Amount > 4000
);


-----------------------------------------------------------------------------------------
-- CUSTOMER ORDER VIEW

DROP VIEW IF EXISTS vw_CustomerOrders;
GO

CREATE VIEW vw_CustomerOrders
AS
SELECT
    C.Customer_ID,
    CONCAT(C.First_Name, ' ', C.Last_Name) AS Customer_Name,
    C.Email,
    C.Phone,
    O.Order_ID,
    O.Order_Date,
    O.O_Status,
    O.Total_Amount,
    O.Shipping_Address
FROM Customer C
INNER JOIN Orders O
    ON C.Customer_ID = O.Customer_ID;
GO

-- Execute/View the Customer Order View
SELECT *
FROM vw_CustomerOrders;
GO


----------------------------------------------------------------------------------
-- PRODUCT-SUPPLIER VIEW

DROP VIEW IF EXISTS vw_ProductSuppliers;
GO

CREATE VIEW vw_ProductSuppliers
AS
SELECT
    P.Product_ID,
    P.Product_Name,
    P.Category,
    P.Price,
    S.Supplier_ID,
    S.Supplier_Name
FROM Products P
INNER JOIN Suppliers S
    ON P.Supplier_ID = S.Supplier_ID;
GO

-- Execute/View the Product-Supplier View
SELECT *
FROM vw_ProductSuppliers;
GO



------------------------------------------------------------------------------
-- UPDATE QUERIES

-- Update product price
SELECT Product_ID, Product_Name, Price
FROM Products
WHERE Product_ID = 1;

UPDATE Products
SET Price = 1350.00
WHERE Product_ID = 1;

SELECT Product_ID, Product_Name, Price
FROM Products
WHERE Product_ID = 1;

-------------------------------------------------------------------------------
-- Update order status
SELECT Order_ID, O_Status
FROM Orders
WHERE Order_ID = 1;

UPDATE Orders
SET O_Status = 'Shipped'
WHERE Order_ID = 1;

SELECT Order_ID, O_Status
FROM Orders
WHERE Order_ID = 1;

--------------------------------------------------------------------------------
-- DELETE QUERIES

-- Delete a review
SELECT Review_ID, Customer_ID, Product_ID, Rating, Review_Text
FROM Reviews
WHERE Review_ID = 1;

DELETE FROM Reviews
WHERE Review_ID = 1;

SELECT Review_ID, Customer_ID, Product_ID, Rating, Review_Text
FROM Reviews
WHERE Review_ID = 1;



-------------------------------------------------------------------------------
--Stored Procedure sp_CustomerLogin
DROP PROCEDURE IF EXISTS sp_CustomerLogin;
GO

CREATE PROCEDURE sp_CustomerLogin
    @Email VARCHAR(100),
    @Password VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    --check if customer email exist
    IF NOT EXISTS (
        SELECT 1
        FROM Customer
        WHERE Email = @Email
    )
    BEGIN
        THROW 101, 'Email does not exist.', 1;
    END

    --check if password is correct
    IF NOT EXISTS (
        SELECT 1
        FROM Customer
        WHERE Email = @Email
          AND C_Password = @Password
    )
    BEGIN
        THROW 102, 'Incorrect password.', 1;
    END

    SELECT Customer_ID,
           First_Name,
           Last_Name,
           Email,
           Phone,
           C_Address
    FROM Customer
    WHERE Email = @Email
      AND C_Password = @Password;
END;

Exec sp_CustomerLogin
@Email = 'shaijumaharjan@gmail.com',
@Password='shaiju123';
GO 
----------------------------------------------------------------
--Stored Procedure Add Customer
DROP PROCEDURE IF EXISTS sp_AddCustomer;
GO


CREATE PROCEDURE sp_AddCustomer
(
    @First_Name VARCHAR(50),
    @Last_Name VARCHAR(50),
    @Email VARCHAR(100),
    @Phone VARCHAR(15),
    @Password VARCHAR(255),
    @Address VARCHAR(255)
)
AS
BEGIN

    SET NOCOUNT ON;
    --

    --check if attribute are valid
    IF @First_Name IS NULL OR LTRIM(RTRIM(@First_Name))=''
        THROW 103,'First Name cannot be empty.',1;

    IF @Last_Name IS NULL OR LTRIM(RTRIM(@Last_Name))=''
        THROW 104,'Last Name cannot be empty.',1;

    IF @Email IS NULL OR LTRIM(RTRIM(@Email))=''
        THROW 105,'Email cannot be empty.',1;

    IF @Phone IS NULL OR LTRIM(RTRIM(@Phone))=''
        THROW 106,'Phone cannot be empty.',1;

    IF @Password IS NULL OR LTRIM(RTRIM(@Password))=''
        THROW 107,'Password cannot be empty.',1;

    IF @Address IS NULL OR LTRIM(RTRIM(@Address))=''
        THROW 108,'Address cannot be empty.',1;

   -- check for email redundancy
   IF EXISTS
    (
        SELECT *
        FROM Customer
        WHERE Email=@Email
    )
    BEGIN
        THROW 109,'Email already exists.',1;
    END
    
    --check for phone number redundancy
    IF EXISTS
    (
        SELECT *
        FROM Customer
        WHERE Phone=@Phone
    )
    BEGIN
        THROW 110,'Phone number already exists.',1;
    END

    -- check for password length
    IF LEN(@Password) < 8
    BEGIN
        THROW 111,'Password must contain at least 8 characters.',1;
    END

    INSERT INTO Customer
    (
        First_Name,
        Last_Name,
        Email,
        Phone,
        C_Password,
        C_Address
    )
    VALUES
    (
        @First_Name,
        @Last_Name,
        @Email,
        @Phone,
        @Password,
        @Address
    );

    PRINT 'Customer Registered Successfully.';

    
    SELECT *
    FROM Customer
    WHERE Customer_ID = SCOPE_IDENTITY();

END;


EXEC sp_AddCustomer
@First_Name='hira',
@Last_Name='Maharjan',
@Email='hira@yahoo.com',
@Phone='9876545258',
@Password='hira987654',
@Address='Bhaktapur';
GO

select * from Customer;

---------------------------------------------------------------
-- stored procedure sp_updateCustomer

DROP PROCEDURE IF EXISTS sp_UpdateCustomer;
GO

CREATE PROCEDURE sp_UpdateCustomer
(
    @Customer_ID INT,
    @First_Name VARCHAR(50),
    @Last_Name VARCHAR(50),
    @Email VARCHAR(100),
    @Phone VARCHAR(15),
    @Password VARCHAR(255),
    @Address VARCHAR(255)
)
AS
BEGIN

    SET NOCOUNT ON;

    -- check customer exists
    IF NOT EXISTS
    (
        SELECT *
        FROM Customer
        WHERE Customer_ID=@Customer_ID
    )
    BEGIN
        THROW 112,'Customer does not exist.',1;
    END

    -- check if email is used
    IF EXISTS
    (
        SELECT *
        FROM Customer
        WHERE Email=@Email
        AND Customer_ID<>@Customer_ID
    )
    BEGIN
        THROW 113,'Email already used by another customer.',1;
    END

    -- check if phone number is used
    IF EXISTS
    (
        SELECT *
        FROM Customer
        WHERE Phone=@Phone
        AND Customer_ID<>@Customer_ID
    )
    BEGIN
        THROW 114,'Phone number already used by another customer.',1;
    END
    
    -- check if password is 8 character
    IF LEN(@Password)<8
    BEGIN
        THROW 115,'Password must contain at least 8 characters.',1;
    END

    
    UPDATE Customer
    SET
        First_Name=@First_Name,
        Last_Name=@Last_Name,
        Email=@Email,
        Phone=@Phone,
        C_Password=@Password,
        C_Address=@Address
    WHERE Customer_ID=@Customer_ID;

    PRINT 'Customer Profile Updated Successfully.';

    SELECT *
    FROM Customer
    WHERE Customer_ID=@Customer_ID;

END;


EXEC sp_UpdateCustomer
@Customer_ID=1,
@First_Name='Shaiju',
@Last_Name='Maharjan',
@Email='shaijumaharjan@gmail.com',
@Phone='9840744703',
@Password='shaiju123',
@Address='Kathmandu, Nepal';
GO
select * from Customer


--------------------------------------------------------------------------
--stored procedure sp_AddProduct

DROP PROCEDURE IF EXISTS sp_AddProduct;
GO

CREATE PROCEDURE sp_AddProduct
(
    @Supplier_ID INT,
    @Product_Name VARCHAR(100),
    @P_Description VARCHAR(255),
    @Price DECIMAL(10,2),
    @Category VARCHAR(50),
    @Stock_Quantity INT,
    @Reorder_Level INT
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Check Supplier Exists
        IF NOT EXISTS
        (
            SELECT 1
            FROM Suppliers
            WHERE Supplier_ID = @Supplier_ID
        )
            THROW 201, 'Supplier does not exist.', 1;

        -- Validate Product Name
        IF @Product_Name IS NULL 
           OR LTRIM(RTRIM(@Product_Name)) = ''
            THROW 202, 'Product Name cannot be empty.', 1;

        -- Validate Price
        IF @Price IS NULL OR @Price <= 0
            THROW 203, 'Price must be greater than zero.', 1;

        -- Validate Stock Quantity
        IF @Stock_Quantity IS NULL OR @Stock_Quantity < 0
            THROW 205, 'Stock quantity cannot be negative.', 1;

        -- Validate Reorder Level
        IF @Reorder_Level IS NULL OR @Reorder_Level < 0
            THROW 206, 'Reorder level cannot be negative.', 1;

        -- Duplicate Product Check
        IF EXISTS
        (
            SELECT 1
            FROM Products
            WHERE Product_Name = @Product_Name
              AND Supplier_ID = @Supplier_ID
        )
            THROW 204, 'Product already exists for this supplier.', 1;

        -- Insert Product
        INSERT INTO Products
        (
            Supplier_ID,
            Product_Name,
            P_Description,
            Price,
            Category
        )
        VALUES
        (
            @Supplier_ID,
            @Product_Name,
            @P_Description,
            @Price,
            @Category
        );

        -- Get newly inserted Product ID
        DECLARE @Product_ID INT;
        SET @Product_ID = SCOPE_IDENTITY();

        -- Insert Inventory for the New Product
        INSERT INTO Inventory
        (
            Product_ID,
            Supplier_ID,
            Stock_Quantity,
            Reorder_Level
        )
        VALUES
        (
            @Product_ID,
            @Supplier_ID,
            @Stock_Quantity,
            @Reorder_Level
        );

        -- Commit both Product and Inventory
        COMMIT TRANSACTION;

        PRINT 'Product and Inventory Added Successfully.';

        -- Display newly added product
        SELECT
            P.Product_ID,
            P.Product_Name,
            P.P_Description,
            P.Price,
            P.Category,
            I.Stock_Quantity,
            I.Reorder_Level
        FROM Products P
        INNER JOIN Inventory I
            ON P.Product_ID = I.Product_ID
        WHERE P.Product_ID = @Product_ID;

    END TRY

    BEGIN CATCH

        -- Rollback if any error occurs
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;

    END CATCH
END;
GO

EXEC sp_AddProduct
    @Supplier_ID = 1,
    @Product_Name = 'Gaming Mouse',
    @P_Description = 'RGB Wireless Mouse',
    @Price = 45.00,
    @Category = 'Electronics',
    @Stock_Quantity = 30,
    @Reorder_Level = 5;
GO

select * from Products
select * from inventory

 ---------------------------------------------------------------------
-- Stored Procedure: Update Product
DROP PROCEDURE IF EXISTS sp_UpdateProduct;
GO

CREATE PROCEDURE sp_UpdateProduct
(
    @Product_ID INT,
    @Supplier_ID INT,
    @Product_Name VARCHAR(100),
    @P_Description VARCHAR(255),
    @Price DECIMAL(10,2),--
    @Category VARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Product Exists
    IF NOT EXISTS
    (
        SELECT *
        FROM Products
        WHERE Product_ID=@Product_ID
    )
        THROW 205,'Product does not exist.',1;

    -- Supplier Exists
    IF NOT EXISTS
    (
        SELECT *
        FROM Suppliers
        WHERE Supplier_ID=@Supplier_ID
    )
        THROW 206,'Supplier does not exist.',1;

    -- Validate Price
    IF @Price<=0
        THROW 207,'Price must be greater than zero.',1;

    -- Duplicate Product Check
    IF EXISTS
    (
        SELECT *
        FROM Products
        WHERE Product_Name=@Product_Name
          AND Supplier_ID=@Supplier_ID
          AND Product_ID<>@Product_ID
    )
        THROW 208,'Another product with the same name already exists.',1;

    UPDATE Products
    SET
        Supplier_ID=@Supplier_ID,
        Product_Name=@Product_Name,
        P_Description=@P_Description,
        Price=@Price,
        Category=@Category
    WHERE Product_ID=@Product_ID;

    PRINT 'Product Updated Successfully.';

    SELECT *
    FROM Products
    WHERE Product_ID=@Product_ID;

END;

EXEC sp_UpdateProduct
    @Product_ID = 2,
    @Supplier_ID = 3,
    @Product_Name = 'Nike Air Max Shoes',
    @P_Description = 'Updated Lightweight running shoes for men',
    @Price = 200.00,
    @Category = 'Fashion';

EXEC sp_UpdateProduct
    @Product_ID = 1,
    @Supplier_ID = 11,
    @Product_Name = 'iPhone 16 Pro',
    @P_Description = 'Updated Apple smartphone',
    @Price = 1450.00,
    @Category = 'Electronics';

GO
 select * from Products;
 select * from Inventory;


------------------------------------------------------------
-- Stored Procedure: Delete Product
DROP PROCEDURE IF EXISTS sp_DeleteProduct;
GO

CREATE PROCEDURE sp_DeleteProduct
(
    @Product_ID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Check Product Exists
    IF NOT EXISTS
    (
        SELECT *
        FROM Products
        WHERE Product_ID=@Product_ID
    )
        THROW 209,'Product does not exist.',1;

    -- Delete Inventory
    DELETE FROM Inventory
    WHERE Product_ID=@Product_ID;

    -- Delete Product
    DELETE FROM Products
    WHERE Product_ID=@Product_ID;

    PRINT 'Product Deleted Successfully.';

END;
GO

EXEC sp_DeleteProduct
    @Product_ID = 12;
GO

SELECT * FROM Products;
SELECT * FROM Inventory;

------------------------------------------------------------
-- Stored Procedure: Search Product

DROP PROCEDURE IF EXISTS sp_SearchProduct;
GO

CREATE PROCEDURE sp_SearchProduct
(
    @Keyword VARCHAR(100)
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        Product_ID,
        Product_Name,
        P_Description,
        Price,
        Category,
        Supplier_ID
    FROM Products
    WHERE Product_Name LIKE '%' + @Keyword + '%'
       OR Category LIKE '%' + @Keyword + '%'
    ORDER BY Product_Name;

END;
Go

EXEC sp_SearchProduct
    @Keyword = 'iPhone';

EXEC sp_SearchProduct
    @Keyword = 'Electronics';
GO




-------------------------------------------------------
--Stored Procedure sp_PlaceOrder

DROP PROCEDURE IF EXISTS sp_PlaceOrder;
GO

CREATE PROCEDURE sp_PlaceOrder
(
    @Customer_ID INT,
    @Shipping_Address VARCHAR(255)
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE
        @Order_ID INT,
        @Total DECIMAL(10,2);

    BEGIN TRY

        BEGIN TRANSACTION;

        -- Check Customer Exists
        IF NOT EXISTS
        (
            SELECT *
            FROM Customer
            WHERE Customer_ID=@Customer_ID
        )
            THROW 301,'Customer does not exist.',1;

        -- Check Cart
        IF NOT EXISTS
        (
            SELECT *
            FROM Cart
            WHERE Customer_ID=@Customer_ID
        )
            THROW 302,'Cart is empty.',1;

        -- Check Product Exists
        IF EXISTS
        (
            SELECT *
            FROM Cart C
            LEFT JOIN Products P
            ON C.Product_ID=P.Product_ID
            WHERE C.Customer_ID=@Customer_ID
            AND P.Product_ID IS NULL
        )
            THROW 303,'One or more products do not exist.',1;

        -- Check Stock Availability
        IF EXISTS
        (
            SELECT *
            FROM Cart C
            JOIN Inventory I
            ON C.Product_ID=I.Product_ID
            WHERE C.Customer_ID=@Customer_ID
            AND C.Quantity>I.Stock_Quantity
        )
            THROW 304,'Insufficient stock available.',1;

        -- Calculate Total
        SELECT
            @Total=SUM(C.Quantity*P.Price)
        FROM Cart C
        JOIN Products P
        ON C.Product_ID=P.Product_ID
        WHERE C.Customer_ID=@Customer_ID;

        -- Insert Order
        INSERT INTO Orders
        (
            Customer_ID,
            Order_Date,
            O_Status,
            Total_Amount,
            Shipping_Address
        )
        VALUES
        (
            @Customer_ID,
            GETDATE(),
            'Pending',
            @Total,
            @Shipping_Address
        );

        SET @Order_ID=SCOPE_IDENTITY();

        -- Insert Order Detail
        INSERT INTO Order_Detail
        (
            Order_ID,
            Product_ID,
            Quantity,
            Unit_Price,
            Subtotal
        )
        SELECT
            @Order_ID,
            C.Product_ID,
            C.Quantity,
            P.Price,
            C.Quantity*P.Price
        FROM Cart C
        JOIN Products P
        ON C.Product_ID=P.Product_ID
        WHERE C.Customer_ID=@Customer_ID;

        -- Reduce Inventory
        UPDATE I
        SET
            Stock_Quantity=Stock_Quantity-C.Quantity,
            Last_Updated=GETDATE()
        FROM Inventory I
        JOIN Cart C
        ON I.Product_ID=C.Product_ID
        WHERE C.Customer_ID=@Customer_ID;

        -- Remove Cart Items
        DELETE FROM Cart
        WHERE Customer_ID=@Customer_ID;

        COMMIT TRANSACTION;

        PRINT 'Order placed successfully.';

        SELECT *
        FROM Orders
        WHERE Order_ID=@Order_ID;

    END TRY

    BEGIN CATCH

        IF @@TRANCOUNT>0
            ROLLBACK TRANSACTION;

        THROW;

    END CATCH

END;
GO


EXEC sp_PlaceOrder
    @Customer_ID=1,
    @Shipping_Address='Lalitpur, Nepal';

GO
select * from Orders;
select  * from Order_Detail;
select * from Cart;

select * from Inventory;


---------------------------------------------------------
--Stored Procedure sp_ProcessPayment
DROP PROCEDURE IF EXISTS sp_ProcessPayment;
GO

CREATE PROCEDURE sp_ProcessPayment
(
    @Order_ID INT,
    @Pay_Method VARCHAR(50),
    @Transaction_ID VARCHAR(100)
)
AS
BEGIN

    SET NOCOUNT ON;

    DECLARE
        @Amount DECIMAL(10,2);

    BEGIN TRY

        BEGIN TRANSACTION;

        -- Check Order Exists
        IF NOT EXISTS
        (
            SELECT *
            FROM Orders
            WHERE Order_ID=@Order_ID
        )
            THROW 401,'Order does not exist.',1;

        -- Check Duplicate Transaction
        IF EXISTS
        (
            SELECT *
            FROM Payment
            WHERE Transaction_ID=@Transaction_ID
        )
            THROW 402,'Transaction ID already exists.',1;

        -- Get Order Amount
        SELECT
            @Amount=Total_Amount
        FROM Orders
        WHERE Order_ID=@Order_ID;

        -- Insert Payment
        INSERT INTO Payment
        (
            Order_ID,
            Payment_Date,
            Amount,
            Pay_Method,
            Pay_Status,
            Transaction_ID
        )
        VALUES
        (
            @Order_ID,
            GETDATE(),
            @Amount,
            @Pay_Method,
            'Completed',
            @Transaction_ID
        );

        -- Update Order Status
        UPDATE Orders
        SET
            O_Status='Paid'
        WHERE Order_ID=@Order_ID;

        COMMIT TRANSACTION;

        PRINT 'Payment processed successfully.';

        SELECT *
        FROM Payment
        WHERE Payment_ID=SCOPE_IDENTITY();

    END TRY

    BEGIN CATCH

        IF @@TRANCOUNT>0
            ROLLBACK TRANSACTION;

        THROW;

    END CATCH

END;
GO

EXEC sp_ProcessPayment
    @Order_ID=2,
    @Pay_Method='Debit Card',
    @Transaction_ID='TXN10012';

GO

select * from Orders;
select * from Order_Detail;
select * from Payment;


-------------------------------------------------------------------
--restore when an order is cancelled

DROP TRIGGER IF EXISTS trg_RestoreStock;
GO

CREATE TRIGGER trg_RestoreStock
ON Orders
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Restore inventory only when order becomes Cancelled
    IF UPDATE(O_Status)
    BEGIN
        UPDATE I
        SET
            I.Stock_Quantity = I.Stock_Quantity + OD.Quantity,
            I.Last_Updated = GETDATE()
        FROM Inventory I
        INNER JOIN Order_Detail OD
            ON I.Product_ID = OD.Product_ID
        INNER JOIN inserted ins
            ON OD.Order_ID = ins.Order_ID
        INNER JOIN deleted del
            ON del.Order_ID = ins.Order_ID
        WHERE
            ins.O_Status = 'Cancelled'
            AND del.O_Status <> 'Cancelled';
    END
END;

SELECT * FROM Inventory;
SELECT * FROM Orders;
SELECT * FROM Order_Detail;
SELECT * FROM Payment;

UPDATE Orders
SET O_Status = 'Cancelled'
WHERE Order_ID = 2;

select * from Orders

GO
