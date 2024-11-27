--2.g.ii.2
SELECT stor_name, sum(qty*price) as total_sales
FROM stores
JOIN salesdetail s on stores.stor_id = s.stor_id
JOIN titles t on s.title_id = t.title_id
GROUP BY stor_name;

--2.g.ii.4
SELECT type, title, au_fname, au_lname
FROM titles
JOIN titleauthor ta on titles.title_id = ta.title_id
JOIN authors a on ta.au_id = a.au_id
WHERE price > 20
GROUP BY type, title, au_lname, au_fname;

--2.g.ii.6
SELECT au_fname, au_lname, count(t.title_id) as total_books
FROM authors
LEFT JOIN titleauthor ta on authors.au_id = ta.au_id
LEFT JOIN titles t on ta.title_id = t.title_id AND t.price > 20
GROUP BY au_fname, au_lname
ORDER BY total_books DESC, au_fname, au_lname;

