
SELECT sum(cs.cs_ext_discount_amt) AS "excess discount amount"
FROM catalog_sales cs
JOIN item i ON cs.cs_item_sk = i.i_item_sk
JOIN date_dim d ON cs.cs_sold_date_sk = d.d_date_sk
WHERE (i.i_manufact_id IN (117,
                         306,
                         658,
                         849,
                         891)
       OR i.i_manager_id BETWEEN 28 AND 57)
  AND d.d_date BETWEEN '1999-01-14' AND cast('1999-01-14' AS date) + interval '90 day'
  AND EXISTS
    (SELECT 1
     FROM catalog_sales cs2
     JOIN date_dim d2 ON cs2.cs_sold_date_sk = d2.d_date_sk
     WHERE cs2.cs_item_sk = i.i_item_sk
       AND d2.d_date BETWEEN '1999-01-14' AND cast('1999-01-14' AS date) + interval '90 day'
       AND cs2.cs_list_price BETWEEN 236 AND 265
       AND cs2.cs_sales_price / cs2.cs_list_price BETWEEN 45 * 0.01 AND 65 * 0.01
     GROUP BY cs2.cs_item_sk
     HAVING cs.cs_ext_discount_amt > 1.3 * avg(cs2.cs_ext_discount_amt))
ORDER BY sum(cs.cs_ext_discount_amt)
LIMIT 100;