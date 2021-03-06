USE projectDB
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
if @payedinpoints > 0
BEGIN
 Update Product
 SET available = 1,
customer_username = NULL,
customer_order_id = NULL
 where serial_no = @serialno
 SELECT @returnvalue = final_price from Product
 where serial_no = @serialno
 SELECT @customername = customer_name from Orders
 where order_no = @orderid
 if @returnvalue >= @payedinpoints AND @expiry > CURRENT_TIMESTAMP
 BEGIN
 UPDATE Customer
 SET points = points + @payedinpoints
 where username = @customername
 END
 if @returnvalue < @payedinpoints AND @expiry > CURRENT_TIMESTAMP
 BEGIN
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


--vendor start

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

CREATE PROC viewQuestions
@vendorname varchar(20)
AS
SELECT question
FROM Customer_Question_Product CQP INNER JOIN Product P ON CQP.serial_no = P.serial_no
WHERE P.vendor_username = @vendorname
GO

CREATE PROC answerQuestions
@vendorcheck varchar(20),
@serialno int,
@customername varchar(20),
@answer text
AS
DECLARE @vendorcheck VARCHAR(20)
SELECT @vendorcheck = vendor_username
from Product
where serial_no = @serialno
IF (@vendorcheck = @vendorcheck)
BEGIN
UPDATE Customer_Question_Product
set answer = @answer
WHERE serial_no = @serialno AND customer_name = @customername
End
GO

CREATE PROC addOffer
@offeramount INT,
@expiry_date  DATETIME
AS
INSERT INTO offer (offer_amount, expiry_date)
VALUES(@offeramount,@expiry_date)
GO

CREATE PROC checkOfferonProduct
@serial int,
@activeoffer bit OUTPUT-- what does this depend on
AS
IF (EXISTS(SELECT *
FROM OffersOnProduct
WHERE serial_no = @serial))
SET @activeoffer = 1
ELSE
SET @activeoffer = 0
GO

CREATE PROC checkandremoveExpiredoffer
@offerid int
AS
-- Delete rows from table ''
DELETE
FROM offer
WHERE offer_id = @offerid AND expiry_date < CURRENT_TIMESTAMP
GO

CREATE PROC applyOffer
@vendorname varchar(20),
@offerid int,
@serial int
AS
DECLARE @offeronhand INT
DECLARE @validvendor BIT
select @offeronhand = offer_amount from Offer where offer_id = @offerid
UPDATE Product
SET final_price = price - (price*@offeronhand/100),
@validvendor = 1
WHERE
serial_no = @serial and vendor_username = @vendorname
IF @validvendor = 1
insert into offersOnProduct VALUES(@offerid, @serial)

--Start of Admin
GO
CREATE PROC activateVendors
@admin_username varchar(20),
@vendor_username varchar(20)
AS
Update Vendor
Set activated = 1,
admin_username=@admin_username
where username = @vendor_username AND activated = 0
GO
--EXEC activateVendors 'hana.aly','eslam.mahmoud'

CREATE PROC inviteDeliveryPerson
@delivery_username varchar(20),
@delivery_email varchar(50)
AS
INSERT INTO Users(username,email)
VALUES(@delivery_username,@delivery_email)
INSERT INTO Delivery_Person VALUES (@delivery_username, 0)
GO

--EXEC inviteDeliveryPerson 'mohamed.tamer','???moha@gmail.com'
CREATE PROC reviewOrder
AS
select * 
from Orders
Go

CREATE PROC updateOrderStatusInProcess
@order_no INT
AS
Update Orders
set order_status = 'in process'
GO
--EXEC updateOrderStatusInProcess 1


CREATE PROC addDelivery
@delivery_type varchar(20),
@time_duration int,
@fees decimal(5,3),
@admin_username varchar(20)
AS
insert into Delivery 
values (@delivery_type,@time_duration,@fees,@admin_username)
GO
--EXEC addDelivery 'pick-up',7,10,'hana.aly'

CREATE PROC assignOrdertoDelivery
@delivery_username VARCHAR(20),
@order_no INT, --Admin_Delivery_Order(delivery_username, order_no, admin_username, delivery_window)
@admin_username varchar(20)
AS
INSERT INTO Admin_Delivery_Order (delivery_username, order_no, admin_username)
Values(@delivery_username,@order_no,@admin_username)
GO

--EXEC assignOrdertoDelivery 'mohamed.tamer',1,'hana.aly'

CREATE PROC createTodaysDeal
 @deal_amount int,
 @admin_username varchar(20),
 @expiry_date datetime
 AS
 INSERT INTO Todays_Deals VALUES (@deal_amount,@expiry_date,@admin_username)
 Go

 --EXEC createTodaysDeal 30,'hana.aly','2019/11/30'

 CREATE PROC checkTodaysDealOnProduct
 @serial_no INT,
 @activeDeal BIT output
 AS
 IF EXISTS (select * from Todays_Deals_Product where serial_no = @serial_no)
 SET @activeDeal = 1
 ELSE
 SET  @activeDeal = 0
 GO
--DECLARE @deal BIT
 --EXEC checkTodaysDealOnProduct 3,@deal OUTPUT
 --PRINT @deal


 CREATE PROC addTodaysDealOnProduct
 @deal_id int,
 @serial_no int
 AS
 DECLARE @activeDeal BIT
 EXEC checkTodaysDealOnProduct  @serial_no,@activeDeal OUTPUT
 IF(@activeDeal = 0)
 BEGIN
 Declare @offeronhand decimal(10,2)
 select @offeronhand = deal_amount from Todays_Deals where deal_id = @deal_id
UPDATE Product
SET final_price = price - @offeronhand
WHERE
serial_no = @serial_no
INSERT INTO Todays_Deals_Product values (@deal_id,@serial_no)
END
GO
--DROP PROC addTodaysDealOnProduct
--EXEC addTodaysDealOnProduct 5,1

--TRUNCATE Table Todays_Deals_Product



 CREATE PROC removeExpiredDeal
 @deal_iD INT
 AS
 DECLARE @expiry DATE
 SELECT @expiry = expiry_date
 FROM Todays_Deals
 WHERE deal_id = @deal_iD
 IF(@expiry < CURRENT_TIMESTAMP)
 BEGIN
 DELETE from Todays_Deals 
 where deal_id = @deal_iD
 END
 GO

 CREATE PROC createGiftCard
 @code varchar(10),
 @expiry_date DATE,
 @amount int,
 @admin_username varchar(20)
 AS
 INSERT INTO Giftcard VALUES(@code, @expiry_date, @amount, @admin_username)
GO
EXEC createGiftCard 'G102' , '2019/10/30' , 100, 'hana.aly'

GO
CREATE PROC removeExpiredGiftCard
@code varchar(10)
AS
DECLARE @customer VARCHAR(20)
DECLARE @points INT
DECLARE @expiry DATE
SELECT  @expiry = expiry_date 
FROM Giftcard
WHERE code = @code
SELECT @customer = Customer_name
FROM Admin_Customer_Giftcard
WHERE code = @code
IF(@expiry< CURRENT_TIMESTAMP)
BEGIN
SELECT @points = remaining_points
FROM Admin_Customer_Giftcard
WHERE code = @code
DELETE FROM Admin_Customer_Giftcard
WHERE  code = @code
DELETE FROM Giftcard 
WHERE code = @code
UPDATE Customer
SET points = points - @points 
WHERE username = @customer
END
GO
--DROP PROC removeExpiredGiftCard
--EXEC removeExpiredGiftCard 'G102'

GO
CREATE PROC checkGiftCardOnCustomer
@code varchar(10),
@activeGiftCard BIT Output
AS
IF (EXISTS(SELECT * FROM Admin_Customer_Giftcard 
where code = @code))
SET @activeGiftCard = '1'
else
SET @activeGiftCard = '0'
GO
DROP PROC checkGiftCardOnCustomer
DECLARE @active BIT
EXEC checkGiftCardOnCustomer 'G101',@active OUTPUT
PRINT @active

GO
Create proc giveGiftCardtoCustomer
@code varchar(10),
@customer_name varchar(20),
@admin_username varchar(20)
AS
DECLARE @giftamount INT
DECLARE @expiry DATE 
SELECT @expiry = expiry_date 
FROM Giftcard
WHERE code = @code
Select @giftamount = amount from Giftcard where code = @code
Insert into Admin_Customer_Giftcard
values (@code, @customer_name, @admin_username, @giftamount)
--IF(@expiry > CURRENT_TIMESTAMP)
--BEGIN
UPDATE customer 
SET points = points + @giftamount
WHERE username = @customer_name
--END
GO
DROP PROC giveGiftCardtoCustomer
EXEC giveGiftCardtoCustomer 'G101','ammar.yasser','hana.aly'
--DELETE FROM Admin_Customer_Giftcard
--WHERE code =  'G101'

--End of Admin

--Start of delivery personnel
GO
CREATE PROC acceptAdminInvitation
@delivery_username varchar(20)
AS
UPDATE Delivery_Person
SET is_activated = 1
where username = @delivery_username

GO

CREATE PROC deliveryPersonUpdateInfo
@username varchar(20),
@first_name varchar(20),
@last_name varchar(20),
@password varchar(20),
@email varchar(50)
AS
UPDATE Users
SET password = @password,
first_name= @first_name,
last_name = @last_name,
email= @email
where username=@username


GO

CREATE PROC specifyDeliveryWindow
@delivery_username varchar(20),
@order_no int,
@delivery_window varchar(50)
AS
UPDATE Admin_Delivery_Order
SET delivery_window = @delivery_window
WHERE delivery_username= @delivery_username and order_no = @order_no


GO

CREATE PROC updateOrderStatusOutforDelivery
@order_no int
AS
UPDATE Orders
SET order_status = 'out for delivery'
WHERE order_no= @order_no


GO

CREATE PROC updateOrderStatusDelivered
@order_no int
AS
UPDATE Orders
SET order_status = 'delivered'
WHERE order_no= @order_no

--END of delivery personnel

CREATE Database project3