-- Library Database
--Tables: books, members, loans

-- Table Definitions

CREATE TABLE books (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    author TEXT, NOT NULL,
    genre TEXT,
    available BOOLEAN DEFAULT true
);

CREATE TABLE members (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE 
);

CREATE TABLE loans (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    book_id INTEGER NOT NULL,
    member_id INTEGER NOT NULL,
    checkout_date DATE DEFAULT (date('now')),
    return_date DATE,
    returned BOOLEAN DEFAULT false,
    FOREIGN KEY (book_id) REFERENCES books(id),
    FOREIGN KEY (member_id) REFERENCES members(id)
);

-- SAMPLE DATA 

INSERT INTO books (title, author, genre) VALUES
('Book Title,   Book Author,    Book Genre');

INSERT INTO members (name, email) VALUES
('Member Name,  Member Email');

INSERT INTO loans (book_id, member_id) VALUES
(1,1),
(3,2);
UPDATE books SET available = false WHERE id IN (1, 3);

-- QUERIES

-- 1. View all books
SELECT * FROM books;

-- 2. View all availble books
SELECT id, title, author, genre
FROM books
WHERE available = true;

--3. View all members 
SELECT * FROM members; 

--4. View active loans (JOIN across all 3 tables)
SELECT
loans.id        AS loan_id,
members,name    AS member,
books.title     AS book,
loans.checkout_date
FROM loans
JOIN members ON loans.member_id = members.id
JOIN books ON loans.book_id = books.id
WHERE loans.returned = false;

--5. Return a book (marks loan returned, book available)
UPDATE loans SET returned = true, return_date = date('now') WHERE id = 1;
UPDATE books SET returned = true WHERE id = 1;

--6. Count books by genre
SELECT genre, COUNT(*) AS total
FROM books
GROUP BY genre 
ORDER BY total DESC;

--7. Delete a member (only if no active loans)
DELETE FROM members WHERE id = 3;