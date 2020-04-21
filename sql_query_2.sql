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
