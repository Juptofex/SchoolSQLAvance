--2.d.ii.1
SELECT avg(price)
FROM titles, publishers
WHERE titles.pub_id = publishers.pub_id
  AND pub_name = 'Algodata Infosystems';

--2.d.ii.2
SELECT au_fname, au_lname, avg(price)
FROM titles, titleauthor, authors
WHERE titles.title_id = titleauthor.title_id
  AND authors.au_id = titleauthor.au_id
GROUP BY au_fname, au_lname;

--2.d.ii.3
SELECT title, price, count(DISTINCT au_id)
FROM publishers, titles, titleauthor
WHERE publishers.pub_id = titles.pub_id
  AND titles.title_id = titleauthor.title_id
  AND pub_name = 'Algodata Infosystems'
GROUP BY title, price;
--or
SELECT title, price, count(DISTINCT au_id)
FROM publishers
JOIN titles ON publishers.pub_id = titles.pub_id
JOIN titleauthor ON titles.title_id = titleauthor.title_id
WHERE pub_name = 'Algodata Infosystems'
GROUP BY title, price;


--2.d.ii.4
SELECT title, price, count(salesdetail.stor_id)
FROM titles, stores, salesdetail
WHERE titles.title_id = salesdetail.title_id
  AND stores.stor_id = salesdetail.stor_id
GROUP BY title, price;
--or
SELECT title, price, count(DISTINCT stor_id)
FROM titles LEFT OUTER JOIN salesdetail ON titles.title_id = salesdetail.title_id
GROUP BY title, price;

--2.d.ii.5
SELECT title
FROM titles, salesdetail
WHERE titles.title_id = salesdetail.title_id
GROUP BY title
HAVING COUNT(DISTINCT salesdetail.stor_id) > 1;

--2.d.ii.6
SELECT type, count(title_id), avg(price)
FROM titles
GROUP BY type;

--2.d.ii.7
SELECT titles.title_id, title, total_sales, sum(qty)
FROM titles, salesdetail
WHERE titles.title_id = salesdetail.title_id
GROUP BY titles.title_id, total_sales;

--2.d.ii.8
SELECT titles.title_id, title, total_sales, sum(qty)
FROM titles, salesdetail
WHERE titles.title_id = salesdetail.title_id
GROUP BY titles.title_id, total_sales
HAVING sum(qty) <> total_sales;

--2.d.ii.9
SELECT title, count(DISTINCT au_id)
FROM titles, titleauthor
WHERE titles.title_id = titleauthor.title_id
GROUP BY title
HAVING count(au_id) > 2;

--2.d.ii.10
SELECT count(titleauthor.title_id)
FROM titleauthor, publishers, salesdetail, stores, authors, titles
WHERE titleauthor.title_id = salesdetail.title_id
  AND titles.pub_id = publishers.pub_id
  AND salesdetail.stor_id = stores.stor_id
  AND authors.au_id = titleauthor.au_id
  AND titles.title_id = titleauthor.title_id
  AND publishers.state = 'CA'
  AND stores.state = 'CA'
  AND authors.state = 'CA';
--or
SELECT count(titleauthor.title_id)
FROM titleauthor
JOIN salesdetail ON titleauthor.title_id = salesdetail.title_id
JOIN titles ON titleauthor.title_id = titles.title_id
JOIN publishers ON titles.pub_id = publishers.pub_id
JOIN stores ON salesdetail.stor_id = stores.stor_id
JOIN authors ON titleauthor.au_id = authors.au_id
WHERE publishers.state = 'CA'
  AND stores.state = 'CA'
  AND authors.state = 'CA';

--2.e.iv.1
SELECT max(price)
FROM titles, publishers
WHERE titles.pub_id = publishers.pub_id
  AND pub_name = 'Algodata Infosystems';

--2.e.iv.3
SELECT title, price
FROM titles ti1
WHERE ti1.price > 1.5 * (SELECT avg(price)
                        FROM titles ti2
                        WHERE ti1.type = ti2.type);

--2.e.iv.5
SELECT pub_name
FROM publishers, titles
WHERE publishers.pub_id = titles.pub_id
GROUP BY pub_name
HAVING count(title) = 0;
--or
SELECT pub_name
FROM publishers
WHERE NOT EXISTS(SELECT *
                 FROM titles
                 WHERE publishers.pub_id = titles.pub_id);

--2.e.iv.6
SELECT pub_name
FROM publishers
WHERE pub_id IN (SELECT pub_id
                 FROM titles
                 GROUP BY pub_id
                 ORDER BY COUNT(title_id) DESC
                 LIMIT 1);

--2.e.iv.7
SELECT pub_name
FROM publishers
WHERE pub_id NOT IN (SELECT pub_id
                     FROM titles);

--2.e.iv.8
SELECT DISTINCT title
FROM titleauthor
JOIN salesdetail ON titleauthor.title_id = salesdetail.title_id
JOIN titles ON titleauthor.title_id = titles.title_id
JOIN publishers ON titles.pub_id = publishers.pub_id
JOIN stores ON salesdetail.stor_id = stores.stor_id
JOIN authors ON titleauthor.au_id = authors.au_id
WHERE publishers.state = 'CA'
  AND stores.state = 'CA'
  AND authors.state = 'CA';

--2.e.iv.9
SELECT DISTINCT title
FROM titles
JOIN salesdetail ON titles.title_id = salesdetail.title_id
JOIN sales ON salesdetail.stor_id = sales.stor_id
WHERE sales.date = (SELECT MAX(sales.date) FROM sales);
