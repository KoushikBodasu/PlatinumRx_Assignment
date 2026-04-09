USE platinumrx;


CREATE TABLE users (
    user_id VARCHAR(50),
    name VARCHAR(100),
    phone_number VARCHAR(20),
    mail_id VARCHAR(100),
    billing_address VARCHAR(200)
);

CREATE TABLE bookings (
    booking_id VARCHAR(50),
    booking_date DATETIME,
    room_no VARCHAR(50),
    user_id VARCHAR(50)
);

CREATE TABLE booking_commercials (
    id VARCHAR(50),
    booking_id VARCHAR(50),
    bill_id VARCHAR(50),
    bill_date DATETIME,
    item_id VARCHAR(50),
    item_quantity FLOAT
);

CREATE TABLE items (
    item_id VARCHAR(50),
    item_name VARCHAR(100),
    item_rate FLOAT
);



INSERT INTO users VALUES
('u1','John Doe','9999999999','john@gmail.com','Chennai'),
('u2','Sam','8888888888','sam@gmail.com','Bangalore'),
('u3','Kiran','7777777777','kiran@gmail.com','Hyderabad');

INSERT INTO bookings VALUES
('b1','2021-11-10 10:00:00','r1','u1'),
('b2','2021-10-05 12:00:00','r2','u2'),
('b3','2021-11-15 14:00:00','r3','u1'),
('b4','2021-09-20 09:00:00','r4','u3');

INSERT INTO items VALUES
('i1','Paratha',20),
('i2','Veg Curry',100),
('i3','Rice',50);

INSERT INTO booking_commercials VALUES
('c1','b1','bill1','2021-11-10 12:00:00','i1',5),
('c2','b1','bill1','2021-11-10 12:00:00','i2',2),
('c3','b2','bill2','2021-10-05 13:00:00','i2',15),
('c4','b3','bill3','2021-11-15 15:00:00','i3',10),
('c5','b4','bill4','2021-09-20 10:00:00','i1',20);




SELECT u.user_id, u.name, b.room_no
FROM (
    SELECT 
        user_id,
        room_no,
        booking_date,
        ROW_NUMBER() OVER (
            PARTITION BY user_id 
            ORDER BY booking_date DESC
        ) AS rn
    FROM bookings
) b
JOIN users u ON b.user_id = u.user_id
WHERE rn = 1;

SELECT 
    b.booking_id,
    SUM(bc.item_quantity * i.item_rate) AS total_bill
FROM bookings b
JOIN booking_commercials bc ON b.booking_id = bc.booking_id
JOIN items i ON bc.item_id = i.item_id
WHERE MONTH(b.booking_date) = 11 
  AND YEAR(b.booking_date) = 2021
GROUP BY b.booking_id;

SELECT 
    bc.bill_id,
    SUM(bc.item_quantity * i.item_rate) AS bill_amount
FROM booking_commercials bc
JOIN items i ON bc.item_id = i.item_id
WHERE MONTH(bc.bill_date) = 10
  AND YEAR(bc.bill_date) = 2021
GROUP BY bc.bill_id
HAVING bill_amount > 1000;

SELECT *
FROM (
    SELECT 
        MONTH(bc.bill_date) AS month,
        i.item_name,
        SUM(bc.item_quantity) AS total_qty,
        RANK() OVER (
            PARTITION BY MONTH(bc.bill_date) 
            ORDER BY SUM(bc.item_quantity) DESC
        ) AS rnk_max,
        RANK() OVER (
            PARTITION BY MONTH(bc.bill_date) 
            ORDER BY SUM(bc.item_quantity) ASC
        ) AS rnk_min
    FROM booking_commercials bc
    JOIN items i ON bc.item_id = i.item_id
    WHERE YEAR(bc.bill_date) = 2021
    GROUP BY month, i.item_name
) t
WHERE rnk_max = 1 OR rnk_min = 1;

SELECT 
    t.month,
    u.user_id,
    u.name,
    t.bill_id,
    t.bill_amount
FROM (
    SELECT 
        MONTH(bc.bill_date) AS month,
        bc.bill_id,
        b.user_id,
        SUM(bc.item_quantity * i.item_rate) AS bill_amount,
        RANK() OVER (
            PARTITION BY MONTH(bc.bill_date)
            ORDER BY SUM(bc.item_quantity * i.item_rate) DESC
        ) AS rnk
    FROM booking_commercials bc
    JOIN bookings b ON bc.booking_id = b.booking_id
    JOIN items i ON bc.item_id = i.item_id
    WHERE YEAR(bc.bill_date) = 2021
    GROUP BY month, bc.bill_id, b.user_id
) t
JOIN users u ON t.user_id = u.user_id
WHERE t.rnk = 2;