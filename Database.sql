-- CS4400: Introduction to Database Systems (Spring 2024)
-- Phase II: Create Table & Insert Statements [v0] Monday, February 19, 2024 @ 12:00am EST

-- Team 8
-- Amena Hussain (ahussain67)
-- Pennon Shue (pshue3)
-- Rama Khabbaz (rkhabbaz3)
-- Ved Rao (vrao89)

-- Directions:
-- Please follow all instructions for Phase II as listed on Canvas.
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

-- Define the database structures
/* You must enter your tables definitions, along with your primary, unique and foreign key
declarations, and data insertion statements here.  You may sequence them in any order that
works for you.  When executed, your statements must create a functional database that contains
all of the data, and supports as many of the constraints as reasonably possible. */

DROP TABLE IF EXISTS `User`;
CREATE TABLE `User` (
    uname VARCHAR(40) NOT NULL,
    address VARCHAR(500) NOT NULL,
    birthday DATE,
    fname VARCHAR(100) NOT NULL,
    lname VARCHAR(100) NOT NULL,
    PRIMARY KEY (uname)
);

INSERT INTO `User` (uname, address, birthday, fname, lname) VALUES ('awilson5', '220 Peachtree Street', '1963-11-11', 'Aaron', 'Wilson');
INSERT INTO `User` (uname, address, birthday, fname, lname) VALUES ('csoares8', '706 Living Stone Way', '1965-09-03', 'Claire', 'Soares');
INSERT INTO `User` (uname, address, birthday, fname, lname) VALUES ('echarles19', '22 Peachtree Street', '1974-05-06', 'Ella', 'Charles');
INSERT INTO `User` (uname, address, birthday, fname, lname) VALUES ('eross10', '22 Peachtree Street', '1975-04-02', 'Erica', 'Ross');
INSERT INTO `User` (uname, address, birthday, fname, lname) VALUES ('hstark16', '53 Tanker Top Lane', '1971-10-27', 'Harmon', 'Stark');
INSERT INTO `User` (uname, address, birthday, fname, lname) VALUES ('jstone5', '101 Five Finger Way', '1961-01-06', 'Jared', 'Stone');
INSERT INTO `User` (uname, address, birthday, fname, lname) VALUES ('lrodriguez5', '360 Corkscrew Circle', '1975-04-02', 'Lina', 'Rodriguez');
INSERT INTO `User` (uname, address, birthday, fname, lname) VALUES ('sprince6', '22 Peachtree Street', '1968-06-15', 'Sarah', 'Prince');
INSERT INTO `User` (uname, address, birthday, fname, lname) VALUES ('tmccall5', '360 Corkscrew Circle', '1973-03-19', 'Trey', 'McCall');


DROP TABLE IF EXISTS Customer;
CREATE TABLE Customer (
    uname VARCHAR(40) NOT NULL,
    rating INT,
    credit DECIMAL(10, 2),
    PRIMARY KEY (uname),
    CONSTRAINT customer_ib_fk1 FOREIGN KEY (uname) REFERENCES `User`(uname)
);

INSERT INTO Customer (uname, rating, credit) VALUES ('awilson5', 2.0, 100.0);
INSERT INTO Customer (uname, rating, credit) VALUES ('jstone5', 4.0, 40.0);
INSERT INTO Customer (uname, rating, credit) VALUES ('lrodriguez5', 4.0, 60.0);
INSERT INTO Customer (uname, rating, credit) VALUES ('sprince6', 5.0, 30.0);

DROP TABLE IF EXISTS Employee;
CREATE TABLE Employee (
    taxID CHAR(11) NOT NULL,
    uname VARCHAR(40) NOT NULL,
    service INT NOT NULL,
    salary DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (taxID),
    CONSTRAINT employee_ib_fk1 FOREIGN KEY (uname) REFERENCES `User`(uname)
);

INSERT INTO Employee (taxID, uname, service, salary) VALUES ('111-11-1111', 'awilson5', 9, 46000.0);
INSERT INTO Employee (taxID, uname, service, salary) VALUES ('888-88-8888', 'csoares8', 26, 57000.0);
INSERT INTO Employee (taxID, uname, service, salary) VALUES ('777-77-7777', 'echarles19', 3, 27000.0);
INSERT INTO Employee (taxID, uname, service, salary) VALUES ('444-44-4444', 'eross10', 10, 61000.0);
INSERT INTO Employee (taxID, uname, service, salary) VALUES ('555-55-5555', 'hstark16', 20, 59000.0);
INSERT INTO Employee (taxID, uname, service, salary) VALUES ('222-22-2222', 'lrodriguez5', 20, 58000.0);
INSERT INTO Employee (taxID, uname, service, salary) VALUES ('333-33-3333', 'tmccall5', 29, 33000.0);

DROP TABLE IF EXISTS Drone_pilot;
CREATE TABLE Drone_pilot (
    licenseID DECIMAL(6, 0) NOT NULL,
    taxID CHAR(11) NOT NULL,
    experience INT NOT NULL,
    PRIMARY KEY (licenseID),
    CONSTRAINT drone_pilot_ib_fk1 FOREIGN KEY (taxID) REFERENCES Employee(taxID)
);

INSERT INTO Drone_pilot (licenseID, taxID, experience) VALUES (314159, '111-11-1111', 41);
INSERT INTO Drone_pilot (licenseID, taxID, experience) VALUES (287182, '222-22-2222', 67);
INSERT INTO Drone_pilot (licenseID, taxID, experience) VALUES (181633, '333-33-3333', 10);

DROP TABLE IF EXISTS Store_worker;
CREATE TABLE Store_worker (
    taxID CHAR(11) NOT NULL,
    PRIMARY KEY (taxID),
    CONSTRAINT store_worker_ib_fk1 FOREIGN KEY (taxID) REFERENCES Employee(taxID)
);

INSERT INTO Store_worker (taxID) VALUES ('777-77-7777');
INSERT INTO Store_worker (taxID) VALUES ('444-44-4444');
INSERT INTO Store_worker (taxID) VALUES ('555-55-5555');

DROP TABLE IF EXISTS Product;
CREATE TABLE Product (
    barcode VARCHAR(40) NOT NULL,
    pname VARCHAR(100) NOT NULL,
    weight INT NOT NULL,
    PRIMARY KEY (barcode)
);

INSERT INTO Product (barcode, pname, weight) VALUES ('ss_2D4E6L', 'shrimp salad', 3);
INSERT INTO Product (barcode, pname, weight) VALUES ('ap_9T25E36L', 'antipasto platter', 4);
INSERT INTO Product (barcode, pname, weight) VALUES ('pr_3C6A9R', 'pot roast', 6);
INSERT INTO Product (barcode, pname, weight) VALUES ('hs_5E7L23M', 'hoagie sandwich', 3);
INSERT INTO Product (barcode, pname, weight) VALUES ('clc_4T9U25X', 'chocolate lava cake', 5);


DROP TABLE IF EXISTS Store;
CREATE TABLE Store (
    storeID VARCHAR(40) NOT NULL,
    sname VARCHAR(100) NOT NULL,
    revenue DECIMAL(10, 2) NOT NULL,
    manager CHAR(11),
    PRIMARY KEY (storeID),
    CONSTRAINT store_ib_fk1 FOREIGN KEY (manager) REFERENCES Store_worker(taxID)
);

INSERT INTO Store (storeID, sname, revenue, manager) VALUES ('pub', 'Publix', 200, '555-55-5555');
INSERT INTO Store (storeID, sname, revenue, manager) VALUES ('krg', 'Kroger', 300, '777-77-7777');

DROP TABLE IF EXISTS Drone;
CREATE TABLE Drone (
    droneTag VARCHAR(40) NOT NULL,
    storeID VARCHAR(40) NOT NULL,
    rem_trips INT NOT NULL,
    capacity INT NOT NULL,
    controller DECIMAL(6, 0) NOT NULL,
    PRIMARY KEY (droneTag,storeID),
    CONSTRAINT drone_ib_fk1 FOREIGN KEY (storeID) REFERENCES Store(storeID),
    CONSTRAINT drone_ib_fk2 FOREIGN KEY (controller) REFERENCES Drone_pilot(licenseID)
);

INSERT INTO Drone VALUES ('Publix\'s drone #1', 'pub', 3, 10, '314159');
INSERT INTO Drone VALUES ('Publix\'s drone #2', 'pub', 2.0, 20.0, '181633');
INSERT INTO Drone VALUES ('Kroger\'s drone #1', 'krg', 4, 15, '287182');
-- ALSO WORKS TILL HERE!!!

DROP TABLE IF EXISTS Employ;
CREATE TABLE Employ (
    store VARCHAR(40) NOT NULL,
    storeWorker CHAR(11) NOT NULL,
    PRIMARY KEY (store, storeWorker),
    CONSTRAINT employ_ib_fk1 FOREIGN KEY (store) REFERENCES Store(storeID),
    CONSTRAINT employ_ib_fk2 FOREIGN KEY (storeWorker) REFERENCES Store_worker(taxID)
);

INSERT INTO Employ (store, storeWorker) VALUES ('pub', '555-55-5555');
INSERT INTO Employ (store, storeWorker) VALUES ('pub', '444-44-4444'); 
INSERT INTO Employ (store, storeWorker) VALUES ('krg', '777-77-7777');
INSERT INTO Employ (store, storeWorker) VALUES ('krg', '444-44-4444');

DROP TABLE IF EXISTS `Order`;
CREATE TABLE `Order` (
    orderID VARCHAR(40) NOT NULL,
    sold_on DATE NOT NULL,
    customer VARCHAR(40),
    droneTag VARCHAR(40),
    store VARCHAR(40),
    PRIMARY KEY (orderID),
    CONSTRAINT order_ib_fk1 FOREIGN KEY (customer) REFERENCES Customer(uname),
    CONSTRAINT order_ib_fk2 FOREIGN KEY (droneTag, store) REFERENCES Drone(droneTag, storeID)
);

INSERT INTO `Order` (orderID, sold_on, customer, droneTag, store) VALUES ('pub_303', '2021-05-23', 'sprince6', 'Publix\'s drone #1', 'pub');
INSERT INTO `Order` (orderID, sold_on, customer, droneTag, store) VALUES ('krg_217', '2021-05-23', 'jstone5', 'Kroger\'s drone #1', 'krg');
INSERT INTO `Order` (orderID, sold_on, customer, droneTag, store) VALUES ('pub_306', '2021-05-22', 'awilson5', 'Publix\'s drone #2', 'pub');
INSERT INTO `Order` (orderID, sold_on, customer, droneTag, store) VALUES ('pub_305', '2021-05-22', 'sprince6', 'Publix\'s drone #2', 'pub');

DROP TABLE IF EXISTS Contain;
CREATE TABLE Contain (
    product VARCHAR(40) NOT NULL,
    `order` VARCHAR(40) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY (product, `order`),
    CONSTRAINT contain_ib_fk1 FOREIGN KEY (product) REFERENCES Product(barcode),
    CONSTRAINT contain_ib_fk2 FOREIGN KEY (`order`) REFERENCES `order`(orderID)
);

INSERT INTO Contain VALUES ('ap_9T25E36L', 'pub_303', 4, 1), ('pr_3C6A9R', 'pub_303', 20.0, 1.0), ('pr_3C6A9R', 'krg_217', 15.0, 2.0),  ('hs_5E7L23M', 'pub_306', 3.0, 2.0), ('ap_9T25E36L', 'pub_306', 10.0, 1.0), ('clc_4T9U25X', 'pub_305', 3, 2);
