-- CS4400: Introduction to Database Systems (Spring 2024)
-- Phase III: Stored Procedures & Views [v1] Wednesday, March 27, 2024 @ 5:20pm EST

-- Team 8
-- Rama Khabbaz (rkhabbaz3)
-- Amena Hussain (ahussain67)
-- Pennon Shue (pshue3)
-- Ved Rao (vrao89)

-- Directions:
-- Please follow all instructions for Phase III as listed on Canvas.
-- Fill in the team number and names and GT usernames for all members above.
-- Create Table statements must be manually written, not taken from an SQL Dump file.
-- This file must run without error for credit.

/* This is a standard preamble for most of our scripts.  The intent is to establish
a consistent environment for the database behavior. */
set global transaction isolation level serializable;
set global SQL_MODE = 'ANSI,TRADITIONAL';
set names utf8mb4;
set SQL_SAFE_UPDATES = 0;

set @thisDatabase = 'drone_dispatch';
drop database if exists drone_dispatch;
create database if not exists drone_dispatch;
use drone_dispatch;

-- -----------------------------------------------
-- table structures
-- -----------------------------------------------

create table users (
uname varchar(40) not null,
first_name varchar(100) not null,
last_name varchar(100) not null,
address varchar(500) not null,
birthdate date default null,
primary key (uname)
) engine = innodb;

create table customers (
uname varchar(40) not null,
rating integer not null,
credit integer not null,
primary key (uname)
) engine = innodb;

create table employees (
uname varchar(40) not null,
taxID varchar(40) not null,
service integer not null,
salary integer not null,
primary key (uname),
unique key (taxID)
) engine = innodb;

create table drone_pilots (
uname varchar(40) not null,
licenseID varchar(40) not null,
experience integer not null,
primary key (uname),
unique key (licenseID)
) engine = innodb;

create table store_workers (
uname varchar(40) not null,
primary key (uname)
) engine = innodb;

create table products (
barcode varchar(40) not null,
pname varchar(100) not null,
weight integer not null,
primary key (barcode)
) engine = innodb;

create table orders (
orderID varchar(40) not null,
sold_on date not null,
purchased_by varchar(40) not null,
carrier_store varchar(40) not null,
carrier_tag integer not null,
primary key (orderID)
) engine = innodb;

create table stores (
storeID varchar(40) not null,
sname varchar(100) not null,
revenue integer not null,
manager varchar(40) not null,
primary key (storeID)
) engine = innodb;

create table drones (
storeID varchar(40) not null,
droneTag integer not null,
capacity integer not null,
remaining_trips integer not null,
pilot varchar(40) not null,
primary key (storeID, droneTag)
) engine = innodb;

create table order_lines (
orderID varchar(40) not null,
barcode varchar(40) not null,
price integer not null,
quantity integer not null,
primary key (orderID, barcode)
) engine = innodb;

create table employed_workers (
storeID varchar(40) not null,
uname varchar(40) not null,
primary key (storeID, uname)
) engine = innodb;

-- -----------------------------------------------
-- referential structures
-- -----------------------------------------------

alter table customers add constraint fk1 foreign key (uname) references users (uname)
	on update cascade on delete cascade;
alter table employees add constraint fk2 foreign key (uname) references users (uname)
	on update cascade on delete cascade;
alter table drone_pilots add constraint fk3 foreign key (uname) references employees (uname)
	on update cascade on delete cascade;
alter table store_workers add constraint fk4 foreign key (uname) references employees (uname)
	on update cascade on delete cascade;
alter table orders add constraint fk8 foreign key (purchased_by) references customers (uname)
	on update cascade on delete cascade;
alter table orders add constraint fk9 foreign key (carrier_store, carrier_tag) references drones (storeID, droneTag)
	on update cascade on delete cascade;
alter table stores add constraint fk11 foreign key (manager) references store_workers (uname)
	on update cascade on delete cascade;
alter table drones add constraint fk5 foreign key (storeID) references stores (storeID)
	on update cascade on delete cascade;
alter table drones add constraint fk10 foreign key (pilot) references drone_pilots (uname)
	on update cascade on delete cascade;
alter table order_lines add constraint fk6 foreign key (orderID) references orders (orderID)
	on update cascade on delete cascade;
alter table order_lines add constraint fk7 foreign key (barcode) references products (barcode)
	on update cascade on delete cascade;
alter table employed_workers add constraint fk12 foreign key (storeID) references stores (storeID)
	on update cascade on delete cascade;
alter table employed_workers add constraint fk13 foreign key (uname) references store_workers (uname)
	on update cascade on delete cascade;

-- -----------------------------------------------
-- table data
-- -----------------------------------------------

insert into users values
('jstone5', 'Jared', 'Stone', '101 Five Finger Way', '1961-01-06'),
('sprince6', 'Sarah', 'Prince', '22 Peachtree Street', '1968-06-15'),
('awilson5', 'Aaron', 'Wilson', '220 Peachtree Street', '1963-11-11'),
('lrodriguez5', 'Lina', 'Rodriguez', '360 Corkscrew Circle', '1975-04-02'),
('tmccall5', 'Trey', 'McCall', '360 Corkscrew Circle', '1973-03-19'),
('eross10', 'Erica', 'Ross', '22 Peachtree Street', '1975-04-02'),
('hstark16', 'Harmon', 'Stark', '53 Tanker Top Lane', '1971-10-27'),
('echarles19', 'Ella', 'Charles', '22 Peachtree Street', '1974-05-06'),
('csoares8', 'Claire', 'Soares', '706 Living Stone Way', '1965-09-03'),
('agarcia7', 'Alejandro', 'Garcia', '710 Living Water Drive', '1966-10-29'),
('bsummers4', 'Brie', 'Summers', '5105 Dragon Star Circle', '1976-02-09'),
('cjordan5', 'Clark', 'Jordan', '77 Infinite Stars Road', '1966-06-05'),
('fprefontaine6', 'Ford', 'Prefontaine', '10 Hitch Hikers Lane', '1961-01-28');

insert into customers values
('jstone5', 4, 40),
('sprince6', 5, 30),
('awilson5', 2, 100),
('lrodriguez5', 4, 60),
('bsummers4', 3, 110),
('cjordan5', 3, 50);

insert into employees values
('awilson5', '111-11-1111', 9, 46000),
('lrodriguez5', '222-22-2222', 20, 58000),
('tmccall5', '333-33-3333', 29, 33000),
('eross10', '444-44-4444', 10, 61000),
('hstark16', '555-55-5555', 20, 59000),
('echarles19', '777-77-7777', 3, 27000),
('csoares8', '888-88-8888', 26, 57000),
('agarcia7', '999-99-9999', 24, 41000),
('bsummers4', '000-00-0000', 17, 35000),
('fprefontaine6', '121-21-2121', 5, 20000);

insert into store_workers values
('eross10'),
('hstark16'),
('echarles19');

insert into stores values
('pub', 'Publix', 200, 'hstark16'),
('krg', 'Kroger', 300, 'echarles19');

insert into employed_workers values
('pub', 'eross10'),
('pub', 'hstark16'),
('krg', 'eross10'),
('krg', 'echarles19');

insert into drone_pilots values
('awilson5', '314159', 41),
('lrodriguez5', '287182', 67),
('tmccall5', '181633', 10),
('agarcia7', '610623', 38),
('bsummers4', '411911', 35),
('fprefontaine6', '657483', 2);

insert into drones values
('pub', 1, 10, 3, 'awilson5'),
('pub', 2, 20, 2, 'lrodriguez5'),
('krg', 1, 15, 4, 'tmccall5'),
('pub', 9, 45, 1, 'fprefontaine6');

insert into products values
('pr_3C6A9R', 'pot roast', 6),
('ss_2D4E6L', 'shrimp salad', 3),
('hs_5E7L23M', 'hoagie sandwich', 3),
('clc_4T9U25X', 'chocolate lava cake', 5),
('ap_9T25E36L', 'antipasto platter', 4);

insert into orders values
('pub_303', '2024-05-23', 'sprince6', 'pub', 1),
('pub_305', '2024-05-22', 'sprince6', 'pub', 2),
('krg_217', '2024-05-23', 'jstone5', 'krg', 1),
('pub_306', '2024-05-22', 'awilson5', 'pub', 2);

insert into order_lines values
('pub_303', 'pr_3C6A9R', 20, 1),
('pub_303', 'ap_9T25E36L', 4, 1),
('pub_305', 'clc_4T9U25X', 3, 2),
('pub_306', 'hs_5E7L23M', 3, 2),
('pub_306', 'ap_9T25E36L', 10, 1),
('krg_217', 'pr_3C6A9R', 15, 2);

-- -----------------------------------------------
-- stored procedures and views
-- -----------------------------------------------

-- AMENA
-- add customer
delimiter // 
create procedure add_customer
	(in ip_uname varchar(40), in ip_first_name varchar(100),
	in ip_last_name varchar(100), in ip_address varchar(500),
    in ip_birthdate date, in ip_rating integer, in ip_credit integer)
sp_main: begin
	DECLARE uname_exists INT;
	IF ip_uname IS NULL THEN
		LEAVE sp_main;
	END IF;
    
    IF ip_first_name IS NULL THEN
		LEAVE sp_main;
	END IF;
    
    IF ip_last_name IS NULL THEN
		LEAVE sp_main;
	END IF;
    
    IF ip_address IS NULL THEN
		LEAVE sp_main;
	END IF;
    
    if ip_rating is null or ip_rating < 1 or ip_rating > 5 then
		leave sp_main; end if;
        
	if ip_credit is null or ip_credit < 0 then
		leave sp_main; end if;
	
    SELECT COUNT(*) INTO uname_exists FROM users WHERE uname = ip_uname;
    
    IF uname_exists > 0 THEN
		LEAVE sp_main;
	END IF;
    
	INSERT INTO users(uname, first_name, last_name, address, birthdate) VALUES (ip_uname, ip_first_name, ip_last_name, ip_address, ip_birthdate);		
    INSERT INTO customers(uname, rating, credit) VALUES (ip_uname, ip_rating, ip_credit);
end //
delimiter ;

-- AMENA
-- add drone pilot
delimiter // 
create procedure add_drone_pilot
	(in ip_uname varchar(40), in ip_first_name varchar(100),
	in ip_last_name varchar(100), in ip_address varchar(500),
    in ip_birthdate date, in ip_taxID varchar(40), in ip_service integer, 
    in ip_salary integer, in ip_licenseID varchar(40),
    in ip_experience integer)
sp_main: begin
	DECLARE uname_exists INT;
    DECLARE taxID_exists INT;
    DECLARE license_exists INT;
    
    if ip_uname is null or ip_first_name is null or ip_last_name is null or ip_address is null or ip_taxID is null
    or ip_service is null or ip_salary is null or ip_licenseID is null or ip_experience is null or ip_experience < 0 
    or ip_service < 0 or ip_salary < 0 THEN
		LEAVE sp_main;
	end if;


    SELECT COUNT(*) INTO uname_exists FROM users WHERE uname = ip_uname;
    SELECT COUNT(*) INTO taxID_exists FROM employees WHERE taxID = ip_taxID;
    SELECT COUNT(*) INTO license_exists FROM drone_pilots WHERE licenseID = ip_licenseID;

	IF uname_exists > 0 THEN
		-- the case where the username is not unique
        LEAVE sp_main;
	END IF;
    
	IF taxID_exists > 0 THEN
        LEAVE sp_main;
	END IF;
    
	IF license_exists > 0 THEN
        LEAVE sp_main;
	END IF;

	INSERT INTO users(uname, first_name, last_name , address, birthdate) VALUES (ip_uname, ip_first_name, ip_last_name, ip_address, ip_birthdate);
	INSERT INTO employees(uname, taxID, service, salary) VALUES (ip_uname, ip_taxID, ip_service, ip_salary);
	INSERT INTO drone_pilots(uname, licenseID, experience) VALUES (ip_uname, ip_licenseID, ip_experience);
end //
delimiter ;

-- AMENA
-- add product
delimiter // 
create procedure add_product
	(in ip_barcode varchar(40), in ip_pname varchar(100),
    in ip_weight integer)
sp_main: begin
	-- place your solution here
    DECLARE barcode_exists INT;
    if ip_barcode is null or ip_pname is null or ip_weight is null or ip_weight < 0 THEN
		leave sp_main;
	end if; 
    
    SELECT COUNT(*) INTO barcode_exists FROM products WHERE barcode = ip_barcode;
    
    IF barcode_exists = 0 THEN
		INSERT INTO products(barcode, pname, weight) VALUES (ip_barcode, ip_pname, ip_weight);
	end if;
end //
delimiter ;

-- AMENA
-- add drone
delimiter // 
create procedure add_drone
	(in ip_storeID varchar(40), in ip_droneTag integer,
    in ip_capacity integer, in ip_remaining_trips integer,
    in ip_pilot varchar(40))
sp_main: begin
DECLARE valid_store INT;
    DECLARE tag_exists INT;
    DECLARE pilot_exists INT;
    DECLARE pilot_occupied INT;
    
    if ip_storeID is null or ip_droneTag is null or ip_capacity is null or ip_remaining_trips is null or ip_pilot is null 
    or ip_droneTag < 0 or ip_capacity < 0 or ip_remaining_trips < 0 THEN
		leave sp_main;
	end if; 
    

SELECT COUNT(*) INTO valid_store FROM stores WHERE storeID = ip_storeID;
SELECT COUNT(*) INTO tag_exists FROM drones WHERE droneTag = ip_droneTag AND storeID = ip_storeID;
SELECT COUNT(*) INTO pilot_exists FROM drone_pilots WHERE uname = ip_pilot;
SELECT COUNT(*) INTO pilot_occupied FROM drones WHERE pilot = ip_pilot;

    IF valid_store = 0 THEN
		LEAVE sp_main;
	END IF;
    
    IF tag_exists > 0 THEN
		LEAVE sp_main;
	END IF;
    
     IF pilot_exists = 0 THEN
		LEAVE sp_main;
	END IF;
    
      IF pilot_occupied > 0 THEN
		LEAVE sp_main;
	END IF;
    
	INSERT INTO drones(storeID, droneTag, capacity, remaining_trips, pilot) VALUES (ip_storeID, ip_droneTag, ip_capacity, ip_remaining_trips, ip_pilot);
end //
delimiter ;

-- AMENA
-- increase customer credits
delimiter // 
create procedure increase_customer_credits
	(in ip_uname varchar(40), in ip_money integer)
sp_main: begin
DECLARE initial_credit INT;

if ip_uname is null or ip_money is null THEN
	leave sp_main;
end if; 

if ip_uname not in (select uname from customers) THEN
	leave sp_main; 
end if; 

IF ip_money >= 0 THEN
	-- SELECT credit INTO initial_credit FROM customers WHERE uname = ip_uname;
    UPDATE customers SET credit = credit + ip_money WHERE uname = ip_uname;
END IF;	

end //
delimiter ;

-- swap drone control
delimiter // 
create procedure swap_drone_control
	(in ip_incoming_pilot varchar(40), in ip_outgoing_pilot varchar(40))
sp_main: begin
	DECLARE incoming_pilot_valid INT;
    DECLARE incoming_pilot_occupied INT;
    DECLARE outgoing_pilot_valid INT;
    DECLARE outgoing_pilot_occupied INT;
    
    if ip_incoming_pilot is null or ip_outgoing_pilot is null THEN
		leave sp_main;
	end if; 

    
    SELECT COUNT(*) INTO incoming_pilot_valid FROM drone_pilots WHERE uname = ip_incoming_pilot;
    SELECT COUNT(*) INTO incoming_pilot_occupied FROM drones WHERE pilot = ip_incoming_pilot;
    
    SELECT COUNT(*) INTO outgoing_pilot_valid FROM drone_pilots WHERE uname = ip_outgoing_pilot;
    SELECT COUNT(*) INTO outgoing_pilot_occupied FROM drones WHERE pilot = ip_outgoing_pilot;
    
    IF incoming_pilot_valid > 0 AND incoming_pilot_occupied = 0 AND outgoing_pilot_valid > 0 AND outgoing_pilot_occupied > 0 THEN
		UPDATE drones SET pilot = ip_incoming_pilot WHERE pilot = ip_outgoing_pilot; -- CHECK IF THIS IS RIGHT!!!
	END IF;
end //
delimiter ;

-- repair and refuel a drone
delimiter // 
create procedure repair_refuel_drone
	(in ip_drone_store varchar(40), in ip_drone_tag integer,
    in ip_refueled_trips integer)
sp_main: begin
	if (ip_drone_store is null or ip_drone_tag is null or ip_refueled_trips is null or ip_drone_tag < 0)
		then leave sp_main;
	end if;
	if (ip_refueled_trips >= 0 #store exists, and drone exists
		and exists (select droneTag from drones where ip_drone_tag = droneTag and ip_drone_store = storeID) 
        and exists (select storeID from stores where ip_drone_store = storeID))
        then
		update drones set remaining_trips = remaining_trips + ip_refueled_trips where storeID = ip_drone_store and droneTag = ip_drone_tag;
	end if;
end //
delimiter ;

-- begin order
delimiter // 
create procedure begin_order
	(in ip_orderID varchar(40), in ip_sold_on date,
    in ip_purchased_by varchar(40), in ip_carrier_store varchar(40),
    in ip_carrier_tag integer, in ip_barcode varchar(40),
    in ip_price integer, in ip_quantity integer)
sp_main: begin
	DECLARE customer_exists INT;
    DECLARE order_exists INT;
    DECLARE drone_exists INT;
    DECLARE barcode_exists INT;
    DECLARE customer_credit INT;
    declare tot_weight int;
    
    if ip_orderID is null or ip_sold_on is null or ip_purchased_by is null or ip_carrier_store is null or ip_carrier_tag is null or ip_carrier_tag < 0
    or ip_barcode is null or ip_price is null or ip_price < 0 or ip_quantity is null or ip_quantity < 0 THEN
		leave sp_main;
	end if; 

    SELECT count(*) INTO customer_exists FROM customers WHERE uname = ip_purchased_by;
	SELECT count(*) INTO order_exists FROM orders WHERE orderID = ip_orderID;
    SELECT count(*) INTO drone_exists FROM drones WHERE droneTag = ip_carrier_tag AND storeID = ip_carrier_store;
    SELECT count(*) INTO barcode_exists FROM products WHERE barcode = ip_barcode;
    SELECT credit INTO customer_credit FROM customers WHERE uname = ip_purchased_by;
    -- select sum(p.weight * ol.quantity) into tot_weight from products p join order_lines ol on p.barcode = ol.barcode join orders o on ol.orderID = o.orderID join drones as d on d.droneTag = o.carrier_tag and d.storeID = o.carrier_store where d.droneTag = ip_carrier_tag and d.storeID = ip_carrier_store;
    -- SELECT SUM(p.weight * ol.quantity) into tot_weight FROM drones AS d  JOIN orders AS o ON d.storeID = o.carrier_store AND d.droneTag = o.carrier_tag JOIN 
    -- order_lines AS ol ON o.orderID = ol.orderID JOIN products AS p ON ol.barcode = p.barcode where d.droneTag = o.carrier_tag and d.storeID = o.carrier_store;
    
    IF customer_exists > 0 AND order_exists = 0 AND drone_exists > 0 AND barcode_exists > 0 AND ip_price >= 0 
    AND ip_quantity > 0 AND customer_credit >= (ip_price * ip_quantity) 
    AND (ip_quantity * (SELECT weight FROM products WHERE barcode = ip_barcode)) <= (SELECT capacity from drones WHERE droneTag = ip_carrier_tag AND storeID = ip_carrier_store) THEN
		INSERT INTO orders(orderID, sold_on, purchased_by, carrier_store, carrier_tag) VALUES (ip_orderID, ip_sold_on, ip_purchased_by, ip_carrier_store, ip_carrier_tag);
        INSERT INTO order_lines(orderID, barcode, price, quantity) VALUES (ip_orderID, ip_barcode, ip_price, ip_quantity);
	END IF;
end //
delimiter ;

-- add order line
delimiter // 
create procedure add_order_line
	(in ip_orderID varchar(40), in ip_barcode varchar(40),
    in ip_price integer, in ip_quantity integer)
sp_main: begin
DECLARE order_exists INT;
    DECLARE barcode_exists INT;
    DECLARE customer_credit INT;
    DECLARE product_exists INT;
    declare tot_weight int;
    declare tot_cost int;
    
    if ip_orderID is null or ip_barcode is null or ip_price is null or ip_quantity is null then
		leave sp_main;
	end if; 
    
	SELECT count(*) INTO order_exists FROM orders WHERE orderID = ip_orderID;
    SELECT count(*) INTO barcode_exists FROM products WHERE barcode = ip_barcode;
    SELECT credit INTO customer_credit FROM customers JOIN orders ON uname = purchased_by WHERE orderID = ip_orderID;

    SELECT count(*) INTO product_exists FROM order_lines WHERE barcode = ip_barcode AND orderID = ip_orderID;
	select sum(p.weight * ol.quantity) into tot_weight from products p join order_lines ol on p.barcode = ol.barcode join orders o on ol.orderID = o.orderID join drones as d on d.droneTag = o.carrier_tag and d.storeID = o.carrier_store 
    -- where o.orderID = ip_orderID;
    where d.droneTag = (select carrier_tag from orders where ip_orderID = orderID) and d.storeID = (select carrier_store from orders where ip_orderID = orderID);
	
    select sum(ol.price * ol.quantity) into tot_cost from order_lines ol join orders o on ol.orderID = o.orderID where ol.orderID = ip_orderID;

    
    IF order_exists > 0 AND barcode_exists > 0 AND ip_price >= 0 
    AND ip_quantity > 0 AND customer_credit >= ((ip_price * ip_quantity) + tot_cost) AND product_exists = 0
    AND ((ip_quantity * (SELECT weight FROM products WHERE barcode = ip_barcode)) + tot_weight) <= (SELECT capacity from drones JOIN orders ON storeID = carrier_store AND droneTag = carrier_tag WHERE orderID = ip_orderID) THEN
        INSERT INTO order_lines(orderID, barcode, price, quantity) VALUES (ip_orderID, ip_barcode, ip_price, ip_quantity);
	END IF;
end //
delimiter ;

-- deliver order
delimiter // 
create procedure deliver_order
	(in ip_orderID varchar(40))
sp_main: begin
	declare order_cost integer;
    declare rate integer;
		#er if (and only if) the order ID is valid, and the drone has enough trips to deliver this order
        if (ip_orderID is null)
			or not exists (select orderID from orders where orderID = ip_orderID)
			then leave sp_main;
		end if;
        -- Check if the drone has enough trips left to deliver this order
	IF (SELECT remaining_trips FROM drones 
		JOIN orders ON drones.storeID = orders.carrier_store AND drones.droneTag = orders.carrier_tag
		WHERE orders.orderID = ip_orderID) <= 0 THEN
		LEAVE sp_main;
	END IF;
        
        #decl order cost
		select SUM(ol.price * ol.quantity) into order_cost from orders as o join order_lines as ol
		on o.orderID = ol.orderID where o.orderID = ip_orderID group by o.orderID;
        #The customer’s credit is reduced by the cost of the order.
        update customers join orders on uname = purchased_by set credit = credit - order_cost where orders.orderID = ip_orderID;
        
        #The store’s revenue is increased by the cost of the order.
        update stores join orders on storeID = carrier_store set revenue = revenue + order_cost where orders.orderID = ip_orderID;
        
		#The drone’s number of remaining trips is reduced by one.
        update drones join orders on droneTag = carrier_tag and storeID = carrier_store set remaining_trips = remaining_trips - 1 where orders.orderID = ip_orderID;
        
        #The pilot’s experience level is increased by one.
        update drone_pilots join drones on uname = pilot join orders on storeID = carrier_store and droneTag = carrier_tag set experience = experience + 1 where orders.orderID = ip_orderID;
        
        #decl rate
        select rating into rate from customers join orders on uname = purchased_by where orders.orderID = ip_orderID;
		#If the order was more than $25, then the customer’s rating is increased by one (if permitted).
        if (order_cost > 25 and rate < 5) 
			then update customers join orders on uname = purchased_by set rating = rating + 1 where orders.orderID = ip_orderID;
        end if;
        
        #All records of the order are otherwise removed from the system
		delete from order_lines where orderID = ip_orderID;
        delete from orders where orderID = ip_orderID;
end //
delimiter ;

-- cancel an order
delimiter // 
create procedure cancel_order
	(in ip_orderID varchar(40))
sp_main: begin
	declare rate int;
    
	if ip_orderID is null then leave sp_main; end if;
	#orderID is valid
    if (not exists (select * from orders where orderID = ip_orderID))
		then leave sp_main;
    end if;
    #customer rating dec by 1 if permitted
    
    update customers join orders on uname = purchased_by set rating = rating - 1 where orderID = ip_orderID and rating > 0;
    #all records of the order are otherwise removed from system
    delete from orders where orderID = ip_orderID;
end //
delimiter ;

-- PENNON
-- display persons distribution across roles
create or replace view role_distribution (category, total) as
-- replace this select query with your solution
SELECT 'users' AS category, COUNT(*) AS total FROM users
	UNION ALL
	SELECT 'customers' AS category, COUNT(*) AS total FROM customers
	UNION ALL
	SELECT 'employees' AS category, COUNT(*) AS total FROM employees
	UNION ALL
	SELECT 'customer_employer_overlap' AS category, COUNT(DISTINCT uname) AS total
	FROM users
	WHERE uname IN (SELECT uname FROM customers) AND uname IN (SELECT uname FROM employees)
	UNION ALL
	SELECT 'drone_pilots' AS category, COUNT(*) AS total FROM drone_pilots
	UNION ALL
	SELECT 'store_workers' AS category, COUNT(*) AS total FROM store_workers
	UNION ALL
	SELECT 'other_employee_roles' AS category, COUNT(*) AS total
	FROM employees
	WHERE uname NOT IN (SELECT uname FROM drone_pilots)
	AND uname NOT IN (SELECT uname FROM store_workers);

-- RAMA
-- display customer status and current credit and spending activity
create or replace view customer_credit_check (customer_name, rating, current_credit,
	credit_already_allocated) as
-- put 0 instead of null if null
select uname as customer_name, rating, credit as current_credit, ifnull(sum(price * quantity), 0) as credit_already_allocated 
from customers left join orders as o on uname = purchased_by left join order_lines as l on o.orderID = l.orderID group by uname;

-- RAMA
-- display drone status and current activity
create or replace view drone_traffic_control (drone_serves_store, drone_tag, pilot,
	total_weight_allowed, current_weight, deliveries_allowed, deliveries_in_progress) as
-- replace this select query with your solution
select d.storeID as drone_serves_store, d.droneTag as drone_tag, d.pilot as pilot, 
d.capacity as total_weight_allowed, IFNULL(SUM(p.weight * l.quantity), 0) as current_weight, 
d.remaining_trips as deliveries_allowed, count(DISTINCT o.orderID) as deliveries_in_progress from drones as d
left join orders as o on d.storeID = o.carrier_store and d.droneTag = o.carrier_tag
left join order_lines as l on o.orderID = l.orderID
left join products as p on l.barcode = p.barcode
group by d.storeID, d.droneTag;

-- RAMA
-- display product status and current activity including most popular products
create or replace view most_popular_products (barcode, product_name, weight, lowest_price,
	highest_price, lowest_quantity, highest_quantity, total_quantity) as
-- replace this select query with your solution
select p.barcode as barcode, pname as product_name, weight as weight, min(price) as lowest_price, max(price) highest_price, 
ifnull(min(quantity), 0) as lowest_quantity, ifnull(max(quantity),0) as highest_quantity, ifnull(sum(quantity),0) as total_quantity
from products as p
left join order_lines as l on p.barcode = l.barcode
group by p.barcode;

-- RAMA
-- display drone pilot status and current activity including experience
create or replace view drone_pilot_roster (pilot, licenseID, drone_serves_store,
	drone_tag, successful_deliveries, pending_deliveries) as
-- replace this select query with your solution
select p.uname as pilot, p.licenseID as licenseID, d.storeID as drone_serves_store, 
d.droneTag as drone_tag, p.experience as successful_deliveries, COUNT(DISTINCT CASE WHEN pe.orderID IS NOT NULL THEN pe.orderID END) as pending_deliveries
from drone_pilots as p
left join drones as d on p.uname = d.pilot
left join orders as pe on d.droneTag = pe.carrier_tag and d.storeID = pe.carrier_store
group by d.droneTag, d.storeID, p.uname
order by p.uname asc;


-- VED 
-- display store revenue and activity
create or replace view store_sales_overview (store_id, sname, manager, revenue,
	incoming_revenue, incoming_orders) as
-- replace this select query with your solution
SELECT
    s.storeID,
    s.sname,
    s.manager,
    s.revenue,
    SUM(c.price * c.quantity) AS incoming_revenue,
    count(distinct o.orderID) as incoming_orders
FROM
    Stores as s
LEFT JOIN
    Orders as o ON s.storeID = o.carrier_store
LEFT JOIN
    order_lines as c ON o.orderID = c.orderID
GROUP BY
    s.storeID, s.sname, s.revenue;

-- RAMA
-- display the current orders that are being placed/in progress
create or replace view orders_in_progress (orderID, cost, num_products, payload,
	contents) as
-- replace this select query with your solution
select o.orderID, sum(l.price * l.quantity) as cost, count(distinct l.barcode) as num_products, sum(p.weight * l.quantity) as payload, group_concat(p.pname) as contents
from orders as o
join order_lines as l on o.orderID = l.orderID
join products as p on l.barcode = p.barcode
group by o.orderID;

-- VED
-- remove customer
delimiter // 
create procedure remove_customer
	(in ip_uname varchar(40))
sp_main: begin
	-- place your solution here
    if ip_uname is null then 
leave sp_main;
end if;
    
if (ip_uname not in (select uname from customers)) then
leave sp_main;
end if;

    if (ip_uname not in (select purchased_by from orders)) then
delete from customers where uname = ip_uname;

if (ip_uname not in (select uname from employees)) then
delete from users where uname = ip_uname;
end if;
    end if;
end //
delimiter ;

-- VED
-- remove drone pilot
delimiter // 
create procedure remove_drone_pilot
	(in ip_uname varchar(40))
sp_main: begin
declare dronep int;
    declare dronepc int;
    if ip_uname is null then 
leave sp_main;
end if;
    select count(*) into dronep from drones where pilot = ip_uname;
    select count(*) into dronepc from customers where uname = ip_uname;
    if (dronepc > 0) then
		delete from drone_pilots where uname like ip_uname;
		delete from employees where uname like ip_uname;
else if (dronep = 0) then
        delete from drone_pilots where uname like ip_uname;
        delete from employees where uname like ip_uname;
        delete from users where uname like ip_uname;
end if;
    end if;
end //
delimiter ;

-- VED
-- remove product
delimiter // 
create procedure remove_product
	(in ip_barcode varchar(40))
sp_main: begin
	declare product_a int;
    if ip_barcode is null then 
leave sp_main;
end if;
    select count(*) into product_a from order_lines p where p.barcode = ip_barcode;
    if (product_a = 0) then
		delete from products where barcode = ip_barcode;
end if;
end //
delimiter ;

-- remove drone
delimiter // 
create procedure remove_drone
	(in ip_storeID varchar(40), in ip_droneTag integer)
sp_main: begin
	declare dronesp int;
    if ip_storeID is null then 
leave sp_main;
end if;
    if ip_droneTag is null or ip_droneTag < 0 then 
leave sp_main;
end if;
    select count(*) into dronesp from orders where ip_storeID = carrier_store and ip_droneTag = carrier_tag;
    
    if (dronesp = 0) then
		delete from drones where storeID = ip_storeID and droneTag = ip_droneTag;
	end if;
end //
delimiter ;
