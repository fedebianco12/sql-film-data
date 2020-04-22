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
