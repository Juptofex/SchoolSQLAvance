--2.b.iv.10
SELECT DISTINCT pub_name
FROM publishers, titles, sales, salesdetail
WHERE titles.pub_id = publishers.pub_id
  AND titles.title_id = salesdetail.title_id
  AND sales.ord_num =salesdetail.ord_num
  AND date > '01-11-1990'
  AND date < '01-03-1991';

--2.b.iv.11
SELECT DISTINCT stor_name
FROM salesdetail, stores, titles
WHERE stores.stor_id = salesdetail.stor_id
  AND titles.title_id = salesdetail.title_id
  AND (title LIKE '%cook%' OR title LIKE '%Cook%');

--2.b.iv.12
SELECT ti1.title, ti2.title
FROM titles ti1,titles ti2, publishers
WHERE publishers.pub_id = ti1.pub_id
  AND publishers.pub_id = ti2.pub_id
  AND ti1.pubdate = ti2.pubdate
  AND ti1.title_id > ti2.title_id;

--2.b.iv.13
SELECT au_fname, au_lname
FROM titles, authors, titleauthor
WHERE titles.title_id = titleauthor.title_id
  AND authors.au_id = titleauthor.au_id
GROUP BY au_fname, au_lname
HAVING count(DISTINCT pub_id) > 1;

--2.b.iv.14
SELECT DISTINCT title
FROM salesdetail, titles, sales
WHERE titles.title_id = salesdetail.title_id
  AND sales.ord_num = salesdetail.ord_num
  AND sales.stor_id = salesdetail.stor_id
  AND pubdate > sales.date;

--2.b.iv.15
SELECT DISTINCT stor_name
FROM stores, salesdetail, titleauthor, authors
WHERE stores.stor_id = salesdetail.stor_id
  AND salesdetail.title_id = titleauthor.title_id
  AND titleauthor.au_id = authors.au_id
  AND au_fname = 'Anne'
  AND au_lname = 'Ringer';

--2.b.iv.16
SELECT DISTINCT authors.state
FROM authors, titleauthor, salesdetail, sales, stores
WHERE authors.au_id = titleauthor.au_id
  AND salesdetail.title_id = titleauthor.title_id
  AND salesdetail.ord_num =sales.ord_num
  AND sales.stor_id = stores.stor_id
  AND date_part('year', date) = '1991'
  AND date_part('month', date) = 02
  AND stores.state = 'CA';

--2.b.iv.17
SELECT DISTINCT st1.stor_name, st2.stor_name
FROM titleauthor ti1, titleauthor ti2, salesdetail sd1, salesdetail sd2, stores st1, stores st2
WHERE  sd1.title_id = ti1.title_id
  AND sd2.title_id = ti2.title_id
  AND st1.stor_id = salesdetail.stor_id
  AND st2.stor_id = salesdetail.stor_id
  AND st1.state = st2.state
  AND st1.stor_id < st2.stor_id;
--A refaire