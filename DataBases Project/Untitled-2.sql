CREATE table Users(
    username VARCHAR(20) PRIMARY KEY,
    password VARCHAR(20),
    first_name VARCHAR(20),
    last_name VARCHAR(20),
    email VARCHAR(20) NOT NULL
)

CREATE Table User_mobile_numbers(
    mobile_number INT, 
    username VARCHAR(20),
    PRIMARY KEY(mobile_number,username),
    FOREIGN KEY(username) REFERENCES Users
)

CREATE Table User_Addresses(
    address VARCHAR(20), 
    username VARCHAR(20),
    PRIMARY KEY(address,username),
    FOREIGN KEY(username) REFERENCES Users
)


CREATE Table Customer(
    username VARCHAR(20) PRIMARY KEY,
    points INT,
    FOREIGN KEY(username) REFERENCES Users
)
CREATE Table Admins(
    username VARCHAR(20) PRIMARY KEY,
    FOREIGN KEY(username) REFERENCES Users
)
CREATE Table Vendor(
    username VARCHAR(20) PRIMARY KEY NOT NULL,
    activated BIT, 
    company_name VARCHAR(20) NOT NULL,
    bank_acc_no VARCHAR(20) NOT NULL,
    admin_username VARCHAR(20),
    FOREIGN KEY(username) REFERENCES Users,
    FOREIGN KEY(admin_username) REFERENCES Admins
)

CREATE Table Delivery_Person(
    username VARCHAR(20) PRIMARY KEY,
    FOREIGN KEY(username) REFERENCES Users,
    is_activated BIT
)

CREATE Table Credit_Card(
    number INT PRIMARY KEY,
    expiry_date DATETIME,
    cvv_code VARCHAR 
)

CREATE Table Delivery(
    id INT PRIMARY KEY,
    time_duration INT NOT NULL,
    fees INT NOT NULL,
    username VARCHAR(20),
    FOREIGN KEY(username) REFERENCES Admins
)


CREATE Table Orders(
    order_no INT PRIMARY KEY IDENTITY,
    order_date DATETIME,
    total_amount decimal(10,2),
    cash_amount decimal(10,2),
    credit_amount decimal(10,2),
    payment_type VARCHAR(20) NOT NULL, 
   order_status VARCHAR(20),
   remaining_days INT,
   time_limit INT,
   giftcard_code_used VARCHAR(20),
    customer_name VARCHAR(20),
   delivery_id INT,
   creditCard_number INT,
   FOREIGN KEY(customer_name) REFERENCES Customer,
   FOREIGN KEY(delivery_id) REFERENCES Delivery,
   FOREIGN KEY(creditCard_number) REFERENCES Credit_Card,
   FOREIGN KEY(giftcard_code_used) REFERENCES Giftcard


)

CREATE Table Product(
    serial_no INT PRIMARY KEY IDENTITY,
    product_name VARCHAR(20) NOT NULL,
    category VARCHAR(20) NOT NULL,
    product_description text NOT NULL,
    final_price decimal(10,2) NOT NULL,
    color VARCHAR(20) NOT NULL,
    available BIT NOT NULL,
    rate INT NOT NULL,
    vendor_username VARCHAR(20),
    customer_username VARCHAR(20),
    customer_order_id  INT,
    FOREIGN KEY(vendor_username) REFERENCES Vendor,
    FOREIGN KEY(customer_order_id) REFERENCES Orders,
    FOREIGN KEY(customer_username) REFERENCES customer
)

CREATE Table CustomerAddsToCartProduct(
    serial_no INT,
    customer_name VARCHAR(20),
    PRIMARY KEY(serial_no,customer_name),
    FOREIGN KEY(serial_no) REFERENCES Product,
    FOREIGN KEY(customer_name) REFERENCES Customer
)

CREATE Table Todays_Deals(
    deal_id INT PRIMARY KEY,
    deal_amount decimal(10,2),
    expiry_date DATETIME,
    admin_username VARCHAR(20),
    FOREIGN KEY(admin_username) REFERENCES Admins
)

CREATE Table Todays_Deals_Product(
    deal_id INT,
    serial_no INT,
    issue_date DATETIME,
    PRIMARY KEY(deal_id,serial_no),
    FOREIGN KEY(deal_id) REFERENCES Todays_Deals,
    FOREIGN KEY(serial_no) REFERENCES Product
)

CREATE Table Offer(
    offer_id INT PRIMARY KEY,
    offer_amount decimal(10,2),
    expiry_date DATETIME
)

CREATE TABLE offersOnProduct(
    offer_id INT,
    serial_no INT,
    PRIMARY KEY(offer_id,serial_no),
    FOREIGN KEY(offer_id) REFERENCES Offer,
    FOREIGN KEY(serial_no) REFERENCES Product
)

CREATE TABLE Customer_Question_Product(
    serial_no INT,
    customer_name VARCHAR(20),
    question text,
    answer text,
    PRIMARY KEY(serial_no,customer_name),
    FOREIGN KEY(serial_no) REFERENCES Product,
    FOREIGN KEY(customer_name) REFERENCES Customer
)

CREATE TABLE WishList(
    username VARCHAR(20),
    name VARCHAR(20),
    PRIMARY KEY(username,name),
    FOREIGN KEY(username) REFERENCES Customer
)

CREATE TABLE Giftcard(
    code INT PRIMARY KEY,
    expiry_date DATETIME,
    amount decimal(10,2),
    username VARCHAR(20),
    FOREIGN KEY(username) REFERENCES Admins
)

CREATE TABLE Wishlist_Product(
    username VARCHAR(20),
    wish_name VARCHAR(20),
    serial_no INT,
    PRIMARY KEY(username,wish_name,serial_no),
    FOREIGN KEY(username,wish_name) REFERENCES WishList,
    FOREIGN KEY(serial_no) REFERENCES Product
)

CREATE TABLE Admin_Customer_Giftcard(
    code INT,
    Customer_name VARCHAR(20),
    admin_username VARCHAR(20),
    remaining_points INT,
    PRIMARY KEY(code,Customer_name,admin_username),
    FOREIGN KEY(code) REFERENCES Giftcard,
    FOREIGN KEY(Customer_name) REFERENCES Customer,
    FOREIGN KEY(admin_username) REFERENCES Admins
)

CREATE TABLE Admin_Delivery_Order(
    delivery_username VARCHAR(20),
    order_no INT,
    admin_username VARCHAR(20),
    delivery_window DATETIME,
    PRIMARY KEY(delivery_username,order_no),
    FOREIGN KEY(delivery_username) REFERENCES Delivery_Person,
    FOREIGN KEY(order_no) REFERENCES Orders,
    FOREIGN KEY(admin_username) REFERENCES Admins
)

CREATE TABLE Customer_Creditcard(
    Customer_name VARCHAR(20),
    cc_number INT,
    PRIMARY KEY(Customer_name,cc_number),
    FOREIGN KEY(Customer_name) REFERENCES Customer,
    FOREIGN KEY(cc_number) REFERENCES Credit_Card,
)

GO
CREATE PROC customerRegister
@username varchar(20),
@first_name varchar(20), 
@last_name varchar(20),
@password varchar(20),
@email varchar(50)
AS
INSERT INTO Users(username, password, first_name, last_name, email) 
VALUES(@username, @password, @first_name, @last_name, @email)
INSERT INTO Customer VALUES(@username,0)
GO

CREATE PROC vendorRegister
@username varchar(20),
@first_name varchar(20), 
@last_name varchar(20),
@password varchar(20),
@email varchar(50),
@company_name varchar(20), 
@bank_acc_no VARCHAR(20) 
AS
INSERT INTO Users(username, password, first_name, last_name, email) 
VALUES(@username, @password, @first_name, @last_name, @email)
INSERT INTO Vendor(username,company_name,bank_acc_no) 
VALUES(@username,@company_name,@bank_acc_no)
GO

CREATE PROC userLogin
@username varchar(20), 
@password varchar(20),
@success bit output, 
@type int output
AS
IF( EXISTS (SELECT *
FROM Users 
WHERE username = @username AND password = @password))
set @success = 1
else 
set @success = 0
IF( EXISTS (SELECT *
FROM Customer 
WHERE username = @username))
set @type = 0
IF( EXISTS (SELECT *
FROM Vendor 
WHERE username = @username))
set @type = 1
IF( EXISTS (SELECT *
FROM Admins 
WHERE username = @username))
set @type = 2
IF( EXISTS (SELECT *
FROM Delivery_Person 
WHERE username = @username))
set @type = 3
GO

CREATE PROC addMobile
@username varchar(20), 
@mobile_number varchar(20)
AS 
INSERT INTO User_mobile_numbers VALUES(@mobile_number,@username) 
GO

CREATE PROC addAddress
@username varchar(20),
@address varchar(100)
AS
Insert into User_Addresses Values (@address, @username)
GO

CREATE PROC showProducts
AS
SELECT *
FROM Product
GO

CREATE PROC ShowProductsbyPrice
AS
Select * from Products
order by final_price 
GO


CREATE PROC searchbyname
@text varchar(20) 
AS
SELECT *
FROM Product
WHERE product_name = @text
GO

CREATE PROC AddQuestion
@serial int,
@customer varchar(20),
@Question varchar(50)
AS
insert into 
Customer_Question_Product(serial_no, customer_name, question)
Values(@serial,@customer,@Question)
GO

CREATE PROC addToCart
@customername varchar(20), 
@serial int
AS
INSERT INTO CustomerAddstoCartProduct VALUES(@serial,@customername)
GO

CREATE PROC removefromCart
 @customername varchar(20),
 @serial int
 AS
 Delete from CustomerAddstoCartProduct --Is delete working
 where @serial = serial_no and @customername = customer_name
 GO


CREATE PROC createWishlist
@customername varchar(20), 
@name varchar(20)
AS
INSERT INTO CustomerAddstoCartProduct VALUES(@customername ,@name)
GO

CREATE PROC AddtoWishlist
 @customername varchar(20),
 @wishlistname varchar(20),
 @serial int --Wishlist_Product(username, wish_name, serial_no)
 AS
 insert into Wishlist_Product values (@customername, @wishlistname,@serial)
 GO

CREATE PROC removefromWishlist
 @customername varchar(20), 
 @wishlistname varchar(20), 
 @wish_name int
 AS
 Delete from Wishlist_Product 
 where @customername=username and @wishlistname = wish_name and @wish_name= serial_no
 GO

CREATE PROC showWishlistProduct
@customername varchar(20), 
@name varchar(20)
AS
SELECT p.*
From Wishlist_Product wp INNER JOIN Product p ON wp.serial_no =  p.serial_no
WHERE (username = @customername) AND (name = @name)
GO 

CREATE PROC viewMyCart --CustomerAddstoCartProduct(serial_no, customer_name) Product(serial_no
 @customer varchar(20)
 AS
 Select p.product_name from CustomerAddstoCartProduct cart inner join Product p on p.serial_no = cart.serial_no
 where cart.customer_name = @customer
 Go


CREATE PROC calculatepriceOrder
@customername varchar(20),
@sum decimal(10,2) OUTPUT
AS
SELECT @sum = sum(P.final_price)
FROM CustomerAddstoCartProduct CP INNER JOIN Product P ON CP.serial_no = P.serial_no
WHERE CP.customer_name = @customername

GO

CREATE PROC emptyCart
@customername varchar(20)
AS
DELETE FROM CustomerAddstoCartProduct
WHERE customer_name = @customername
GO

CREATE PROC makeOrder
@customername varchar(20)
AS
DECLARE @sum decimal(10,2)
EXEC calculatepriceOrder @sum OUTPUT
INSERT INTO Orders (order_date,total_amount,customer_name,order_status)
VALUES(CURRENT_TIMESTAMP,@sum,@customername,'not processed')
EXEC emptyCart @customername
GO

CREATE PROC productsinorder
@customername varchar(20), 
@orderID int
AS
SELECT *
FROM Product
WHERE (customer_username = @customername) AND (customer_order_id = @orderID)
GO

CREATE PROC cancelOrder
 @orderid int
 AS
 Delete from Orders where order_no = @orderid
 and (order_status = 'not processed' or order_status = 'in process')
 Go

-- returnProduct

CREATE PROC ShowproductsIbought
@customername varchar(20)
AS
SELECT *
FROM Product
WHERE customer_username = @customername
GO

CREATE PROC rate
@serialno int, 
@rate int , 
@customername varchar(20)
AS
UPDATE product
SET rate = @rate
WHERE serial_no = @serialno AND customer_username = @customername
GO

CREATE PROC SpecifyAmount
@customername varchar(20),
@orderID int, 
@cash decimal(10,2), 
@credit decimal(10,2)
AS
Update Orders
set cash_amount = @cash,
credit_amount = @credit
where order_no = @orderID and customer_name= @customername --Updating points
Go

CREATE PROC ChooseCreditCard
@creditcard varchar(20),
@orderID int
AS
Update Orders
Set creditCard_number = @creditcard
where order_no= @orderID
GO

CREATE PROC viewDeliveryTypes
AS 
-- what should we select
SELECT *
FROM delivery
GO

CREATE PROC specifydeliverytype
@orderID INT, 
@deliveryID INT
AS
UPDATE Orders
SET delivery_id = @deliveryID
WHERE order_no = @orderID
GO

CREATE PROC trackRemainingDays
@orderid INT, 
@customername VARCHAR(20),
@days INT OUTPUT
AS
SELECT @days = remaining_days 
FROM Orders
WHERE order_no = @orderid AND customer_name = @customername
GO

--CREATE PROC recommmend
--@customername varchar(20)

CREATE PROC postProduct
@vendorUsername varchar(20), 
@product_name varchar(20) ,
@category varchar(20), 
@product_description text, 
@price decimal(10,2), 
@color varchar(20)
AS
INSERT INTO Product (vendor_username,product_name,category,product_description,final_price,color)
VALUES(@vendorUsername,@product_name,@category,@product_description,@price,@color)
GO

CREATE PROC vendorviewProducts
@vendorname varchar(20)
AS
SELECT *
FROM Product
WHERE vendor_username = @vendorname
GO

CREATE PROC EditProduct
@vendorname varchar(20), 
@serialnumber int, 
@product_name varchar(20) ,
@category varchar(20), 
@product_description text , 
@price decimal(10,2), 
@color varchar(20)
AS
UPDATE Product 
SET product_name = @product_name, serial_no = @serialnumber,category = @category, 
product_description = @product_description, final_price = @price, color = @color,vendor_username = @vendorname
GO

CREATE PROC deleteProduct
@vendorname varchar(20), 
@serialnumber int
AS
DELETE from Product
WHERE serial_no = @serialnumber AND vendor_username = @vendorname
GO























