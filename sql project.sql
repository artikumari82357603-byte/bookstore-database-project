DROP TABLE IF EXISTS books;
CREATE TABLE bOOKS (
	Book_ID SERIAL PRIMARY KEY,
	Tital VARCHAR(100),
	Author VARCHAR(100),
	Genre VARCHAR(50),
	Published_Year INT,
	Price NUMERIC(10, 2),
	Stock INT
);

DROP TABLE IF EXISTS customers;
CREATE TABLE Customers (
	Customer_ID SERIAL PRIMARY KEY,
	Name VARCHAR(100),
	Email VARCHAR(100),
	Phone VARCHAR(15),
	City VARCHAR(50),
	Country VARCHAR(150)
);

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
	Order_ID SERIAL PRIMARY KEY,
	Customer_ID INT REFERENCES Customers(Customer_ID),
	Book_ID INT REFERENCES Books(Book_ID),
	Order_Date DATE,
	Quantity INT,
	Total_Ammount NUMERIC(10, 2)
);

SELECT * FROM books;
SELECT * FROM customers;
SELECT * FROM orders;

-- Q1) Retrieve all books in rthe 'Fiction' genre:

SELECT * FROM books
WHERE Genre='Fiction';

-- Q2) Find books published after the year 1950:
SELECT * FROM books
WHERE published_year>1950:

-- Q3) List all customers from the canada:
SELECT * FROM customers
WHERE Country='Canada';

-- Q4) Show orders placed in November 2023:

SELECT * FROM orders
WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';

-- Q5) Retrieve the total stock of books available:

SELECT SUM(stock) AS Total_stock 
FROM books;

-- Q6) Find the details of the most expensive book:

SELECT * FROM books 
ORDER BY price 
LIMIT 1;

-- Q7) Show all customers who ordered more than 1 quantity of a book:

SELECT * FROM orders
WHERE quantity>1;

-- Q8) Retrieve all orders where the total ammount exceeds $20:

SELECT * FROM orders
WHERE total_ammount>20;

-- Q9) List all genre available in the books table:

SELECT DISTINCT genre FROM books;

-- Q10) Find the book with the lowest stock:
SELECT * FROM books ORDER BY stock limit 1;

-- Q11) Calculate the total revenue genreated from all orders:

SELECT SUM(total_ammount) AS Revenue 
FROM orders;

-- Advance Questions:

-- Q1) Retieve the total number of books sold for each genre:

SELECT b.Genre,SUM(o.quantity) AS total_books_sold
FROM orders o
JOIN books b ON o.book_ID = b.book_ID
GROUP BY b.Genre;

-- Q2) Find the average price of books in the "Fantasy" genre:

SELECT AVG(price) AS Average_price
FROM  books
WHERE Genre = 'Fantasy';

-- Q3) List customers who have placed at least 2 orders:

SELECT o.customer_id, c.name, COUNT(o.order_id) AS ORDER_COUNT
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
GROUP BY o.customer_id, c.name
HAVING COUNT(order_id) >2;

-- Q4) Find the frequently ordered book;

SELECT o.book_id, b.tital, COUNT(order_id) AS ORDER_COUNT
FROM orders o
JOIN books b ON o.book_id=b.book_id
GROUP BY o.book_id, b.tital
ORDER BY ORDER_COUNT DESC LIMIT 1;

-- Q5) Show the top 3 most expensive books of 'Fantasy' Genre:

SELECT * FROM books
WHERE genre ='Fantasy'
ORDER BY price DESC LIMIT 3;

-- Q6) Retrieve the total quantity of books sold by each author:

SELECT b.author, SUM(o.quantity) AS Total_books_sold
FROM orders o
JOIN books b ON o.book_id=b.book_id
GROUP BY b.author;

-- Q7) List the cities where customes who spent over $30 are located:

SELECT DISTINCT c.city, total_ammount
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
WHERE o.total_ammount >30;

-- Q8) Find the customer who spent the most on orders:

SELECT c.customer_id, c.name, SUM(o.total_ammount) AS Total_Spent
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY Total_spent DESC LIMIT 1;

-- Q9) Caculate the stock remaining after fulfilling all orders:

SELECT b.book_id, b.tital, b.stock, COALESCE(SUM(o.quantity),0) AS order_quantity,
		b.stock-COALESCE(SUM(o.quantity),0) AS Remaning_quantity
FROM books b
LEFT JOIN orders o ON b.book_id=o.book_id
GROUP BY b.book_id ORDER BY b.book_id;