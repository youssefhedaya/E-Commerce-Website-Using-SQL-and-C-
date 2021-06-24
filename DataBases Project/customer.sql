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
EXEC customerRegister 'ahmed.ashraf','ahmed','ashraf','pass123','ahmed@yahoo.com'
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
INSERT INTO Vendor(username,company_name,bank_acc_no, activated)
VALUES(@username,@company_name,@bank_acc_no,0)
GO
--EXEC vendorRegister 'eslam.mahmoud','eslam','mahmoud','1234','eslam@yahoo','Market','132132513'


CREATE PROC userLogin
@username varchar(20),
@password varchar(20),
@success bit output,
@type int output
AS
IF( EXISTS (SELECT *
FROM Users
WHERE username = @username AND password = @password))
Begin
set @success = 1
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
END
else
set @success = 0
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
SELECT  product_name, product_description, price, final_price, color
FROM Product

GO

CREATE PROC ShowProductsbyPrice
AS
Select product_name, product_description, price, final_price, color
from Product
order by final_price
GO


CREATE PROC searchbyname
@text varchar(20)
AS
SET @text = @text + '%'
SET @text = '%' + @text

SELECT *
FROM Product
WHERE product_name like @text
GO

CREATE PROC AddQuestion
@serial int,
@customer varchar(20),
@Question varchar(50)
AS
INSERT INTO
Customer_Question_Product(serial_no, customer_name, question)
Values(@serial,@customer,@Question)
GO

CREATE PROC addToCart
@customername VARCHAR(20),
@serial INT
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
INSERT INTO Wishlist VALUES(@customername ,@name)
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
 SELECT p.product_name, p.product_description, p.price, p.final_price , p.color
 From Wishlist_Product wp INNER JOIN Product p ON wp.serial_no =  p.serial_no
 WHERE (username = @customername) AND (wp.wish_name = @name)
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
Declare @ordernum INT
DECLARE @sum decimal(10,2)
EXEC calculatepriceOrder @customername,@sum OUTPUT
INSERT INTO Orders (order_date,total_amount,customer_name,order_status,payment_type,credit_amount, cash_amount)
VALUES(CURRENT_TIMESTAMP,@sum,@customername,'not processed', 'cash',0,0)
Select @ordernum = MAX(order_no) 
from Orders
UPDATE Product
SET Available = 0,
customer_username = @customername,
customer_order_id = @ordernum
WHERE serial_no IN (SELECT serial_no
FROM CustomerAddsToCartProduct
WHERE customer_name = @customername)
EXEC emptyCart @customername
GO

DECLARE @sum decimal(10,2)
EXEC calculatepriceOrder 'ammar.yasser',@sum OUTPUT
PRINT @sum
--DROP PROC makeOrder


GO
CREATE PROC productsinorder
@customername varchar(20),
@orderID int
AS
SELECT *
FROM Product
WHERE (customer_username = @customername) AND (customer_order_id = @orderID)
DELETE FROM CustomerAddsToCartProduct
WHERE serial_no IN (SELECT serial_no
FROM Product
WHERE customer_order_id = @orderID)
GO

CREATE PROC cancelOrder
 @orderid int
 AS
 DECLARE @cash decimal(10,2)
 Declare @credit decimal(10,2)
 DECLARE @total decimal(10,2)
 DECLARE @expiry DATE
 DECLARE @name VARCHAR(20)
 select @cash = cash_amount from Orders where order_no = @orderid
 select @credit = credit_amount from Orders where order_no = @orderid
 select @total = total_amount from Orders where order_no = @orderid
SELECT @expiry = expiry_date
FROM Orders O INNER JOIN Giftcard G ON O.giftcard_code_used = G.code 
WHERE Order_no = @orderid
select @name = customer_name FROM Orders where order_no = @orderid
IF (@credit + @cash < @total AND (@expiry > CURRENT_TIMESTAMP))
BEGIN
UPDATE Customer 
SET points = points + (@total - (@credit + @cash))
WHERE username = @name
UPDATE Admin_Customer_Giftcard
SET remaining_points = remaining_points + (@total - (@credit + @cash))
WHERE Customer_name = @name
END
UPDATE Product 
SET Available = 1, customer_order_id = NULL, customer_username = NULL
WHERE customer_order_id =  @orderid
 Delete from Orders
 where order_no = @orderid
 and (order_status = 'not processed' or order_status = 'in process')
 DELETE FROM Admin_Delivery_Order 
 WHERE order_no = @orderid
GO



CREATE PROC returnProduct
@serialno int,
@orderid int
 AS
 declare @returnvalue DECIMAL (10,2)
 declare @customername VARCHAR(20)
 declare @payedinpoints DECIMAL(10,2)
 DECLARE @cash decimal(10,2)
 Declare @credit decimal(10,2)
 DECLARE @total decimal(10,2)
DECLARE @expiry DATETIME
SELECT @expiry = expiry_date
FROM Orders O INNER JOIN Giftcard G ON O.giftcard_code_used = G.code 
WHERE Order_no = @orderid
  select @total = total_amount from Orders where order_no = @orderid
  select @cash = cash_amount from Orders where order_no = @orderid
 select @credit = credit_amount from Orders where order_no = @orderid
SET @payedinpoints = @total - (@cash + @credit) 
SELECT @returnvalue = final_price from Product
 where serial_no = @serialno
Update Orders
SET total_amount = total_amount - @returnvalue

if @payedinpoints > 0
BEGIN
 Update Product
 SET available = 1,
customer_username = NULL,
customer_order_id = NULL
 where serial_no = @serialno
 
 SELECT @customername = customer_name from Orders
 where order_no = @orderid
 if @returnvalue >= @payedinpoints AND @expiry > CURRENT_TIMESTAMP
 BEGIN
  update Admin_Customer_Giftcard
  SET remaining_points = remaining_points + @payedinpoints
  where Customer_name = @customername
 UPDATE Customer
 SET points = points + @payedinpoints
 where username = @customername
 END
 if @returnvalue < @payedinpoints AND @expiry > CURRENT_TIMESTAMP
 BEGIN
 update Admin_Customer_Giftcard
  SET remaining_points = remaining_points + @payedinpoints
  where Customer_name = @customername
 UPDATE Customer
 SET points = points + @returnvalue
 where username = @customername
 END
 END
GO

CREATE PROC ShowproductsIbought
@customername varchar(20)
AS
SELECT serial_no,product_name,category,product_description,price,final_price,color
FROM Product
WHERE customer_username = @customername
GO

--EXEC ShowproductsIbought 'ahmed.ashraf'

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
--EXEC rate 1,3,'ahmed.ashraf'


CREATE PROC SpecifyAmount
@customername varchar(20),
@orderID int,
@cash decimal(10,2),
@credit decimal(10,2)
AS
PRINT 'hedaya'
DECLARE @total decimal(10,2)
DECLARE @giftcardused VARCHAR(10)
SELECT @total = total_amount
FROM Orders
WHERE order_no = @orderID

IF(@credit IS NULL OR @credit = 0 )
BEGIN
UPDATE Orders
SET cash_amount = @cash,payment_type = 'cash'
WHERE order_no = @orderID AND
customer_name= @customername
IF(@total > @cash)
BEGIN
SELECT @giftcardused = A.code
FROM Admin_Customer_Giftcard A INNER JOIN Giftcard G ON A.code = G.code
WHERE Customer_name = @customername AND G.expiry_date > CURRENT_TIMESTAMP
PRINT @giftcardused
UPDATE Admin_Customer_Giftcard
SET remaining_points = remaining_points - (@total-@cash)
WHERE Customer_name = @customername
UPDATE Customer
SET points = points - (@total-@cash)
WHERE username = @customername
UPDATE Orders
SET giftcard_code_used = @giftcardused
WHERE order_no = @orderID
END
END
IF(@cash IS NULL OR  @cash = 0)
BEGIN
UPDATE Orders
SET credit_amount = @credit,payment_type = 'credit'
WHERE order_no = @orderID AND
customer_name= @customername 
IF(@total > @credit)
BEGIN
SELECT @giftcardused = A.code
FROM Admin_Customer_Giftcard A INNER JOIN Giftcard G ON A.code = G.code
WHERE Customer_name = @customername AND G.expiry_date > CURRENT_TIMESTAMP
UPDATE Admin_Customer_Giftcard
SET remaining_points = remaining_points - (@total-@credit)
WHERE Customer_name = @customername
UPDATE Customer
SET points = points - (@total-@credit)
WHERE username = @customername
UPDATE Orders
SET giftcard_code_used = @giftcardused
WHERE order_no = @orderID
END
END
GO

EXEC specifyAmount  'ammar.yasser',1,50,0
GO

CREATE PROC AddCreditCard
@creditcardnumber varchar(20), 
@expirydate date , 
@cvv varchar(4), 
@customername varchar(20)
AS
INSERT INTO Credit_Card 
VALUES(@creditcardnumber,@expirydate,@cvv)
INSERT INTO Customer_Creditcard 
VALUES (@customername,@creditcardnumber)
GO

--EXEC AddCreditCard '4444-5555-6666-8888','10/19/2028',232,'ammar.yasser'


CREATE PROC ChooseCreditCard
@creditcard varchar(20),
@orderID int
AS
Update Orders
Set creditCard_number = @creditcard
where order_no= @orderID
GO
--EXEC ChooseCreditCard '4444-5555-6666-8888',1

CREATE PROC vewDeliveryTypes
AS
SELECT type,time_duration,fees
FROM delivery
GO
DROP PROC vewDeliveryTypes

EXEC viewDeliveryTypes
GO
CREATE PROC viewDeliveryTypes
AS
SELECT type,time_duration,fees
FROM delivery
GO
DROP PROC viewDeliveryTypes
GO

CREATE PROC specifydeliverytype
@orderID INT,
@deliveryID INT
AS
DECLARE @days INT
SELECT @days = time_duration
FROM Delivery
WHERE id = @deliveryID
UPDATE Orders
SET delivery_id = @deliveryID,remaining_days = @days
WHERE order_no = @orderID
GO
--EXEC specifydeliverytype 1,2

CREATE PROC trackRemainingDays
@orderid INT,
@customername VARCHAR(20),
@days INT OUTPUT
AS
SELECT @days = remaining_days
FROM Orders
WHERE order_no = @orderid AND customer_name = @customername
GO
--DECLARE @days INT
--EXEC trackRemainingDays 1,'ahmed.ashraf',@days OUTPUT
--PRINT @days

CREATE PROC recommmend
@customername varchar(20)
AS
Declare @max int
Declare @category1 varchar(20)
Declare @category2 varchar(20)
Declare @category3 varchar(20)
Declare @product1 INT
Declare @product2 INT
Declare @product3 INT
Declare @product4 INT
Declare @product5 INT
Declare @product6 INT
select  category,count(*)  as Occurances INTO test1 
from Product P inner join CustomerAddsToCartProduct C on p.serial_no = c.serial_no
where C.customer_name = @customername
group by category
order by count(*) desc
SELECT @max= MAX(Occurances)
FROM test1
select @category1 = category from test1 where Occurances = @max
Delete from test1 where Occurances = @max
SELECT @max= MAX(Occurances)
FROM test1
select @category2 = category from test1 where Occurances = @max
Delete from test1 where Occurances = @max
SELECT @max= MAX(Occurances)
FROM test1
select @category3 = category from test1 where Occurances = @max
Delete from test1 where Occurances = @max
drop table test1
select p.serial_no, count(*) as Occurances INTO test2
from Wishlist_Product W inner Join Product P on w.serial_no = p.serial_no where category = @category1
group by p.serial_no
order by count(*) desc
SELECT @max= MAX(Occurances)
FROM test2
select @product1 = serial_no from test2 where Occurances = @max
Delete from test2 where Occurances = @max
drop table test2
select p.serial_no, count(*) as Occurances INTO test2
from Wishlist_Product W inner Join Product P on w.serial_no = p.serial_no where category = @category2
group by p.serial_no
order by count(*) desc
SELECT @max= MAX(Occurances)
FROM test2
select @product2 = serial_no from test2 where Occurances = @max
Delete from test2 where Occurances = @max
drop table test2
select p.serial_no, count(*) as Occurances INTO test2
from Wishlist_Product W inner Join Product P on w.serial_no = p.serial_no where category = @category3
group by p.serial_no
order by count(*) desc
SELECT @max= MAX(Occurances)
FROM test2
select @product3 = serial_no from test2 where Occurances = @max
Delete from test2 where Occurances = @max
drop table test2
SELECT serial_no, count(*) as Occurances into test3
FROM Wishlist_Product
WHERE username IN (SELECT DISTINCT C2.customer_name
FROM CustomerAddsToCartProduct C1 INNER JOIN CustomerAddsToCartProduct C2 ON C1.serial_no = C2.serial_no
WHERE C1.customer_name = @customername AND C2.customer_name <> @customername)
group by serial_no
order by count(*) desc
SELECT @max= MAX(Occurances)
FROM test3
select @product4 = serial_no from test3 where Occurances = @max
Delete from test3 where Occurances = @max
SELECT @max= MAX(Occurances)
FROM test3
select @product5 = serial_no from test3 where Occurances = @max
Delete from test3 where Occurances = @max
SELECT @max= MAX(Occurances)
FROM test3
select @product6 = serial_no from test3 where Occurances = @max
Delete from test3 where Occurances = @max
drop table test3
select * from Product where serial_no = @product1 or
serial_no = @product2 or
serial_no = @product3 or
serial_no = @product4 or
serial_no = @product5 or
serial_no = @product6
GO


