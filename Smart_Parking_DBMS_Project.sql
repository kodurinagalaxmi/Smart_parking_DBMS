-- =====================================================================
-- Smart Parking Reservation and Management System  (DBMS Project)
-- Team:
--   25WH1A05C4  P.Sanjana
--   25WH1A05C0  P.Nandita
--   25WH1A05C1  K.Nagalaxmi
--   25WH1A05A1  V.Shruthi
--   25WH1A05B2  M.Sri Hanu Bhavya
--
-- Requires MySQL 8.0.31 or later (INTERSECT, RENAME COLUMN, enforced CHECK).
-- Run the whole file:   mysql -u root -p < Smart_Parking_DBMS_Project.sql
-- (or open it in MySQL Workbench and execute it).
-- =====================================================================

-- Uncomment the next line to rebuild the database from scratch on a re-run:
-- DROP DATABASE IF EXISTS SmartParking;


-- =====================================================================
-- DDL COMMANDS
-- =====================================================================

-- ---- Create database ----
CREATE DATABASE SmartParking;
USE SmartParking;

-- ---- Create tables ----
CREATE TABLE USERS (
    User_id INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Address VARCHAR(200),
    PhoneNo VARCHAR(15),
    Email VARCHAR(100) UNIQUE
);

CREATE TABLE VEHICLES (
    Vehicle_id INT PRIMARY KEY,
    VehicleNumber VARCHAR(20) NOT NULL UNIQUE,
    VehicleType VARCHAR(30) NOT NULL,
    User_id INT NOT NULL,
    FOREIGN KEY (User_id)
        REFERENCES USERS(User_id)
);

CREATE TABLE PARKING_LOTS (
    Lot_id INT PRIMARY KEY,
    LotName VARCHAR(100) NOT NULL,
    Address VARCHAR(200),
    TotalSlots INT NOT NULL,
    HourlyRate DECIMAL(10,2) NOT NULL,
    CHECK (TotalSlots > 0),
    CHECK (HourlyRate >= 0)
);

CREATE TABLE PARKING_SLOTS (
    Slot_id INT PRIMARY KEY,
    Lot_id INT NOT NULL,
    SlotNumber VARCHAR(10) NOT NULL,
    SlotType VARCHAR(20) NOT NULL,
    Status VARCHAR(20) DEFAULT 'Available',
    FOREIGN KEY (Lot_id)
        REFERENCES PARKING_LOTS(Lot_id),
    UNIQUE (Lot_id, SlotNumber)
);

CREATE TABLE RESERVATIONS (
    Reservation_id INT PRIMARY KEY,
    User_id INT NOT NULL,
    Vehicle_id INT NOT NULL,
    Slot_id INT NOT NULL,
    ReservationDate DATE NOT NULL,
    StartTime TIME NOT NULL,
    EndTime TIME NOT NULL,
    Status VARCHAR(20) DEFAULT 'Booked',
    FOREIGN KEY (User_id)
        REFERENCES USERS(User_id),
    FOREIGN KEY (Vehicle_id)
        REFERENCES VEHICLES(Vehicle_id),
    FOREIGN KEY (Slot_id)
        REFERENCES PARKING_SLOTS(Slot_id),
    CHECK (EndTime > StartTime)
);

CREATE TABLE PARKING_LOGS (
    Log_id INT PRIMARY KEY,
    Reservation_id INT NOT NULL,
    EntryTime DATETIME NOT NULL,
    ExitTime DATETIME,
    FOREIGN KEY (Reservation_id)
        REFERENCES RESERVATIONS(Reservation_id),
    CHECK (ExitTime IS NULL OR ExitTime > EntryTime)
);

CREATE TABLE PAYMENTS (
    Payment_id INT PRIMARY KEY,
    Reservation_id INT NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
    PaymentMode VARCHAR(20),
    PaymentStatus VARCHAR(20) DEFAULT 'Pending',
    PaymentDate DATE,
    FOREIGN KEY (Reservation_id)
        REFERENCES RESERVATIONS(Reservation_id)
);

CREATE TABLE PENALTIES (
    Penalty_id INT PRIMARY KEY,
    Reservation_id INT NOT NULL,
    Reason VARCHAR(100),
    Amount DECIMAL(10,2) NOT NULL,
    PenaltyDate DATE,
    FOREIGN KEY (Reservation_id)
        REFERENCES RESERVATIONS(Reservation_id),
    CHECK (Amount > 0)
);

SHOW TABLES;

-- ---- ALTER, RENAME, TRUNCATE and DROP ----
-- Add a column
ALTER TABLE USERS
ADD City VARCHAR(50);

-- Modify a column
ALTER TABLE USERS
MODIFY Name VARCHAR(150) NOT NULL;

-- Rename a column
ALTER TABLE USERS
RENAME COLUMN City TO Location;

-- Rename a table
RENAME TABLE PAYMENTS TO RESERVATION_PAYMENTS;

-- Rename it back for the remaining code
RENAME TABLE RESERVATION_PAYMENTS TO PAYMENTS;

-- Remove all rows while retaining the table structure
-- Execute only when you intentionally want to clear the table.
-- TRUNCATE TABLE PENALTIES;

-- Drop a table (destructive; execute only when needed)
-- DROP TABLE PENALTIES;

DESC USERS;


-- =====================================================================
-- DML COMMANDS
-- =====================================================================

-- ---- Insert 15 users ----
INSERT INTO USERS
(User_id, Name, Address, PhoneNo, Email, Location)
VALUES
(1, 'Karthik', 'Street 1', '9100000001', 'karthik@gmail.com', 'Hyderabad'),
(2, 'Lakshmi', 'Street 2', '9100000002', 'lakshmi@gmail.com', 'Hyderabad'),
(3, 'Harsha', 'Street 3', '9100000003', 'harsha@gmail.com', 'Secunderabad'),
(4, 'Nisha', 'Street 4', '9100000004', 'nisha@gmail.com', 'Hyderabad'),
(5, 'Suresh', 'Street 5', '9100000005', 'suresh@gmail.com', 'Miyapur'),
(6, 'Divya', 'Street 6', '9100000006', 'divya@gmail.com', 'Kukatpally'),
(7, 'Manoj', 'Street 7', '9100000007', 'manoj@gmail.com', 'Miyapur'),
(8, 'Swathi', 'Street 8', '9100000008', 'swathi@gmail.com', 'Gachibowli'),
(9, 'Pranav', 'Street 9', '9100000009', 'pranav@gmail.com', 'Hyderabad'),
(10, 'Bhavana', 'Street 10', '9100000010', 'bhavana@gmail.com', 'Miyapur'),
(11, 'Naveen', 'Street 11', '9100000011', 'naveen@gmail.com', 'Kukatpally'),
(12, 'Tejaswi', 'Street 12', '9100000012', 'tejaswi@gmail.com', 'Gachibowli'),
(13, 'Sandeep', 'Street 13', '9100000013', 'sandeep@gmail.com', 'Hyderabad'),
(14, 'Keerthi', 'Street 14', '9100000014', 'keerthi@gmail.com', 'Secunderabad'),
(15, 'Ashwin', 'Street 15', '9100000015', 'ashwin@gmail.com', 'Gachibowli');

SELECT * FROM USERS;

-- ---- Insert sample data into the remaining tables ----
INSERT INTO VEHICLES VALUES
(101, 'TS09AB1001', 'Car', 1),
(102, 'TS09CD1002', 'Car', 2),
(103, 'TS08EF1003', 'EV', 3),
(104, 'TS07GH1004', 'Car', 4),
(105, 'TS10JK1005', 'Car', 5),
(106, 'TS09LM1006', 'Bike', 6);

INSERT INTO PARKING_LOTS VALUES
(201, 'Hitech Plaza', 'Hitech City, Hyderabad', 3, 30.00),
(202, 'Gachibowli Park', 'Gachibowli, Hyderabad', 3, 40.00),
(203, 'Miyapur Metro', 'Miyapur, Hyderabad', 2, 20.00),
(204, 'Secunderabad Stn', 'Secunderabad', 2, 50.00);

INSERT INTO PARKING_SLOTS VALUES
(301, 201, 'A1', 'Car', 'Available'),
(302, 201, 'A2', 'Car', 'Available'),
(303, 201, 'A3', 'EV', 'Occupied'),
(304, 202, 'B1', 'Car', 'Reserved'),
(305, 202, 'B2', 'Bike', 'Available'),
(306, 202, 'B3', 'EV', 'Available'),
(307, 203, 'C1', 'Car', 'Occupied'),
(308, 203, 'C2', 'Bike', 'Available'),
(309, 204, 'D1', 'Car', 'Available'),
(310, 204, 'D2', 'Car', 'Reserved');

INSERT INTO RESERVATIONS VALUES
(401, 1, 101, 301, '2026-10-26', '09:00:00', '11:00:00', 'Completed'),
(402, 2, 102, 302, '2026-10-26', '09:00:00', '12:00:00', 'Completed'),
(403, 3, 103, 303, '2026-10-26', '09:30:00', '10:30:00', 'Completed'),
(404, 4, 104, 304, '2026-11-02', '10:00:00', '13:00:00', 'Booked'),
(405, 1, 101, 307, '2026-10-27', '08:00:00', '10:00:00', 'Completed'),
(406, 6, 106, 308, '2026-10-27', '08:30:00', '09:30:00', 'Completed'),
(407, 2, 102, 301, '2026-10-27', '13:00:00', '15:00:00', 'Completed');

INSERT INTO PARKING_LOGS VALUES
(501, 401, '2026-10-26 08:55:00', '2026-10-26 11:10:00'),
(502, 402, '2026-10-26 09:05:00', '2026-10-26 12:20:00'),
(503, 403, '2026-10-26 09:35:00', '2026-10-26 11:15:00'),
(504, 405, '2026-10-27 08:00:00', '2026-10-27 10:00:00'),
(505, 406, '2026-10-27 08:35:00', '2026-10-27 09:25:00'),
(506, 407, '2026-10-27 12:55:00', '2026-10-27 15:00:00');

INSERT INTO PAYMENTS VALUES
(601, 401, 60.00, 'UPI', 'Paid', '2026-10-26'),
(602, 402, 90.00, 'Card', 'Paid', '2026-10-26'),
(603, 403, 30.00, 'Cash', 'Paid', '2026-10-26'),
(604, 404, 120.00, 'UPI', 'Pending', NULL),
(605, 405, 40.00, 'Card', 'Paid', '2026-10-27'),
(606, 406, 20.00, 'UPI', 'Paid', '2026-10-27'),
(607, 407, 60.00, 'Cash', 'Paid', '2026-10-27');

INSERT INTO PENALTIES VALUES
(701, 401, 'Overstay', 10.00, '2026-10-26'),
(702, 402, 'Overstay', 20.00, '2026-10-26'),
(703, 403, 'Overstay', 45.00, '2026-10-26'),
(704, 406, 'Wrong Slot Parking', 25.00, '2026-10-27'),
(705, 405, 'Blocking Lane', 15.00, '2026-10-27');

SELECT * FROM VEHICLES;

SELECT * FROM PARKING_LOTS;

SELECT * FROM PARKING_SLOTS;

SELECT * FROM RESERVATIONS;

SELECT * FROM PARKING_LOGS;

SELECT * FROM PAYMENTS;

SELECT * FROM PENALTIES;

-- ---- SELECT, UPDATE and DELETE ----
-- Display all users
SELECT * FROM USERS;

-- Display only selected columns
SELECT User_id, Name, Location
FROM USERS;

-- Update a user's location
UPDATE USERS
SET Location = 'Madhapur'
WHERE User_id = 1;

SELECT User_id, Name, Location
FROM USERS
WHERE User_id = 1;

-- Delete a specific penalty record
DELETE FROM PENALTIES
WHERE Penalty_id = 705;

SELECT * FROM PENALTIES;

INSERT INTO PENALTIES VALUES
(705, 405, 'Blocking Lane', 15.00, '2026-10-27');


-- =====================================================================
-- CONSTRAINTS AND SPECIAL QUERIES
-- =====================================================================

-- ---- Constraints ----
-- Add a constraint
ALTER TABLE PAYMENTS
ADD CONSTRAINT chk_payment_amount
CHECK (Amount >= 0);

-- Inspect table constraints and column definitions
SHOW CREATE TABLE RESERVATIONS;

-- ---- ANY ----
SELECT User_id, Name
FROM USERS
WHERE User_id IN (
    SELECT R.User_id
    FROM RESERVATIONS R
    JOIN PAYMENTS P
        ON R.Reservation_id = P.Reservation_id
    WHERE P.Amount > ANY (
        SELECT P2.Amount
        FROM PAYMENTS P2
        JOIN RESERVATIONS R2
            ON P2.Reservation_id = R2.Reservation_id
        WHERE R2.User_id = 1
    )
);

-- ---- ALL ----
SELECT User_id, Name
FROM USERS
WHERE User_id IN (
    SELECT R.User_id
    FROM RESERVATIONS R
    JOIN PAYMENTS P
        ON R.Reservation_id = P.Reservation_id
    WHERE P.Amount > ALL (
        SELECT P2.Amount
        FROM PAYMENTS P2
        JOIN RESERVATIONS R2
            ON P2.Reservation_id = R2.Reservation_id
        WHERE R2.User_id = 1
    )
);

-- ---- UNION ----
SELECT User_id, Name, Location
FROM USERS
WHERE Location = 'Hyderabad'
UNION
SELECT User_id, Name, Location
FROM USERS
WHERE Location = 'Miyapur';

-- ---- INTERSECT ----
SELECT User_id
FROM VEHICLES
INTERSECT
SELECT User_id
FROM RESERVATIONS;

-- ---- JOIN ----
SELECT
    U.User_id,
    U.Name,
    V.VehicleNumber,
    L.LotName,
    S.SlotNumber,
    R.ReservationDate,
    R.StartTime,
    R.EndTime
FROM USERS U
JOIN RESERVATIONS R
    ON U.User_id = R.User_id
JOIN VEHICLES V
    ON R.Vehicle_id = V.Vehicle_id
JOIN PARKING_SLOTS S
    ON R.Slot_id = S.Slot_id
JOIN PARKING_LOTS L
    ON S.Lot_id = L.Lot_id;


-- =====================================================================
-- NESTED AND CORRELATED SUBQUERIES
-- =====================================================================

-- ---- Nested subquery ----
SELECT User_id, Name
FROM USERS
WHERE User_id IN (
    SELECT R.User_id
    FROM RESERVATIONS R
    JOIN PAYMENTS P
        ON R.Reservation_id = P.Reservation_id
    WHERE P.Amount > (
        SELECT AVG(Amount)
        FROM PAYMENTS
    )
);

-- ---- Correlated subquery ----
SELECT
    P.Payment_id,
    R.User_id,
    P.Amount
FROM PAYMENTS P
JOIN RESERVATIONS R
    ON P.Reservation_id = R.Reservation_id
WHERE P.Amount > (
    SELECT AVG(P2.Amount)
    FROM PAYMENTS P2
    JOIN RESERVATIONS R2
        ON P2.Reservation_id = R2.Reservation_id
    WHERE R2.User_id = R.User_id
);


-- =====================================================================
-- AGGREGATE FUNCTIONS, WINDOW FUNCTIONS, GROUP BY AND HAVING
-- =====================================================================

-- ---- Aggregate functions ----
SELECT
    COUNT(*) AS TotalRecords,
    SUM(Amount) AS TotalAmountCollected,
    AVG(Amount) AS AveragePayment,
    MAX(Amount) AS MaximumPayment,
    MIN(Amount) AS MinimumPayment
FROM PAYMENTS;

-- ---- GROUP BY ----
SELECT
    U.User_id,
    U.Name,
    SUM(P.Amount) AS TotalPayment
FROM USERS U
JOIN RESERVATIONS R
    ON U.User_id = R.User_id
JOIN PAYMENTS P
    ON R.Reservation_id = P.Reservation_id
GROUP BY U.User_id, U.Name
ORDER BY U.User_id;

-- ---- HAVING ----
SELECT
    R.User_id,
    SUM(P.Amount) AS TotalPayment
FROM RESERVATIONS R
JOIN PAYMENTS P
    ON R.Reservation_id = P.Reservation_id
GROUP BY R.User_id
HAVING SUM(P.Amount) > 50
ORDER BY R.User_id;

-- ---- Window functions ----
SELECT
    R.User_id,
    P.Payment_id,
    P.Amount,
    RANK() OVER (
        ORDER BY P.Amount DESC
    ) AS PaymentRank,
    SUM(P.Amount) OVER (
        PARTITION BY R.User_id
    ) AS UserTotal
FROM PAYMENTS P
JOIN RESERVATIONS R
    ON P.Reservation_id = R.Reservation_id
ORDER BY PaymentRank, P.Payment_id;


-- =====================================================================
-- VIEWS
-- =====================================================================

-- ---- Create a view ----
CREATE VIEW LOT_AVAILABILITY_VIEW AS
SELECT
    L.Lot_id,
    L.LotName,
    L.TotalSlots,
    SUM(CASE WHEN S.Status = 'Available' THEN 1 ELSE 0 END) AS AvailableSlots,
    ROUND(
        (L.TotalSlots - SUM(CASE WHEN S.Status = 'Available' THEN 1 ELSE 0 END))
        * 100 / L.TotalSlots, 2
    ) AS OccupancyPercent
FROM PARKING_LOTS L
JOIN PARKING_SLOTS S
    ON L.Lot_id = S.Lot_id
GROUP BY L.Lot_id, L.LotName, L.TotalSlots;

-- ---- Display the view ----
SELECT * FROM LOT_AVAILABILITY_VIEW;

-- ---- Create a view for completed reservations ----
CREATE VIEW COMPLETED_RESERVATIONS_VIEW AS
SELECT
    R.Reservation_id,
    U.Name AS Customer,
    V.VehicleNumber,
    L.LotName,
    R.ReservationDate,
    ROUND(TIME_TO_SEC(TIMEDIFF(R.EndTime, R.StartTime)) / 3600, 2) AS Hours,
    ROUND(TIME_TO_SEC(TIMEDIFF(R.EndTime, R.StartTime)) / 3600
          * L.HourlyRate, 2) AS TotalCost
FROM RESERVATIONS R
JOIN USERS U
    ON R.User_id = U.User_id
JOIN VEHICLES V
    ON R.Vehicle_id = V.Vehicle_id
JOIN PARKING_SLOTS S
    ON R.Slot_id = S.Slot_id
JOIN PARKING_LOTS L
    ON S.Lot_id = L.Lot_id
WHERE R.Status = 'Completed';

SELECT * FROM COMPLETED_RESERVATIONS_VIEW;

-- ---- Drop a view ----
DROP VIEW COMPLETED_RESERVATIONS_VIEW;


-- =====================================================================
-- TRIGGERS
-- =====================================================================

-- ---- Create an audit table ----
CREATE TABLE RESERVATION_AUDIT (
    Audit_id INT AUTO_INCREMENT PRIMARY KEY,
    Reservation_id INT,
    ActionType VARCHAR(20),
    OldStatus VARCHAR(20),
    NewStatus VARCHAR(20),
    AuditTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ---- INSERT trigger ----
DELIMITER //

CREATE TRIGGER after_reservation_insert
AFTER INSERT ON RESERVATIONS
FOR EACH ROW
BEGIN
    INSERT INTO RESERVATION_AUDIT
        (Reservation_id, ActionType, OldStatus, NewStatus)
    VALUES
        (NEW.Reservation_id, 'INSERT', NULL, NEW.Status);
END //

DELIMITER ;

INSERT INTO RESERVATIONS
VALUES (408, 1, 101, 302, '2026-11-03', '14:00:00', '16:00:00', 'Booked');

SELECT Audit_id, Reservation_id, ActionType, OldStatus, NewStatus
FROM RESERVATION_AUDIT;

-- ---- UPDATE trigger ----
DELIMITER //

CREATE TRIGGER after_reservation_update
AFTER UPDATE ON RESERVATIONS
FOR EACH ROW
BEGIN
    INSERT INTO RESERVATION_AUDIT
        (Reservation_id, ActionType, OldStatus, NewStatus)
    VALUES
        (NEW.Reservation_id, 'UPDATE', OLD.Status, NEW.Status);
END //

DELIMITER ;

UPDATE RESERVATIONS
SET Status = 'Cancelled'
WHERE Reservation_id = 408;

SELECT Audit_id, Reservation_id, ActionType, OldStatus, NewStatus
FROM RESERVATION_AUDIT
ORDER BY Audit_id;

-- ---- DELETE trigger ----
DELIMITER //

CREATE TRIGGER after_reservation_delete
AFTER DELETE ON RESERVATIONS
FOR EACH ROW
BEGIN
    INSERT INTO RESERVATION_AUDIT
        (Reservation_id, ActionType, OldStatus, NewStatus)
    VALUES
        (OLD.Reservation_id, 'DELETE', OLD.Status, NULL);
END //

DELIMITER ;

DELETE FROM PARKING_LOGS
WHERE Reservation_id = 408;

DELETE FROM PAYMENTS
WHERE Reservation_id = 408;

DELETE FROM PENALTIES
WHERE Reservation_id = 408;

DELETE FROM RESERVATIONS
WHERE Reservation_id = 408;

SELECT Audit_id, Reservation_id, ActionType, OldStatus, NewStatus
FROM RESERVATION_AUDIT
ORDER BY Audit_id;

-- ---- Trigger to prevent double booking ----
DELIMITER //

CREATE TRIGGER before_reservation_insert
BEFORE INSERT ON RESERVATIONS
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1
        FROM RESERVATIONS
        WHERE Slot_id = NEW.Slot_id
          AND ReservationDate = NEW.ReservationDate
          AND Status <> 'Cancelled'
          AND NEW.StartTime < EndTime
          AND NEW.EndTime > StartTime
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Slot is already reserved for the selected time';
    END IF;
END //

DELIMITER ;

-- This statement is EXPECTED TO FAIL (it demonstrates the double-booking trigger).
-- It is commented out so the script runs end-to-end; run it on its own to see the error.
-- INSERT INTO RESERVATIONS
-- VALUES (409, 5, 105, 301, '2026-10-26', '10:00:00', '12:00:00', 'Booked');


-- =====================================================================
-- STORED PROCEDURES
-- =====================================================================

-- ---- Create a procedure to display user details ----
DELIMITER //

CREATE PROCEDURE DisplayUsers()
BEGIN
    SELECT User_id, Name, Location
    FROM USERS
    ORDER BY User_id;
END //

DELIMITER ;

CALL DisplayUsers();

-- ---- Create a procedure to calculate user payments ----
DELIMITER //

CREATE PROCEDURE GetUserPayments(
    IN input_id INT
)
BEGIN
    SELECT
        U.User_id,
        U.Name,
        COALESCE(SUM(P.Amount), 0) AS TotalPayment
    FROM USERS U
    LEFT JOIN RESERVATIONS R
        ON U.User_id = R.User_id
    LEFT JOIN PAYMENTS P
        ON R.Reservation_id = P.Reservation_id
    WHERE U.User_id = input_id
    GROUP BY U.User_id, U.Name;
END //

DELIMITER ;

CALL GetUserPayments(1);


-- =====================================================================
-- CURSORS
-- =====================================================================

-- ---- Create a cursor procedure ----
DELIMITER //

CREATE PROCEDURE DisplayPaymentSummary()
BEGIN
    DECLARE finished INT DEFAULT 0;
    DECLARE r_id INT;
    DECLARE pay DECIMAL(10,2);
    DECLARE running_total DECIMAL(10,2) DEFAULT 0;

    DECLARE payment_cursor CURSOR FOR
        SELECT Reservation_id, Amount
        FROM PAYMENTS
        ORDER BY Reservation_id;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET finished = 1;

    DROP TEMPORARY TABLE IF EXISTS PaymentSummary;

    CREATE TEMPORARY TABLE PaymentSummary (
        Reservation_id INT,
        Amount DECIMAL(10,2),
        RunningTotal DECIMAL(10,2)
    );

    OPEN payment_cursor;

    read_loop: LOOP
        FETCH payment_cursor INTO r_id, pay;

        IF finished = 1 THEN
            LEAVE read_loop;
        END IF;

        SET running_total = running_total + pay;

        INSERT INTO PaymentSummary
        VALUES (r_id, pay, running_total);
    END LOOP;

    CLOSE payment_cursor;

    SELECT * FROM PaymentSummary
    ORDER BY Reservation_id;
END //

DELIMITER ;

CALL DisplayPaymentSummary();


-- =====================================================================
-- PROJECT SAMPLE QUERIES
-- =====================================================================

-- ---- Average daily revenue of a specific parking lot ----
SELECT
    L.Lot_id,
    L.LotName,
    ROUND(AVG(D.DailyRevenue), 2) AS AvgDailyRevenue
FROM PARKING_LOTS L
JOIN (
    SELECT
        S.Lot_id,
        R.ReservationDate,
        SUM(P.Amount) AS DailyRevenue
    FROM PAYMENTS P
    JOIN RESERVATIONS R
        ON P.Reservation_id = R.Reservation_id
    JOIN PARKING_SLOTS S
        ON R.Slot_id = S.Slot_id
    WHERE P.PaymentStatus = 'Paid'
    GROUP BY S.Lot_id, R.ReservationDate
) D
    ON L.Lot_id = D.Lot_id
WHERE L.Lot_id = 201
GROUP BY L.Lot_id, L.LotName;

-- ---- Peak demand time blocks ----
SELECT
    L.LotName,
    R.ReservationDate,
    HOUR(R.StartTime) AS HourBlock,
    COUNT(*) AS Bookings,
    L.TotalSlots
FROM RESERVATIONS R
JOIN PARKING_SLOTS S
    ON R.Slot_id = S.Slot_id
JOIN PARKING_LOTS L
    ON S.Lot_id = L.Lot_id
GROUP BY L.Lot_id, L.LotName, L.TotalSlots,
         R.ReservationDate, HOUR(R.StartTime)
HAVING COUNT(*) >= L.TotalSlots
ORDER BY R.ReservationDate, L.LotName;
