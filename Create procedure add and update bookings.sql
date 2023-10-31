/*
Exercise: Create SQL queries to add and update bookings
*/
/*
Task 1
In this first task you need to create a new procedure called AddBooking to add a new table booking record.
The procedure should include four input parameters in the form of the following bookings parameters:
booking id, 
customer id, 
booking date,
and table number.
*/
DELIMITER //
CREATE PROCEDURE AddBooking(in booking_id int, in customer_id int, in booking_date date, in table_number int)
begin
	insert into customers values(customer_id,'Null','Nul','Null');
	INSERT INTO bookings VALUES (booking_id, customer_id,'null','null',0,table_number,concat(booking_date,' 19:00:00'),1);
	SELECT CONCAT('New booking added') AS Confirmation;
end //
DELIMITER ;
call AddBooking(9,3,'2022-12-30',4);
/*
Task 2
For your second task, Little Lemon need you to create a new procedure called UpdateBooking that they can use to update existing bookings in the booking table.
The procedure should have two input parameters in the form of booking id and booking date. You must also include an UPDATE statement inside the procedure. 
*/
DELIMITER //
CREATE PROCEDURE UpdateBooking(in booking_id int, in booking_date date)
begin
	update bookings
    set TimeSlot=concat(booking_date,' ',time(TimeSlot))
    where BookingID=booking_id;
    SELECT CONCAT('Booking ',booking_id,' updated') AS Confirmation;
end //
DELIMITER ;
call UpdateBooking(9,'2022-12-17');

/*
Task 3
For the third and final task, Little Lemon need you to create a new procedure called CancelBooking that they can use to cancel or remove a booking.
The procedure should have one input parameter in the form of booking id. You must also write a DELETE statement inside the procedure. 
*/
DELIMITER //
CREATE PROCEDURE DeleteBooking(in booking_id int)
begin
	delete from bookings
    where BookingID=booking_id;
    SELECT CONCAT('Booking ',booking_id,' cancelled') AS Confirmation;
end //
DELIMITER ;
