WITH month_seqs AS
  (SELECT
     (SELECT d_month_seq
      FROM date_dim
      WHERE d_date = '1999-02-11') AS ss_month,

     (SELECT d_month_seq
      FROM date_dim
      WHERE d_date = '1999-02-11') AS cs_month,

     (SELECT d_month_seq
      FROM date_dim
      WHERE d_date = '1999-02-11') AS ws_month),
     f_cust_ss AS
  (SELECT c_customer_sk,
          c_birth_year
   FROM customer
   WHERE c_birth_year BETWEEN 1938 AND 1944),
     f_cust_cs AS
  (SELECT c_customer_sk,
          c_birth_year
   FROM customer
   WHERE c_birth_year BETWEEN 1938 AND 1944),
     f_cust_ws AS
  (SELECT c_customer_sk,
          c_birth_year
   FROM customer
   WHERE c_birth_year BETWEEN 1938 AND 1944),
     ss_items AS
  (SELECT i.i_item_id AS item_id,
          c.c_birth_year AS birth_year,
          sum(ss.ss_ext_sales_price) AS ss_item_rev
   FROM store_sales ss
   JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
   JOIN item i ON ss.ss_item_sk = i.i_item_sk
   JOIN f_cust_ss c ON ss.ss_customer_sk = c.c_customer_sk
   WHERE d.d_month_seq =
       (SELECT ss_month
        FROM month_seqs)
     AND ss.ss_list_price BETWEEN 269 AND 298
     AND i.i_manager_id BETWEEN 28 AND 57
   GROUP BY i.i_item_id,
            c.c_birth_year),
     cs_items AS
  (SELECT i.i_item_id AS item_id,
          c.c_birth_year AS birth_year,
          sum(cs.cs_ext_sales_price) AS cs_item_rev
   FROM catalog_sales cs
   JOIN date_dim d ON cs.cs_sold_date_sk = d.d_date_sk
   JOIN item i ON cs.cs_item_sk = i.i_item_sk
   JOIN f_cust_cs c ON cs.cs_bill_customer_sk = c.c_customer_sk
   WHERE d.d_month_seq =
       (SELECT cs_month
        FROM month_seqs)
     AND cs.cs_list_price BETWEEN 269 AND 298
     AND i.i_manager_id BETWEEN 28 AND 57
   GROUP BY i.i_item_id,
            c.c_birth_year),
     ws_items AS
  (SELECT i.i_item_id AS item_id,
          c.c_birth_year AS birth_year,
          sum(ws.ws_ext_sales_price) AS ws_item_rev
   FROM web_sales ws
   JOIN date_dim d ON ws.ws_sold_date_sk = d.d_date_sk
   JOIN item i ON ws.ws_item_sk = i.i_item_sk
   JOIN f_cust_ws c ON ws.ws_bill_customer_sk = c.c_customer_sk
   WHERE d.d_month_seq =
       (SELECT ws_month
        FROM month_seqs)
     AND ws.ws_list_price BETWEEN 269 AND 298
     AND i.i_manager_id BETWEEN 28 AND 57
   GROUP BY i.i_item_id,
            c.c_birth_year)
SELECT ss_items.item_id,
       ss_items.birth_year,
       ss_item_rev,
       ss_item_rev/((ss_item_rev+cs_item_rev+ws_item_rev)/3) * 100 ss_dev,
                                                                      cs_item_rev,
                                                                      cs_item_rev/((ss_item_rev+cs_item_rev+ws_item_rev)/3) * 100 cs_dev,
                                                                                                                                     ws_item_rev,
                                                                                                                                     ws_item_rev/((ss_item_rev+cs_item_rev+ws_item_rev)/3) * 100 ws_dev,
                                                                                                                                                                                                    (ss_item_rev+cs_item_rev+ws_item_rev)/3 average
FROM ss_items
JOIN cs_items ON ss_items.item_id = cs_items.item_id
AND ss_items.birth_year = cs_items.birth_year
JOIN ws_items ON ss_items.item_id = ws_items.item_id
AND ss_items.birth_year = ws_items.birth_year
WHERE ss_item_rev BETWEEN 0.9 * cs_item_rev AND 1.1 * cs_item_rev
  AND ss_item_rev BETWEEN 0.9 * ws_item_rev AND 1.1 * ws_item_rev
  AND cs_item_rev BETWEEN 0.9 * ss_item_rev AND 1.1 * ss_item_rev
  AND cs_item_rev BETWEEN 0.9 * ws_item_rev AND 1.1 * ws_item_rev
  AND ws_item_rev BETWEEN 0.9 * ss_item_rev AND 1.1 * ss_item_rev
  AND ws_item_rev BETWEEN 0.9 * cs_item_rev AND 1.1 * cs_item_rev
ORDER BY item_id,
         birth_year,
         ss_item_rev
LIMIT 100;