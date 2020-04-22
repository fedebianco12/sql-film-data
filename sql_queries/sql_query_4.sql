/* Query 4 — How many films are there per category for the top 25% longest family films? */

WITH t1 AS  (
  SELECT  f.title,
          c.name AS category,
          f.rental_duration,
          NTILE(4) OVER (ORDER BY f.rental_duration) AS length_category
    FROM  film f
          JOIN film_category fc
          ON f.film_id = fc.film_id
          JOIN category c
          ON fc.category_id = c.category_id
    WHERE c.name = 'Animation'
    OR    c.name = 'Children'
    OR    c.name = 'Classics'
    OR    c.name = 'Comedy'
    OR    c.name = 'Family'
    OR    c.name = 'Music')

SELECT      category,
            length_category,
            COUNT(title)
  FROM      t1
  WHERE     length_category = 1
  GROUP BY  1,2
  ORDER BY  1,2;
