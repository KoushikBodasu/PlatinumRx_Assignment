USE platinumrx;



CREATE TABLE clinics (
    cid VARCHAR(50),
    clinic_name VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(50),
    country VARCHAR(50)
);

CREATE TABLE customer (
    uid VARCHAR(50),
    name VARCHAR(100),
    mobile VARCHAR(20)
);

CREATE TABLE clinic_sales (
    oid VARCHAR(50),
    uid VARCHAR(50),
    cid VARCHAR(50),
    amount FLOAT,
    datetime DATETIME,
    sales_channel VARCHAR(50)
);

CREATE TABLE expenses (
    eid VARCHAR(50),
    cid VARCHAR(50),
    description VARCHAR(100),
    amount FLOAT,
    datetime DATETIME
);



INSERT INTO clinics VALUES
('c1','ABC Clinic','Chennai','TN','India'),
('c2','HealthPlus','Bangalore','KA','India'),
('c3','Care Clinic','Chennai','TN','India'),
('c4','MediCare','Bangalore','KA','India');

INSERT INTO customer VALUES
('u1','John','9999999999'),
('u2','Sam','8888888888');

INSERT INTO clinic_sales VALUES
('o1','u1','c1',2000,'2021-09-10','online'),
('o2','u2','c1',5000,'2021-09-15','offline'),
('o3','u1','c2',7000,'2021-10-05','online'),
('o4','u2','c3',3000,'2021-09-12','online'),
('o5','u1','c4',4000,'2021-09-18','offline');

INSERT INTO expenses VALUES
('e1','c1','rent',1000,'2021-09-01'),
('e2','c2','equipment',2000,'2021-10-01'),
('e3','c3','maintenance',1500,'2021-09-01'),
('e4','c4','staff',2500,'2021-09-01');



SELECT 
    sales_channel,
    SUM(amount) AS total_revenue
FROM clinic_sales
WHERE YEAR(datetime) = 2021
GROUP BY sales_channel;

SELECT 
    cs.uid,
    c.name,
    SUM(cs.amount) AS total_spent
FROM clinic_sales cs
JOIN customer c ON cs.uid = c.uid
WHERE YEAR(cs.datetime) = 2021
GROUP BY cs.uid, c.name
ORDER BY total_spent DESC
LIMIT 10;


SELECT 
    m.month,
    COALESCE(r.revenue, 0) AS revenue,
    COALESCE(e.expense, 0) AS expense,
    COALESCE(r.revenue, 0) - COALESCE(e.expense, 0) AS profit,
    CASE 
        WHEN COALESCE(r.revenue, 0) - COALESCE(e.expense, 0) > 0 
        THEN 'Profitable'
        ELSE 'Not Profitable'
    END AS status
FROM (
    SELECT MONTH(datetime) AS month FROM clinic_sales
    UNION
    SELECT MONTH(datetime) FROM expenses
) m
LEFT JOIN (
    SELECT MONTH(datetime) AS month, SUM(amount) AS revenue
    FROM clinic_sales
    WHERE YEAR(datetime) = 2021
    GROUP BY month
) r ON m.month = r.month
LEFT JOIN (
    SELECT MONTH(datetime) AS month, SUM(amount) AS expense
    FROM expenses
    WHERE YEAR(datetime) = 2021
    GROUP BY month
) e ON m.month = e.month;


SELECT *
FROM (
    SELECT 
        c.city,
        cs.cid,
        SUM(cs.amount) - COALESCE(SUM(e.amount), 0) AS profit,
        RANK() OVER (
            PARTITION BY c.city 
            ORDER BY SUM(cs.amount) - COALESCE(SUM(e.amount), 0) DESC
        ) AS rnk
    FROM clinic_sales cs
    JOIN clinics c ON cs.cid = c.cid
    LEFT JOIN expenses e ON cs.cid = e.cid
    WHERE MONTH(cs.datetime) = 9
      AND YEAR(cs.datetime) = 2021
    GROUP BY c.city, cs.cid
) t
WHERE rnk = 1;


SELECT *
FROM (
    SELECT 
        c.state,
        cs.cid,
        SUM(cs.amount) - COALESCE(SUM(e.amount), 0) AS profit,
        RANK() OVER (
            PARTITION BY c.state 
            ORDER BY SUM(cs.amount) - COALESCE(SUM(e.amount), 0) ASC
        ) AS rnk
    FROM clinic_sales cs
    JOIN clinics c ON cs.cid = c.cid
    LEFT JOIN expenses e ON cs.cid = e.cid
    WHERE MONTH(cs.datetime) = 9
      AND YEAR(cs.datetime) = 2021
    GROUP BY c.state, cs.cid
) t
WHERE rnk = 2;