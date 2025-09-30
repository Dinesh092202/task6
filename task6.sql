-- Task 6: Subqueries and Nested Queries
-- Objective: Use subqueries in SELECT, WHERE, and FROM
-- Tools: DB Browser for SQLite / MySQL Workbench

-- =========================
-- 1. Create Tables
-- =========================
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Customers;

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(50)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    amount DECIMAL(10,2),
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- =========================
-- 2. Insert Sample Data
-- =========================
INSERT INTO Customers (customer_id, name, city) VALUES
(1, 'Dinesh', 'Delhi'),
(2, 'Anurag', 'Mumbai'),
(3, 'Akash', 'Bangalore'),
(4, 'Rudra', 'Chennai'),
(5, 'Om', 'Kolkata');

INSERT INTO Orders (order_id, customer_id, amount, order_date) VALUES
(101, 1, 250.00, '2025-01-10'),
(102, 1, 800.00, '2025-02-15'),
(103, 2, 1200.00, '2025-03-05'),
(104, 3, 500.00, '2025-03-20'),
(105, 4, 1500.00, '2025-04-10'),
(106, 5, 300.00, '2025-05-01'),
(107, 3, 700.00, '2025-06-12');

-- =========================
-- 3. Queries
-- =========================

-- 3.1 Subquery in SELECT (Scalar Subquery)
SELECT 
    name,
    (SELECT COUNT(*) 
     FROM Orders o 
     WHERE o.customer_id = c.customer_id) AS total_orders
FROM Customers c;

-- 3.2 Subquery in WHERE (IN)
SELECT name 
FROM Customers 
WHERE customer_id IN (
    SELECT customer_id 
    FROM Orders 
    WHERE amount > 500
);

-- 3.3 Subquery in WHERE (EXISTS - Correlated Subquery)
SELECT name 
FROM Customers c
WHERE EXISTS (
    SELECT 1 
    FROM Orders o 
    WHERE o.customer_id = c.customer_id
);

-- 3.4 Subquery in FROM (Derived Table)
SELECT c.name, t.avg_amount
FROM Customers c
JOIN (
    SELECT customer_id, AVG(amount) AS avg_amount
    FROM Orders
    GROUP BY customer_id
) t ON c.customer_id = t.customer_id;

-- 3.5 Subquery with "="
SELECT name 
FROM Customers 
WHERE customer_id = (
    SELECT customer_id 
    FROM Orders 
    ORDER BY amount DESC 
    LIMIT 1
);
