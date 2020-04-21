/* Query 1 – Top 10 highest-paying districts */

SELECT		  a.district,
            SUM(p.amount) AS payment_total,
            COUNT(r.*) AS rental_count
  FROM	    address a
            JOIN	customer c
            ON		a.address_id = c.address_id
            JOIN	payment p
            ON		c.customer_id = p.customer_id
            JOIN  rental r
            ON    p.rental_id = r.rental_id
  GROUP BY	1
  ORDER BY	2 DESC
  LIMIT 		10;


/* Query 2 – Amount spent and rentals for 5 most rented film categories */

WITH t1 AS  (
  SELECT        c.category_id,
                c.name AS category,
                COUNT(r.*) AS category_rentals
    FROM        category c
                JOIN  film_category fc
                ON    c.category_id = fc.category_id
                JOIN  film f
                ON    fc.film_id = f.film_id
                JOIN  inventory i
                ON    f.film_id = i.film_id
                JOIN  rental r
                ON    i.inventory_id = r.inventory_id
    GROUP BY    1,2
    ORDER BY    3 DESC
    LIMIT       5)

SELECT          category,
                SUM(p.amount) AS total_spent,
                category_rentals
      FROM      t1
                JOIN  film_category fc
                ON    t1.category_id = fc.category_id
                JOIN  film f
                ON    fc.film_id = f.film_id
                JOIN  inventory i
                ON    f.film_id = i.film_id
                JOIN  rental r
                ON    i.inventory_id = r.inventory_id
                JOIN  payment p
                ON    r.rental_id = p.rental_id
      GROUP BY  1,3
      ORDER BY  2 DESC;

/* Query 3 – What is the average total spent and amount of rentals per decile of customer spenders? */

WITH t1 AS  (
  SELECT      c.customer_id,
              SUM(p.amount) AS total_spent,
              COUNT(r.*) AS rentals
    FROM      customer c
              JOIN rental r
              ON c.customer_id = r.customer_id
              JOIN payment p
              ON r.customer_id = p.customer_id
    GROUP BY  1),

t2 AS       (
  SELECT      total_spent,
              rentals,
              NTILE(10) OVER (ORDER BY total_spent) AS decile
    FROM      t1)

SELECT        DISTINCT decile,
              AVG(total_spent) OVER (PARTITION BY decile) AS avg_spent,
              AVG(rentals) OVER (PARTITION BY decile) AS avg_rentals
    FROM      t2
    ORDER BY  1;

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
