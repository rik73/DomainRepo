--example 1
create procedure uspDisplayMessage
as
begin
print 'Welcome to .Net React Session!...'
end
execute uspDisplayMessage
/*(or)
exec uspDisplayMessage
(or)
uspDisplayMessage*/

--example 2
select * from production.products

create proc uspProductList
as
begin
select Product_name,list_price from production.products
order by product_name
end

drop procedure uspProductList

exec uspProductList

sp_help uspProductList

use BikeStores;
go
exec sp_databases;
--alter procedure
--create proc uspProductList
alter proc uspProductList
as
begin
select Product_name,model_year,list_price from production.products order by list_price desc
end

uspProductList

exec sp_rename 'uspProductList','uspMyProductList'
--parameter in stored procedure
--input,output parameter
create proc uspFindProducts(@modelyear as int)
as
begin
select * from production.products where model_year=@modelyear
end
uspFindProducts 2019

--multiple parameter
CREATE PROC uspFindProductsbyRange (@minPrice decimal, @maxPrice decimal)
AS
BEGIN
SELECT * from production.products where
list_price>=@minPrice AND  list_price<=@maxPrice
END;

uspFindProductsbyRange 100,3000

--using named Parameter
uspFindProductsbyRange
@maxPrice=12000,
@minPrice=5000

--optional parameter
create proc uspFindProductsByName
(@minPrice as decimal=2000,@maxPrice decimal,@name as varchar(max))
as
begin
select * from production.products where list_price>=@minPrice and list_price<=@maxPrice
and
product_name like '%'+@name+'%'
end

uspFindProductsByName 100,1000,'Sun'
--uspFindProductsByName @maxPrice=3000,@name='trek'

CREATE PROCEDURE uspFindProductCountByModelYear (@modelyear int, @productCount int OUTPUT)
AS
BEGIN
select Product_name, list_Price from production.products
WHERE
model_year=@modelyear
select @productCount=@@ROWCOUNT
END

DECLARE @count int;
EXEC uspFindProductCountByModelYear @modelyear=2016, @productCount=@count OUT;;
select @count as 'Number of Products Found';

--can one stored procedure call another stored procedure

CREATE PROC usp_GetAllCustomers
AS
BEGIN
select *
from sales.customers
END

--sp_rename 'usp_GetAllCunstomers', 'usp_GetAllCustomers'

usp_GetAllCustomers

CREATE PROC usp_GetCustomerOrders
@customerId INT
AS
BEGIN
SELECT * FROM sales.orders
WHERE
customer_id=@customerId
END

usp_GetCustomerOrders 1


ALTER PROC usp_GetCustomerData (@cusomterId INT)
AS
BEGIN
EXEC usp_GetAllCustomers;
EXEC usp_GetCustomerOrders @cusomterId;
END

exec usp_GetCustomerData 1


/*You need to create a stored procedure that retrieves a list of all customers who have purchased a specific product.
consider below tables Customers, Orders,Order_items and Products
Create a stored procedure,it should return a list of all customers who have purchased the specified product, 
including customer details like CustomerID, CustomerName, and PurchaseDate.
The procedure should take a ProductID as an input parameter.
*/
create procedure GetCustomersByProducts @product_id int
as
begin
select C.customer_id,C.first_name,C.last_name,O.order_date as purchasedate
from sales.customers c 
inner join  sales.orders O on C.customer_id=O.customer_id
inner join sales.order_items OI on O.order_id=OI.order_id
where OI.product_id=@product_id
end
exec GetCustomersByProducts @product_id=69