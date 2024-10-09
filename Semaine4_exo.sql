--2.e.iv.11
SELECT DISTINCT authors.city
FROM authors, stores
WHERE authors.state = 'CA'
  AND authors.city NOT IN (SELECT city
                           FROM stores);

--2.e.iv.12
SELECT pub_name
FROM publishers
JOIN titles t on publishers.pub_id = t.pub_id
JOIN titleauthor ta on t.title_id = ta.title_id
JOIN authors a on ta.au_id = a.au_id
GROUP BY pub_name
ORDER BY count(*) DESC
LIMIT 1;

--2.e.iv.13
SELECT DISTINCT title
FROM titles
JOIN titleauthor ta on titles.title_id = ta.title_id
JOIN authors a on ta.au_id = a.au_id
WHERE a.state = 'CA';

--2.e.iv.15
SELECT title
FROM titles
JOIN titleauthor ta on titles.title_id = ta.title_id
GROUP BY title
HAVING count(ta.au_id) = 1;

--2.e.iv.16
SELECT title
FROM titles
JOIN titleauthor ta on titles.title_id = ta.title_id
JOIN authors a on a.au_id = ta.au_id
WHERE a.state = 'CA'
GROUP BY title
HAVING count(ta.au_id) = 1;