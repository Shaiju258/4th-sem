DROP DATABASE IF EXISTS lab6;

create database lab6;
use lab6;

DROP TABLE IF EXISTS books;

CREATE TABLE books (
    book_id INT IDENTITY(1,1) PRIMARY KEY,
    title VARCHAR(100),
    author_fname VARCHAR(100),
    author_lname VARCHAR(100),
    released_year INT,
    stock_quantity INT,
    pages INT
);

INSERT INTO
    books (
        title,
        author_fname,
        author_lname,
        released_year,
        stock_quantity,
        pages
    )
VALUES
    (
        'The Namesake',
        'Jhumpa',
        'Lahiri',
        2003,
        32,
        291
    ),
    (
        'Norse Mythology',
        'Neil',
        'Gaiman',
        2016,
        43,
        304
    ),
    ('American Gods', 'Neil', 'Gaiman', 2001, 12, 465),
    (
        'Interpreter of Maladies',
        'Jhumpa',
        'Lahiri',
        1996,
        97,
        198
    ),
    (
        'A Hologram for the King: A Novel',
        'Dave',
        'Eggers',
        2012,
        154,
        352
    ),
    ('The Circle', 'Dave', 'Eggers', 2013, 26, 504),
    (
        'The Amazing Adventures of Kavalier & Clay',
        'Michael',
        'Chabon',
        2000,
        68,
        634
    ),
    ('Just Kids', 'Patti', 'Smith', 2010, 55, 304),
    (
        'A Heartbreaking Work of Staggering Genius',
        'Dave',
        'Eggers',
        2001,
        104,
        437
    ),
    ('Coraline', 'Neil', 'Gaiman', 2003, 100, 208),
    (
        'What We Talk About When We Talk About Love: Stories',
        'Raymond',
        'Carver',
        1981,
        23,
        176
    ),
    (
        'Where I''m Calling From: Selected Stories',
        'Raymond',
        'Carver',
        1989,
        12,
        526
    ),
    ('White Noise', 'Don', 'DeLillo', 1985, 49, 320),
    (
        'Cannery Row',
        'John',
        'Steinbeck',
        1945,
        95,
        181
    ),
    (
        'Oblivion: Stories',
        'David',
        'Foster Wallace',
        2004,
        172,
        329
    ),
    (
        'Consider the Lobster',
        'David',
        'Foster Wallace',
        2005,
        92,
        343
    );

select * from books;

select * from books where released_year !=2017;

select * from books where title not like '%e%';


select * from books where released_year >2005;

select * from books where released_year <=1985;

SELECT
    title,
    author_lname,
    released_year
FROM
    books
WHERE
    released_year > 2010
    AND author_lname = 'Eggers'
    AND title LIKE '%novel%';


SELECT
    title,
    pages
FROM
    books
WHERE
    pages < 200
    OR title LIKE '%stories%';

    SELECT
    title,
    released_year
FROM
    books
WHERE
    released_year BETWEEN 2004
    AND 2014;


SELECT
    title,
    author_lname
FROM
    books
WHERE
    author_lname IN ('Carver', 'Lahiri', 'Smith');

SELECT
    title,
    author_lname
FROM
    books
WHERE
    author_lname NOT IN ('Carver', 'Lahiri', 'Smith');

SELECT
    title,
    released_year
FROM
    books
WHERE
    released_year >= 2000
    AND released_year % 2 = 1;

SELECT
    title,
    released_year,
    CASE
        WHEN released_year >= 2000 THEN 'modern literature'
        ELSE '20th century literature'
    END AS genre
FROM
    books;

SELECT
    title,
    stock_quantity,
    CASE
        WHEN stock_quantity <= 40 THEN '*'
        WHEN stock_quantity <= 70 THEN '**'
        WHEN stock_quantity <= 100 THEN '***'
        WHEN stock_quantity <= 140 THEN '****'
        ELSE '*****'
    END AS stock
FROM
    books;



SELECT
    title,
    author_lname,
    CASE
        WHEN title LIKE '%stories%' THEN 'Short Stories'
        WHEN title = 'Just Kids' THEN 'Memoir'
        WHEN title = 'A Heartbreaking Work of Staggering Genius' THEN 'Memior'
        ELSE 'Novel'
    END AS type
FROM
    books;

SELECT
    author_fname,
    author_lname,
    CASE
        WHEN COUNT(*) = 1 THEN '1 book'
        ELSE CONCAT(COUNT(*), ' books')
    END AS count
FROM
    books
WHERE
    author_lname IS NOT NULL
GROUP BY
    author_fname,
    author_lname;