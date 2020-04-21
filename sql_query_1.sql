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
