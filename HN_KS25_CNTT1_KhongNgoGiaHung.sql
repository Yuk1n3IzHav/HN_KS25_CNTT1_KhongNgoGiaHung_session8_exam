CREATE DATABASE BookStoreDB;
USE BookStoreDB;

CREATE TABLE Category (
	category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL,
    description VARCHAR(255)
);

CREATE TABLE Book (
	book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(150) NOT NULL,
	status INT DEFAULT 1,
    publish_date DATE, 
    price DECIMAL(15,2),
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES Category(category_id)
);

CREATE TABLE BookOrder (
	order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100) NOT NULL,
    book_id INT,
    order_date DATE DEFAULT (CURRENT_DATE),
    delivery_date DATE,
    FOREIGN KEY (book_id) REFERENCES Book(book_id) ON DELETE CASCADE
);

ALTER TABLE Book
ADD author_name VARCHAR(100) NOT NULL DEFAULT 'Unknown'
AFTER category_id;

ALTER TABLE BookOrder
MODIFY customer_name VARCHAR(200);

INSERT INTO Category(category_name, description) VALUES
('IT & Tech', 'Sách lập trình'),
('Business', 'Sách kinh doanh'),
('Novel', 'Tiểu thuyết');

INSERT INTO Book(title, status, publish_date, price, category_id, author_name) VALUES
('Clean Code', 1 ,'2020-05-10', 500000, 1, 'Robert C.Martin'),
('Đắc Nhân Tâm', 0, '2018-08-20', 150000, 2, 'Dale Carnegie'),
('JavaScript Nâng cao', 1 ,'2023-01-15', 350000, 1, 'Kyle Simpson'),
('Nhà Giả Kim', 0, '2015-11-25', 120000, 3, 'Paulo Coelho');

INSERT INTO BookOrder(order_id, customer_name, book_id, order_date, delivery_date) VALUES
(101, 'Nguyen Hai Nam', 1, '2025-01-10', '2025-01-15'),
(102, 'Tran Bao Ngoc', 3, '2025-02-05', '2025-02-10'),
(103, 'Le Hoang Yen', 4, '2025-03-12', NULL);

UPDATE Book 
SET price = price + 50000
WHERE category_id = 1;

UPDATE BookOrder
SET delivery_date = '2025-12-31'
WHERE delivery_date IS NULL;

DELETE FROM BookOrder 
WHERE order_date < '2025-02-01';

SELECT title, author_name, 
CASE
	WHEN status = 1 THEN 'Còn hàng'
    ELSE 'Hết hàng'
END AS status_name
FROM Book;
    
SELECT 
    UPPER(title) AS Title_Uppercase,
    DATEDIFF(NOW(), publish_date) AS Years_Since_Published
FROM Book;

SELECT b.title, b.price, c.category_name
FROM Book b
JOIN Category c
ON b.category_id = c.category_id;

SELECT * FROM Book
ORDER BY price DESC
LIMIT 2;

SELECT category_id, COUNT(*) AS SoLuongSach
FROM Book
GROUP BY category_id
HAVING COUNT(*) >= 2;

SELECT * FROM Book
WHERE price > (SELECT AVG(price) FROM Book);

SELECT *
FROM Book
WHERE book_id IN (
    SELECT DISTINCT book_id
    FROM BookOrder
);

SELECT s1.book_id, s1.title, s1.category_id, s1.price
FROM Book s1
WHERE s1.price = (
    SELECT MAX(s2.price)
    FROM Book s2
    WHERE s2.category_id = s1.category_id
);
