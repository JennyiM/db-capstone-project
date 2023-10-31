/*
Task 1
Little Lemon wants to populate the Bookings table of their database with some records of data. 
Your first task is to replicate the list of records in the following table by adding them to the Little Lemon booking table. 
*/
insert into customers values
(1,'Byron','Bass','218-891-7423'),
(2,'Kyran','Mayo','547-879-1535'),
(3,'Tess','Kramer','215-568-3249');
insert into bookings values
(1,1,'Byron','Bass',3,5,'2022-10-10 18:00:00',1),
(2,3,'Kyran','Mayo',2,3,'2022-11-12 18:30:00',2),
(3,2,'Tess','Kramer',2,2,'2022-10-11 19:00:00',3),
(4,1,'Byron','Bass',4,2,'2022-10-13 19:30:00',4);
/*
Task 2
For your second task, Little Lemon need you to create a stored procedure called ManageBooking to Manage whether a table in the restaurant is already booked. 
Creating this procedure helps to minimize the effort involved in repeatedly coding the same SQL statements.
The procedure should have two input parameters in the form of booking date and table number. 
You can also create a variable in the procedure to Manage the status of each table.
*/
DELIMITER //
create procedure ManageBooking(in booking_date Date, in table_number INT)
BEGIN
	DECLARE Booking_Status VARCHAR(255);
    SELECT 
		CASE 
			WHEN COUNT(*)>0 THEN CONCAT('Table ', table_number,' is already booked' )
            ELSE CONCAT('Table ',table_number, ' is available')
		END INTO Booking_Status
	FROM bookings
    where date(TimeSlot)=booking_date and TableID=table_number;
    SELECT Booking_Status as 'Booking Status';
END //
DELIMITER ;
CALL ManageBooking("2022-11-12",3);

/*
Task 3
For your third and final task, Little Lemon need to verify a booking, and decline any reservations for tables that are already booked under another name. 
Since integrity is not optional, Little Lemon need to ensure that every booking attempt includes these verification and decline steps. 
However, implementing these steps requires a stored procedure and a transaction. 
To implement these steps, you need to create a new procedure called AddValidBooking. 
This procedure must use a transaction statement to perform a rollback if a customer reserves a table that’s already booked under another name.  
Use the following guidelines to complete this task:
The procedure should include two input parameters in the form of booking date and table number.
It also requires at least one variable and should begin with a START TRANSACTION statement.
Your INSERT statement must add a new booking record using the input parameter's values.
Use an IF ELSE statement to Manage if a table is already booked on the given date. 
If the table is already booked, then rollback the transaction. If the table is available, then commit the transaction.
*/
DELIMITER //
create procedure AddValidBooking(IN booking_date date, IN table_number int, IN customer_id int)
begin
	declare booking_count INT;
    START transaction;
    select count(*) into booking_count
    from bookings
    where date(TimeSlot) = booking_date and TableID = table_number;
    
    if booking_count > 0 then
		rollback;
        select concat('Table ', table_number, ' is already booked on ', booking_date) as 'Booking Status';
    else
		insert into customers values(customer_id,'Null','Nul','Null');
        INSERT INTO bookings VALUES (0, customer_id,'null','null',0,table_number,concat(booking_date,' 19:00:00'),1);
        commit;
        SELECT CONCAT('Table ', table_number, ' booked successfully for ', customer_id, ' on ', booking_date) AS 'Booking status';
    END IF;
end //
DELIMITER ;
call AddValidBooking('2022-12-17',5,10);