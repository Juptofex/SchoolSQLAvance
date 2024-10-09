--2.a.ii.1
SELECT au_lname, au_fname FROM authors WHERE city = 'Oakland';

--2.a.ii.2
SELECT au_lname, au_fname, address FROM authors WHERE au_fname LIKE 'A%';

--2.a.ii.3
SELECT au_lname, au_fname, address, city, state, country FROM authors WHERE phone IS NULL;

--2.a.ii.4
SELECT au_lname, au_fname FROM authors WHERE state = 'CA' AND phone NOT LIKE '415%';

--2.a.ii.5
SELECT au_lname, au_fname FROM authors WHERE country = 'BEL' OR country = 'LUX' OR country = 'NET';

--2.a.ii.6
SELECT DISTINCT titles.pub_id FROM titles WHERE titles.type = 'psychology';

--2.a.ii.7
SELECT DISTINCT titles.pub_id FROM titles WHERE titles.type = 'psychology' AND price < 10 OR price > 25;

--2.a.ii.8
SELECT DISTINCT city FROM authors WHERE state = 'CA' AND au_fname = 'Albert' OR au_lname LIKE '%er';

--2.a.ii.9
SELECT state, country FROM authors WHERE state IS NOT NULL AND country != 'USA';

--2.a.ii.10
SELECT DISTINCT type FROM titles WHERE price < 15;

--2.b.iv.1
SELECT title, price, pub_name FROM titles, publishers WHERE publishers.pub_id = titles.pub_id;

--2.b.iv.2
SELECT title, price, pub_name FROM titles, publishers WHERE publishers.pub_id = titles.pub_id AND type = 'psychology';

--2.b.iv.3
SELECT DISTINCT au_lname, au_fname FROM titleauthor, authors, titles WHERE titles.title_id = titleauthor.title_id AND authors.au_id = titleauthor.au_id;

--2.b.iv.4
SELECT DISTINCT state FROM titleauthor, authors, titles WHERE titles.title_id = titleauthor.title_id AND authors.au_id = titleauthor.au_id;

--2.b.iv.5
SELECT stor_name FROM sales, stores WHERE sales.stor_id = stores.stor_id AND date_part('year', date) = 1991 AND date_part('month', date) = 11;

--2.b.iv.6
SELECT title FROM titles, publishers WHERE publishers.pub_id  = titles.pub_id AND type = 'psychology' AND price < 20 AND pub_name NOT like 'Algo%';

--2.b.iv.7
SELECT DISTINCT title FROM titles, authors, titleauthor WHERE titles.title_id = titleauthor.title_id AND authors.au_id = titleauthor.au_id AND state = 'CA';

--2.b.iv.8
SELECT DISTINCT au_lname, au_fname FROM titles, authors, titleauthor, publishers WHERE titles.title_id = titleauthor.title_id AND authors.au_id = titleauthor.au_id AND titles.pub_id = publishers.pub_id AND publishers.state = 'CA';

--2.b.iv.9
SELECT DISTINCT au_lname, au_fname FROM titles, authors, titleauthor, publishers WHERE titles.title_id = titleauthor.title_id AND authors.au_id = titleauthor.au_id AND titles.pub_id = publishers.pub_id AND publishers.state = authors.state;