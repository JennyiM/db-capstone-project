USE littlelemondb;
/*Exercise: Create a virtual table to summarize data*/
/*
Task 1
In the first task, 
Little Lemon need you to create a virtual table called OrdersView that focuses on OrderID, Quantity and Cost columns within the Orders table 
for all orders with a quantity greater than 2. 
*/
CREATE VIEW OrdersView AS 
SELECT OrderID, Quantity,TotalCost 
from Orders
WHERE Quantity > 2;
Select * from OrdersView;

/*
Task 2
For your second task, 
Little Lemon need information from four tables on all customers with orders that cost more than $150. 
Extract the required information from each of the following tables by using the relevant JOIN clause
Customers table: The customer id and full name.
Orders table: The order id and cost.
Menus table: The menus name.
MenusItems table: course name and starter name.
*/
SELECT c.CustomerID, concat(c.FirstName,' ',c.LastName) as FullName, o.OrderID, o.TotalCost, m.MenuName, mi.CourseName, mi.StarterName
from customers c
join orders o on c.CustomerID = o.CustomerID 
join menus m on o.MenuID = m.MenuID
join menuitems mi on m.ItemID = mi.ItemID
WHERE o.TotalCost > 150;

/*
Task 3
For the third and final task, Little Lemon need you to find all menu items for which more than 2 orders have been placed. 
You can carry out this task by creating a subquery that lists the menu names from the menus table for any order quantity with more than 2.
Here’s some guidance around completing this task: 
Use the ANY operator in a subquery
The outer query should be used to select the menu name from the menus table.
The inner query should check if any item quantity in the order table is more than 2. 
*/
SELECT MenuName
FROM menus
where MenuID = any (SELECT MenuID from orders group by MenuID having sum(quantity)>2);

/*Exercise: Create optimized queries to manage and analyze data*/
/*
Task 1
In this first task, Little Lemon need you to create a procedure that displays the maximum ordered quantity in the Orders table. 
Creating this procedure will allow Little Lemon to reuse the logic implemented in the procedure easily without retyping the same code over again and again to check the maximum quantity. 
*/
DELIMITER //

CREATE procedure GetMaxQuantity()
begin
	select max(Quantity) as MaximumOrderedQuantity from orders;
end //

DELIMITER ;
call GetMaxQuantity();

/*
Task 2
In the second task, Little Lemon need you to help them to create a prepared statement called GetOrderDetail. 
This prepared statement will help to reduce the parsing time of queries. It will also help to secure the database from SQL injections.
The prepared statement should accept one input argument, the CustomerID value, from a variable. 
The statement should return the order id, the quantity and the order cost from the Orders table. 
Once you create the prepared statement, you can create a variable called id and assign it value of 1. 
*/
prepare GetOrderDetail from
'SELECT OrderID, Quantity, TotalCost
From Orders
Where CustomerID = ?';

SET @id = 110;
EXECUTE GetOrderDetail using @id;

/*
Task 3
Your third and final task is to create a stored procedure called CancelOrder. 
Little Lemon want to use this stored procedure to delete an order record based on the user input of the order id.
Creating this procedure will allow Little Lemon to cancel any order by specifying the order id value in the procedure parameter without typing the entire SQL delete statement.
*/
DELIMITER //
create procedure CancelOrder(IN input_order_id INT)
begin
	DELETE FROM orders where OrderID = input_order_id;
    SELECT concat('Order ', input_order_id,' is cancelled') as Confirmation;
end //
DELIMITER ;
CALL CancelOrder(1191);
