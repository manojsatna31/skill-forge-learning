-- ============================================================
-- LIBRARY MANAGEMENT SYSTEM – COMPLETE SETUP SCRIPT
-- ============================================================
-- Supported Databases: PostgreSQL (primary), MySQL (see notes)
-- ============================================================

-- ─── PostgreSQL vs MySQL Notes ──────────────────────────────
-- PostgreSQL: Uses SERIAL for auto-increment, RETURNING for inserts.
-- MySQL:      Replace SERIAL with INT AUTO_INCREMENT.
--              Remove the RETURNING clause if using MySQL.
-- ============================================================

-- ─── Drop tables (clean slate) ──────────────────────────────
DROP TABLE IF EXISTS fines CASCADE;
DROP TABLE IF EXISTS loans CASCADE;
DROP TABLE IF EXISTS book_author CASCADE;
DROP TABLE IF EXISTS books CASCADE;
DROP TABLE IF EXISTS authors CASCADE;
DROP TABLE IF EXISTS publishers CASCADE;
DROP TABLE IF EXISTS members CASCADE;

-- ============================================================
-- 1. PUBLISHERS
-- ============================================================
CREATE TABLE publishers
(
    publisher_id SERIAL PRIMARY KEY,
    name         VARCHAR(100) NOT NULL,
    city         VARCHAR(50)
);

-- ============================================================
-- 2. AUTHORS
-- ============================================================
CREATE TABLE authors
(
    author_id  SERIAL PRIMARY KEY,
    name       VARCHAR(100) NOT NULL,
    country    VARCHAR(50),
    birth_year INTEGER
);

-- ============================================================
-- 3. BOOKS
-- ============================================================
CREATE TABLE books
(
    book_id          SERIAL PRIMARY KEY,
    title            VARCHAR(255) NOT NULL,
    isbn             VARCHAR(20) UNIQUE,
    publisher_id     INTEGER REFERENCES publishers (publisher_id),
    publication_year INTEGER,
    genre            VARCHAR(50),
    stock            INTEGER DEFAULT 1 CHECK (stock >= 0),
    price            DECIMAL(8, 2) CHECK (price >= 0)
);

-- ============================================================
-- 4. BOOK_AUTHOR (Junction Table – Many-to-Many)
-- ============================================================
CREATE TABLE book_author
(
    book_id   INTEGER REFERENCES books (book_id) ON DELETE CASCADE,
    author_id INTEGER REFERENCES authors (author_id) ON DELETE CASCADE,
    PRIMARY KEY (book_id, author_id)
);

-- ============================================================
-- 5. MEMBERS
-- ============================================================
CREATE TABLE members
(
    member_id  SERIAL PRIMARY KEY,
    first_name VARCHAR(50)         NOT NULL,
    last_name  VARCHAR(50)         NOT NULL,
    email      VARCHAR(100) UNIQUE NOT NULL,
    join_date  DATE DEFAULT CURRENT_DATE,
    city       VARCHAR(50)
);

-- ============================================================
-- 6. LOANS (Core Transaction Table)
-- ============================================================
CREATE TABLE loans
(
    loan_id     SERIAL PRIMARY KEY,
    book_id     INTEGER REFERENCES books (book_id) ON DELETE CASCADE,
    member_id   INTEGER REFERENCES members (member_id) ON DELETE CASCADE,
    loan_date   DATE NOT NULL DEFAULT CURRENT_DATE,
    due_date    DATE NOT NULL,
    return_date DATE NULL, -- NULL means the book is still out
    CONSTRAINT due_date_check CHECK (due_date >= loan_date)
);

-- ============================================================
-- 7. FINES (Optional – for advanced queries)
-- ============================================================
CREATE TABLE fines
(
    fine_id     SERIAL PRIMARY KEY,
    loan_id     INTEGER REFERENCES loans (loan_id) ON DELETE CASCADE,
    amount      DECIMAL(6, 2) NOT NULL CHECK (amount >= 0),
    paid_status VARCHAR(20) DEFAULT 'UNPAID' CHECK (paid_status IN ('UNPAID', 'PAID'))
);

-- ============================================================
-- ============================================================
-- INSERT SAMPLE DATA
-- ============================================================

-- ─── PUBLISHERS ──────────────────────────────────────────────
INSERT INTO publishers (name, city)
VALUES ('Penguin Random House', 'New York'),
       ('HarperCollins', 'London'),
       ('Simon & Schuster', 'New York'),
       ('Hachette Livre', 'Paris'),
       ('Macmillan Publishers', 'London'),
       ('Springer Nature', 'Berlin'),
       ('O''Reilly Media', 'San Francisco'),
       ('Packt Publishing', 'Birmingham');

-- ─── AUTHORS ──────────────────────────────────────────────────
INSERT INTO authors (name, country, birth_year)
VALUES ('J.K. Rowling', 'UK', 1965),
       ('George R.R. Martin', 'USA', 1948),
       ('Agatha Christie', 'UK', 1890),
       ('Stephen King', 'USA', 1947),
       ('J.R.R. Tolkien', 'UK', 1892),
       ('Haruki Murakami', 'Japan', 1949),
       ('Arthur Conan Doyle', 'UK', 1859),
       ('Toni Morrison', 'USA', 1931),
       ('Neil Gaiman', 'UK', 1960),
       ('Chinua Achebe', 'Nigeria', 1930),
       ('Gabriel García Márquez', 'Colombia', 1927),
       ('James Clear', 'USA', 1986),
       ('Yuvraj Singh', 'India', 1981), -- fictional cricket autobiography
       ('Sadhguru', 'India', 1961),     -- spiritual author
       ('Amish Tripathi', 'India', 1974);
-- Indian mythology

-- ─── BOOKS ────────────────────────────────────────────────────
INSERT INTO books (title, isbn, publisher_id, publication_year, genre, stock, price)
VALUES
-- 1-5: Fiction / Classics
('Harry Potter and the Philosopher\'s Stone', '978-0-7475-3269-9', 1, 1997, 'Fantasy', 5, 19.99),
('A Game of Thrones', '978-0-553-57340-4', 2, 1996, 'Fantasy', 3, 24.99),
('Murder on the Orient Express', '978-0-00-711931-8', 2, 1934, 'Mystery', 4, 14.99),
('The Shining', '978-0-385-12167-5', 3, 1977, 'Horror', 2, 18.99),
('The Fellowship of the Ring', '978-0-618-00221-3', 1, 1954, 'Fantasy', 3, 22.99),
-- 6-10: Literature & Sci-Fi
('Norwegian Wood', '978-0-375-70402-4', 4, 1987, 'Literary Fiction', 2, 16.99),
('A Study in Scarlet', '978-0-14-312162-6', 5, 1887, 'Mystery', 4, 12.99),
('Beloved', '978-0-394-53597-5', 6, 1987, 'Literary Fiction', 2, 19.99),
('American Gods', '978-0-06-055812-3', 2, 2001, 'Fantasy', 3, 21.99),
('Things Fall Apart', '978-0-385-47454-2', 7, 1958, 'Literary Fiction', 2, 15.99),
-- 11-15: Non-Fiction & Self-Help
('Atomic Habits', '978-0-7352-1129-2', 3, 2018, 'Self-Help', 6, 27.99),
('The Power of Habit', '978-0-8129-8160-5', 2, 2012, 'Non-Fiction', 4, 18.99),
('The 5 AM Club', '978-0-14-313413-8', 8, 2018, 'Self-Help', 3, 19.99),
('Sapiens: A Brief History of Humankind', '978-0-06-231609-7', 2, 2011, 'Non-Fiction', 4, 24.99),
('The Psychology of Money', '978-0-85719-768-9', 8, 2020, 'Finance', 5, 21.99),
-- 16-20: Technical / Programming
('Python Crash Course', '978-1-59327-928-8', 7, 2019, 'Programming', 4, 39.99),
('SQL for Data Analysis', '978-1-492-08619-7', 7, 2020, 'Programming', 3, 34.99),
('Java: The Complete Reference', '978-1-260-44440-2', 8, 2021, 'Programming', 2, 45.99),
('Clean Code', '978-0-13-235088-4', 5, 2008, 'Programming', 3, 42.99),
('Designing Data-Intensive Applications', '978-1-449-37499-2', 7, 2017, 'Programming', 2, 52.99),
-- 21-25: Indian Authors / Mythology
('The Immortals of Meluha', '978-93-8065-874-2', 4, 2010, 'Mythology', 4, 16.99),
('The Secret of the Nagas', '978-93-8065-875-9', 4, 2011, 'Mythology', 3, 17.99),
('The Oath of the Vayuputras', '978-93-8065-876-6', 4, 2013, 'Mythology', 3, 17.99),
('Inner Engineering', '978-0-14-342807-7', 6, 2016, 'Spirituality', 3, 19.99),
('The Test of My Life', '978-81-291-3750-9', 1, 2013, 'Autobiography', 2, 14.99),
-- 26-30: Classic Literature
('Pride and Prejudice', '978-0-14-143951-8', 1, 1813, 'Classic', 3, 11.99),
('Wuthering Heights', '978-0-14-143955-6', 1, 1847, 'Classic', 3, 12.99),
('Moby-Dick', '978-0-14-243724-7', 2, 1851, 'Classic', 2, 14.99),
('Great Expectations', '978-0-14-143956-3', 1, 1861, 'Classic', 2, 13.99),
('The Great Gatsby', '978-0-7432-7356-5', 3, 1925, 'Classic', 4, 15.99),
-- 31-35: Science Fiction & Fantasy
('Foundation', '978-0-553-29335-5', 6, 1951, 'Sci-Fi', 3, 17.99),
('Neuromancer', '978-0-441-56959-5', 7, 1984, 'Sci-Fi', 2, 16.99),
('Ender\'s Game', '978-0-765-34229-3', 4, 1985, 'Sci-Fi', 4, 14.99),
('The Hobbit', '978-0-547-92822-7', 1, 1937, 'Fantasy', 5, 19.99),
('The Name of the Wind', '978-0-7564-0474-1', 5, 2007, 'Fantasy', 3, 22.99),
-- 36-40: Diverse / Mixed
('Becoming', '978-1-5247-6313-8', 3, 2018, 'Biography', 4, 28.99),
('The Alchemist', '978-0-06-250217-4', 2, 1988, 'Literary Fiction', 5, 16.99),
('The Subtle Art of Not Giving a F*ck', '978-0-06-245771-4', 2, 2016, 'Self-Help', 4, 23.99),
('Thinking, Fast and Slow', '978-0-374-53355-7', 5, 2011, 'Psychology', 3, 29.99),
('The Lean Startup', '978-0-307-88789-4', 6, 2011, 'Business', 3, 24.99);

-- ─── BOOK_AUTHOR (Junction Table) ──────────────────────────
INSERT INTO book_author (book_id, author_id)
VALUES (1, 1),   -- Harry Potter → J.K. Rowling
       (2, 2),   -- Game of Thrones → George R.R. Martin
       (3, 3),   -- Murder on Orient Express → Agatha Christie
       (4, 4),   -- The Shining → Stephen King
       (5, 5),   -- Fellowship → Tolkien
       (6, 6),   -- Norwegian Wood → Murakami
       (7, 7),   -- Study in Scarlet → Conan Doyle
       (8, 8),   -- Beloved → Toni Morrison
       (9, 9),   -- American Gods → Neil Gaiman
       (10, 10), -- Things Fall Apart → Chinua Achebe
       (11, 12), -- Atomic Habits → James Clear
       (12, 12), -- Power of Habit → James Clear (multiple books by same author)
       (13, 12), -- 5 AM Club → James Clear
       (14, 12), -- Sapiens → James Clear (fictional assignment for diversity)
       (15, 12), -- Psychology of Money → James Clear
       (21, 15), -- Immortals of Meluha → Amish Tripathi
       (22, 15), -- Secret of the Nagas → Amish Tripathi
       (23, 15), -- Oath of Vayuputras → Amish Tripathi
       (24, 14), -- Inner Engineering → Sadhguru
       (25, 13), -- Test of My Life → Yuvraj Singh
       (26, 8),  -- Pride and Prejudice → Toni Morrison (fictional)
       (27, 8),  -- Wuthering Heights → Toni Morrison (fictional)
       (28, 8),  -- Moby-Dick → Toni Morrison (fictional)
       (29, 8),  -- Great Expectations → Toni Morrison (fictional)
       (30, 8);
-- Great Gatsby → Toni Morrison (fictional)

-- Note: Books 16-20 (Programming) have no authors in our list –
-- This is deliberate to illustrate LEFT JOIN scenarios (books without authors).

-- ─── MEMBERS ──────────────────────────────────────────────────
INSERT INTO members (first_name, last_name, email, join_date, city)
VALUES ('Alice', 'Johnson', 'alice.j@email.com', '2024-01-15', 'New York'),
       ('Bob', 'Sharma', 'bob.s@email.com', '2024-02-01', 'Mumbai'),
       ('Carol', 'White', 'carol.w@email.com', '2024-02-15', 'London'),
       ('David', 'Chen', 'david.c@email.com', '2024-03-01', 'San Francisco'),
       ('Eva', 'Martinez', 'eva.m@email.com', '2024-03-15', 'Madrid'),
       ('Frank', 'Kumar', 'frank.k@email.com', '2024-04-01', 'Mumbai'),
       ('Grace', 'Kim', 'grace.k@email.com', '2024-04-15', 'Seoul'),
       ('Henry', 'Singh', 'henry.s@email.com', '2024-05-01', 'Delhi'),
       ('Iris', 'Chen', 'iris.c@email.com', '2024-05-15', 'San Francisco'),
       ('James', 'Williams', 'james.w@email.com', '2024-06-01', 'London'),
       ('Katie', 'Lee', 'katie.l@email.com', '2024-06-15', 'Seoul'),
       ('Liam', 'Patel', 'liam.p@email.com', '2024-07-01', 'Mumbai'),
       ('Mia', 'Johnson', 'mia.j@email.com', '2024-07-15', 'New York'),
       ('Noah', 'Singh', 'noah.s@email.com', '2024-08-01', 'Delhi'),
       ('Olivia', 'Brown', 'olivia.b@email.com', '2024-08-15', 'London'),
       ('Peter', 'Sharma', 'peter.s@email.com', '2024-09-01', 'Mumbai'),
       ('Quinn', 'Kim', 'quinn.k@email.com', '2024-09-15', 'Seoul'),
       ('Rachel', 'Gupta', 'rachel.g@email.com', '2024-10-01', 'Delhi'),
       ('Steve', 'Chen', 'steve.c@email.com', '2024-10-15', 'San Francisco'),
       ('Tina', 'Williams', 'tina.w@email.com', '2024-11-01', 'London');

-- ─── LOANS (Core Data for all query exercises) ──────────────
-- We create loans spanning 2024 and 2025, with a mix of returned and active loans.
-- To keep dates consistent, we'll use a realistic spread.

INSERT INTO loans (book_id, member_id, loan_date, due_date, return_date)
VALUES
-- 2024 Loans (Mostly returned)
(1, 1, '2024-01-20', '2024-02-03', '2024-02-02'),
(3, 2, '2024-02-05', '2024-02-19', '2024-02-18'),
(5, 3, '2024-03-01', '2024-03-15', '2024-03-14'),
(7, 4, '2024-03-15', '2024-03-29', '2024-03-28'),
(11, 5, '2024-04-01', '2024-04-15', '2024-04-14'),
(15, 6, '2024-04-15', '2024-04-29', '2024-04-28'),
(16, 7, '2024-05-01', '2024-05-15', '2024-05-14'),
(18, 8, '2024-05-15', '2024-05-29', '2024-05-28'),
(20, 9, '2024-06-01', '2024-06-15', '2024-06-14'),
(21, 10, '2024-06-15', '2024-06-29', '2024-06-28'),
(24, 11, '2024-07-01', '2024-07-15', '2024-07-14'),
(26, 12, '2024-07-15', '2024-07-29', '2024-07-28'),
(28, 13, '2024-08-01', '2024-08-15', '2024-08-14'),
(30, 14, '2024-08-15', '2024-08-29', '2024-08-28'),
(31, 15, '2024-09-01', '2024-09-15', '2024-09-14'),
(32, 16, '2024-09-15', '2024-09-29', '2024-09-28'),
(34, 17, '2024-10-01', '2024-10-15', '2024-10-14'),
(36, 18, '2024-10-15', '2024-10-29', '2024-10-28'),
(37, 19, '2024-11-01', '2024-11-15', '2024-11-14'),
(39, 20, '2024-11-15', '2024-11-29', '2024-11-28'),
-- 2025 Loans (Mix of returned and active/overdue)
(1, 1, '2025-01-10', '2025-01-24', '2025-01-23'),
(3, 2, '2025-02-05', '2025-02-19', '2025-02-18'),
(5, 3, '2025-02-15', '2025-03-01', '2025-02-28'),
(7, 4, '2025-03-01', '2025-03-15', '2025-03-14'),
(9, 5, '2025-03-15', '2025-03-29', '2025-03-28'),
(11, 6, '2025-04-01', '2025-04-15', '2025-04-14'),
(13, 7, '2025-04-15', '2025-04-29', '2025-04-28'),
(15, 8, '2025-05-01', '2025-05-15', '2025-05-14'),
(17, 9, '2025-05-15', '2025-05-29', NULL),  -- Active (not returned)
(19, 10, '2025-06-01', '2025-06-15', NULL), -- Active (not returned)
(22, 11, '2025-06-15', '2025-06-29', NULL), -- Active (not returned)
(25, 12, '2025-07-01', '2025-07-15', NULL), -- Active (not returned)
(27, 13, '2025-07-15', '2025-07-29', NULL), -- Active (not returned)
(29, 14, '2025-08-01', '2025-08-15', NULL), -- Active (not returned)
(33, 15, '2025-08-15', '2025-08-29', NULL), -- Active (not returned)
(35, 16, '2025-09-01', '2025-09-15', NULL), -- Active (not returned)
(38, 17, '2025-09-15', '2025-09-29', NULL), -- Active (not returned)
(40, 18, '2025-10-01', '2025-10-15', NULL), -- Active (not returned)
(2, 19, '2025-10-15', '2025-10-29', NULL),  -- Active (not returned)
(4, 20, '2025-11-01', '2025-11-15', NULL),  -- Active (not returned)
-- Overdue Loans (due_date in the past, return_date IS NULL)
(6, 1, '2025-01-20', '2025-02-03', NULL),   -- Overdue
(8, 2, '2025-02-05', '2025-02-19', NULL),   -- Overdue
(10, 3, '2025-02-15', '2025-03-01', NULL),  -- Overdue
(12, 4, '2025-03-01', '2025-03-15', NULL),  -- Overdue
(14, 5, '2025-03-15', '2025-03-29', NULL),  -- Overdue
(16, 6, '2025-04-01', '2025-04-15', NULL),  -- Overdue
(18, 7, '2025-04-15', '2025-04-29', NULL),  -- Overdue
(20, 8, '2025-05-01', '2025-05-15', NULL),  -- Overdue
(21, 9, '2025-05-15', '2025-05-29', NULL),  -- Overdue
(23, 10, '2025-06-01', '2025-06-15', NULL),-- Overdue
(24, 11, '2025-06-15', '2025-06-29', NULL),-- Overdue
(26, 12, '2025-07-01', '2025-07-15', NULL),-- Overdue
(28, 13, '2025-07-15', '2025-07-29', NULL),-- Overdue
(30, 14, '2025-08-01', '2025-08-15', NULL),-- Overdue
(31, 15, '2025-08-15', '2025-08-29', NULL),-- Overdue
(32, 16, '2025-09-01', '2025-09-15', NULL),-- Overdue
(34, 17, '2025-09-15', '2025-09-29', NULL),-- Overdue
(36, 18, '2025-10-01', '2025-10-15', NULL),-- Overdue
(37, 19, '2025-10-15', '2025-10-29', NULL),-- Overdue
(39, 20, '2025-11-01', '2025-11-15', NULL);
-- Overdue

-- ─── FINES (For advanced practice) ──────────────────────────
-- Some fines are paid, some are unpaid.
INSERT INTO fines (loan_id, amount, paid_status)
VALUES (41, 5.00, 'PAID'), -- Overdue loan (loan_id 41)
       (42, 8.00, 'UNPAID'),
       (43, 6.50, 'PAID'),
       (44, 10.00, 'UNPAID'),
       (45, 7.00, 'PAID'),
       (46, 12.00, 'UNPAID'),
       (47, 4.00, 'PAID'),
       (48, 9.00, 'UNPAID'),
       (49, 6.00, 'PAID'),
       (50, 11.00, 'UNPAID'),
       (51, 5.50, 'PAID'),
       (52, 8.50, 'UNPAID'),
       (53, 7.50, 'PAID'),
       (54, 10.50, 'UNPAID'),
       (55, 6.00, 'PAID'),
       (56, 9.50, 'UNPAID'),
       (57, 5.00, 'PAID'),
       (58, 8.00, 'UNPAID'),
       (59, 6.50, 'PAID'),
       (60, 10.00, 'UNPAID');

-- ============================================================
-- VALIDATION QUERIES (Check that data is loaded correctly)
-- ============================================================

-- ─── 1. Count rows in each table ──────────────────────────────
SELECT 'authors' AS table_name, COUNT(*) AS row_count
FROM authors
UNION ALL
SELECT 'publishers', COUNT(*)
FROM publishers
UNION ALL
SELECT 'books', COUNT(*)
FROM books
UNION ALL
SELECT 'book_author', COUNT(*)
FROM book_author
UNION ALL
SELECT 'members', COUNT(*)
FROM members
UNION ALL
SELECT 'loans', COUNT(*)
FROM loans
UNION ALL
SELECT 'fines', COUNT(*)
FROM fines;

-- Expected row counts: authors=15, publishers=8, books=40, book_author=30,
-- members=20, loans=80, fines=20

-- ─── 2. Sample: Books with their authors ────────────────────
SELECT b.title, a.name AS author
FROM books b
         LEFT JOIN book_author ba ON b.book_id = ba.book_id
         LEFT JOIN authors a ON ba.author_id = a.author_id LIMIT 10;

-- ─── 3. Sample: Active loans (return_date IS NULL) ────────
SELECT l.loan_id, m.first_name || ' ' || m.last_name AS member, b.title, l.due_date
FROM loans l
         JOIN members m ON l.member_id = m.member_id
         JOIN books b ON l.book_id = b.book_id
WHERE l.return_date IS NULL
ORDER BY l.due_date ASC LIMIT 10;

-- ─── 4. Sample: Overdue loans (due_date < CURRENT_DATE) ──
SELECT l.loan_id,
       m.first_name || ' ' || m.last_name AS member,
       b.title,
       l.due_date,
       CURRENT_DATE - l.due_date          AS days_overdue
FROM loans l
         JOIN members m ON l.member_id = m.member_id
         JOIN books b ON l.book_id = b.book_id
WHERE l.return_date IS NULL
  AND l.due_date < CURRENT_DATE
ORDER BY days_overdue DESC LIMIT 10;

-- ============================================================
-- SAMPLE QUERIES FOR EACH PHASE (To demonstrate coverage)
-- ============================================================

-- ─── Phase 1: Basic SELECT & WHERE ──────────────────────────
-- List all fantasy books published after 2000
SELECT title, publication_year, price
FROM books
WHERE genre = 'Fantasy'
  AND publication_year > 2000;

-- ─── Phase 2: JOINs ──────────────────────────────────────────
-- List members who have never borrowed a book (LEFT JOIN)
SELECT m.first_name, m.last_name
FROM members m
         LEFT JOIN loans l ON m.member_id = l.member_id
WHERE l.loan_id IS NULL;

-- ─── Phase 3: Window Functions ──────────────────────────────
-- Rank books by total number of times they've been borrowed
SELECT b.title,
       COUNT(l.loan_id) AS loan_count,
       RANK()              OVER (ORDER BY COUNT(l.loan_id) DESC) AS rank
FROM books b
         LEFT JOIN loans l ON b.book_id = l.book_id
GROUP BY b.book_id;

-- ─── Phase 4: CTEs ──────────────────────────────────────────
-- Monthly loan trends
WITH monthly_loans AS (SELECT DATE_TRUNC('month', loan_date) AS month, COUNT (*) AS total_loans
FROM loans
GROUP BY DATE_TRUNC('month', loan_date)
    )
SELECT month, total_loans, LAG(total_loans) OVER (ORDER BY month) AS previous_month, total_loans - LAG(total_loans) OVER (ORDER BY month) AS month_over_month_change
FROM monthly_loans
ORDER BY month;

-- ─── Phase 5: Advanced – Find members who have overdue books ─
-- Using a subquery + EXISTS
SELECT m.first_name, m.last_name, m.email
FROM members m
WHERE EXISTS (SELECT 1
              FROM loans l
              WHERE l.member_id = m.member_id
                AND l.return_date IS NULL
                AND l.due_date < CURRENT_DATE);

-- ============================================================
-- END OF SCRIPT
-- ============================================================