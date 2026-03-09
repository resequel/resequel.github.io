WITH frequent_ss_items AS
  (SELECT DISTINCT i_item_sk AS item_sk
   FROM store_sales
   JOIN date_dim ON ss_sold_date_sk = d_date_sk
   JOIN item ON ss_item_sk = i_item_sk
   WHERE d_year = 2001
     AND i_manager_id BETWEEN 77 AND 96
     AND i_category IN ('Books',
                        'Jewelry',
                        'Sports')
   GROUP BY substring(i_item_desc, 1, 30),
            i_item_sk,
            d_date
   HAVING count(*) > 4),
     max_store_sales AS
  (SELECT max(csales) AS tpcds_cmax
   FROM
     (SELECT sum(ss_quantity * ss_sales_price) AS csales
      FROM store_sales
      JOIN customer ON ss_customer_sk = c_customer_sk
      JOIN date_dim ON ss_sold_date_sk = d_date_sk
      WHERE d_year = 2001
        AND ss_wholesale_cost BETWEEN 2 AND 12
      GROUP BY c_customer_sk) tmp1),
     best_ss_customer AS
  (SELECT c_customer_sk
   FROM store_sales
   JOIN customer ON ss_customer_sk = c_customer_sk
   WHERE c_birth_year BETWEEN 1977 AND 1983
   GROUP BY c_customer_sk
   HAVING sum(ss_quantity * ss_sales_price) > (
                                                 (SELECT tpcds_cmax
                                                  FROM max_store_sales) * (95 / 100.0)))
SELECT sum(s.sales)
FROM
  (SELECT cs_quantity*cs_list_price AS sales,
          cs_sold_date_sk AS sold_date_sk,
          cs_item_sk AS item_sk,
          cs_bill_customer_sk AS bill_customer_sk,
          'cs' AS channel,
          cs_wholesale_cost AS wholesale_cost
   FROM catalog_sales
   UNION ALL SELECT ws_quantity*ws_list_price,
                    ws_sold_date_sk,
                    ws_item_sk,
                    ws_bill_customer_sk,
                    'ws' AS channel,
                    ws_wholesale_cost
   FROM web_sales) s
JOIN date_dim d ON s.sold_date_sk = d.d_date_sk
JOIN frequent_ss_items fsi ON s.item_sk = fsi.item_sk
JOIN best_ss_customer bsc ON s.bill_customer_sk = bsc.c_customer_sk
WHERE (s.channel = 'cs'
       AND d.d_year = 2001
       AND d.d_moy = 10
       AND s.wholesale_cost BETWEEN 2 AND 12)
  OR (s.channel = 'ws'
      AND d.d_year = 2001
      AND d.d_moy = 10
      AND s.wholesale_cost BETWEEN 2 AND 12)
LIMIT 100;