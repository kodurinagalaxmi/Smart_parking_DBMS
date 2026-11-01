 
# Smart Parking Reservation and Management System

A MySQL database project (DBMS course) that manages parking lots and their slots. Users register vehicles, reserve a slot for a chosen
time window, record entry and exit, pay parking fees, and view the real-time availability of every lot.

## Team

| Roll Number | Name |
|-------------|------|
| 25WH1A05C4 | P.Sanjana |
| 25WH1A05C0 | P.Nandita |
| 25WH1A05C1 | K.Nagalaxmi |
| 25WH1A05A1 | V.Shruthi |
| 25WH1A05B2 | M.Sri Hanu Bhavya |

## Features

- **Eight normalized tables (3NF):** `USERS`, `VEHICLES`, `PARKING_LOTS`, `PARKING_SLOTS`, `RESERVATIONS`, `PARKING_LOGS`, `PAYMENTS`, `PENALTIES`
- **Constraints:** primary keys, foreign keys, `NOT NULL`, `UNIQUE`, `DEFAULT`, `CHECK`
- **Views:** `LOT_AVAILABILITY_VIEW` (real-time availability and occupancy per lot) and `COMPLETED_RESERVATIONS_VIEW`
- **Triggers:** audit log for reservation insert/update/delete, and a `BEFORE INSERT` trigger that rejects double-booking of a slot for overlapping times
- **Stored procedures and a cursor:** `DisplayUsers`, `GetUserPayments`, `DisplayPaymentSummary`
- **Query coverage:** `ANY`, `ALL`, `UNION`, `INTERSECT`, joins, nested and correlated subqueries, aggregates, `GROUP BY`/`HAVING`, window functions
- **Project queries:** average daily revenue of a parking lot, and hourly peak-demand blocks where bookings reached lot capacity

## Repository contents

| File | Description |
|------|-------------|
| `Smart_Parking_DBMS_Project.sql` | Complete script: schema, sample data, views, triggers, procedures and all queries |
| `Smart_Parking_DBMS_Project.pdf` | Project report with ER diagram, relational model, normalization, and every query with its output |
| `README.md` | This file |

## Requirements

- **MySQL 8.0.31 or later** (needed for `INTERSECT`; `RENAME COLUMN` needs 8.0+ and `CHECK` constraints are only enforced from 8.0.16)
- MySQL command-line client or MySQL Workbench

## How to run

```bash
mysql -u root -p < Smart_Parking_DBMS_Project.sql
```

Or open `Smart_Parking_DBMS_Project.sql` in MySQL Workbench and run it. The script creates and selects the `SmartParking` database.
To re-run it from scratch, uncomment the `DROP DATABASE IF EXISTS SmartParking;` line at the top.

### Notes

- The double-booking demonstration (`INSERT ... VALUES (409, ...)`) is **commented out** in the script because it is *meant to fail* with
  `ERROR 1644 (45000): Slot is already reserved for the selected time`. Run it on its own after the script to see the trigger working.
- `TRUNCATE` and `DROP TABLE` examples are commented out on purpose.
- The `DELETE` of penalty 705 is followed by a re-insert of that single row so the sample data ends up complete.
- Queries without an `ORDER BY` may return rows in a different order on your server; the data is the same.

## Sample queries

**Average daily revenue of lot 201** (expected `120.00`):
Paid payments are totalled per day for the lot, and the daily totals are then averaged.

**Peak demand blocks** (expected: Hitech Plaza 2026-10-26 at 09:00 and Miyapur Metro 2026-10-27 at 08:00):
Reservations are counted per lot, date and start hour; blocks where bookings reach `TotalSlots` are listed.

See the PDF report for the full queries and outputs.
