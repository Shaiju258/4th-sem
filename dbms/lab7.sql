DROP DATABASE IF EXISTS lab7;

create database lab7;
use lab7;

DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    id INT IDENTITY(1,1) PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(50)
);

DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
    id INT IDENTITY(1,1) PRIMARY KEY,
    order_date DATE,
    amount DECIMAL(8, 2),
    customer_id INT,
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

INSERT INTO
    customers (first_name, last_name, email)
VALUES
    ('Boy', 'George', 'george@gmail.com'),
    ('George', 'Michael', 'gm@gmail.com'),
    ('David', 'Bowie', 'david@gmail.com'),
    ('Blue', 'Steele', 'blue@gmail.com'),
    ('Bette', 'Davis', 'bette@aol.com');

INSERT INTO
    orders (order_date, amount, customer_id)
VALUES
    ('2016-02-10', 99.99, 1),
    ('2017-11-11', 35.50, 1),
    ('2014-12-12', 800.67, 2),
    ('2015-01-03', 12.39, 2),
    ('1999-04-11', 0.0, 5);



SELECT * FROM customers;
SELECT * FROM orders;


SELECT
    id
FROM
    customers
WHERE
    last_name = 'George';

SELECT
    *
FROM
    orders
WHERE
    customer_id = 1;

SELECT
    *
FROM
    orders
WHERE
    customer_id = (
        SELECT
            id
        FROM
            customers
        WHERE
            last_name = 'George'
    );

-- To perform a (kind of useless) cross join:
SELECT
    *
FROM
    customers,
    orders;


SELECT
    *
FROM
    orders
WHERE
    customer_id in (
        SELECT
            distinct id
        FROM
            customers
    );

SELECT
    *
FROM
    customers
WHERE
    id in (
        SELECT
            distinct customer_id
        FROM
            orders
    );

SELECT * FROM customers;
SELECT * FROM orders;

-- Our first inner join!
SELECT customers.*,orders.*
FROM orders 
right JOIN customers
ON orders.customer_id = customers.id;

SELECT
    first_name,
    last_name,
    order_date,
    amount
FROM
    customers
    JOIN orders ON orders.customer_id = customers.id;

-- The order doesn't matter here:
SELECT
    *
FROM
    orders
    JOIN customers ON customers.id = orders.customer_id;

SELECT * FROM customers;
SELECT * FROM orders;

SELECT
    c.first_name,
    c.last_name,
    SUM(o.amount) AS totalamount
FROM customers c
JOIN orders o
ON o.customer_id = c.id
GROUP BY
    c.first_name,
    c.last_name
ORDER BY
    totalamount;

SELECT * FROM customers;
SELECT * FROM orders;

SELECT
    customers.first_name,
    customers.last_name,
    orders.order_date,
    orders.amount
FROM
    customers
    LEFT JOIN orders ON orders.customer_id = customers.id;

SELECT
    order_date,
    amount,
    first_name,
    last_name
FROM
    orders
    LEFT JOIN customers ON orders.customer_id = customers.id;

SELECT * FROM customers;
SELECT * FROM orders;

SELECT
    first_name,
    last_name,
    sum(amount) as total,
    NULLIF(SUM(amount), 0) AS money_spent
FROM
    customers
    LEFT JOIN orders ON customers.id = orders.customer_id
GROUP BY
    first_name,
    last_name;

SELECT
    first_name,
    last_name,
    order_date,
    amount
FROM
    customers
    RIGHT JOIN orders ON customers.id = orders.customer_id;

DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;