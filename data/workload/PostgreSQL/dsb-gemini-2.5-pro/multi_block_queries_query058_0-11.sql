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
     all_sales_agg AS
  (SELECT i.i_item_id,
          c.c_birth_year,
          'ss' AS channel,
          SUM(ss.ss_ext_sales_price) AS rev
   FROM store_sales ss
   JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
   JOIN item i ON ss.ss_item_sk = i.i_item_sk
   JOIN customer c ON ss.ss_customer_sk = c.c_customer_sk
   WHERE d.d_month_seq =
       (SELECT ss_month
        FROM month_seqs)
     AND ss.ss_list_price BETWEEN 269 AND 298
     AND i.i_manager_id BETWEEN 28 AND 57
     AND c.c_birth_year BETWEEN 1938 AND 1944
   GROUP BY i.i_item_id,
            c.c_birth_year
   UNION ALL SELECT i.i_item_id,
                    c.c_birth_year,
                    'cs' AS channel,
                    SUM(cs.cs_ext_sales_price) AS rev
   FROM catalog_sales cs
   JOIN date_dim d ON cs.cs_sold_date_sk = d.d_date_sk
   JOIN item i ON cs.cs_item_sk = i.i_item_sk
   JOIN customer c ON cs.cs_bill_customer_sk = c.c_customer_sk
   WHERE d.d_month_seq =
       (SELECT cs_month
        FROM month_seqs)
     AND cs.cs_list_price BETWEEN 269 AND 298
     AND i.i_manager_id BETWEEN 28 AND 57
     AND c.c_birth_year BETWEEN 1938 AND 1944
   GROUP BY i.i_item_id,
            c.c_birth_year
   UNION ALL SELECT i.i_item_id,
                    c.c_birth_year,
                    'ws' AS channel,
                    SUM(ws.ws_ext_sales_price) AS rev
   FROM web_sales ws
   JOIN date_dim d ON ws.ws_sold_date_sk = d.d_date_sk
   JOIN item i ON ws.ws_item_sk = i.i_item_sk
   JOIN customer c ON ws.ws_bill_customer_sk = c.c_customer_sk
   WHERE d.d_month_seq =
       (SELECT ws_month
        FROM month_seqs)
     AND ws.ws_list_price BETWEEN 269 AND 298
     AND i.i_manager_id BETWEEN 28 AND 57
     AND c.c_birth_year BETWEEN 1938 AND 1944
   GROUP BY i.i_item_id,
            c.c_birth_year),
     final_rev AS
  (SELECT i_item_id AS item_id,
          c_birth_year AS birth_year,
          SUM(CASE
                  WHEN channel = 'ss' THEN rev
                  ELSE 0
              END) AS ss_item_rev,
          SUM(CASE
                  WHEN channel = 'cs' THEN rev
                  ELSE 0
              END) AS cs_item_rev,
          SUM(CASE
                  WHEN channel = 'ws' THEN rev
                  ELSE 0
              END) AS ws_item_rev
   FROM all_sales_agg
   GROUP BY i_item_id,
            c_birth_year)
SELECT item_id,
       birth_year,
       ss_item_rev,
       ss_item_rev/((ss_item_rev+cs_item_rev+ws_item_rev)/3) * 100 ss_dev,
                                                                      cs_item_rev,
                                                                      cs_item_rev/((ss_item_rev+cs_item_rev+ws_item_rev)/3) * 100 cs_dev,
                                                                                                                                     ws_item_rev,
                                                                                                                                     ws_item_rev/((ss_item_rev+cs_item_rev+ws_item_rev)/3) * 100 ws_dev,
                                                                                                                                                                                                    (ss_item_rev+cs_item_rev+ws_item_rev)/3 average
FROM final_rev
WHERE ss_item_rev > 0
  AND cs_item_rev > 0
  AND ws_item_rev > 0
  AND ss_item_rev BETWEEN 0.9 * cs_item_rev AND 1.1 * cs_item_rev
  AND ss_item_rev BETWEEN 0.9 * ws_item_rev AND 1.1 * ws_item_rev
  AND cs_item_rev BETWEEN 0.9 * ss_item_rev AND 1.1 * ss_item_rev
  AND cs_item_rev BETWEEN 0.9 * ws_item_rev AND 1.1 * ws_item_rev
  AND ws_item_rev BETWEEN 0.9 * ss_item_rev AND 1.1 * ss_item_rev
  AND ws_item_rev BETWEEN 0.9 * cs_item_rev AND 1.1 * cs_item_rev
ORDER BY item_id,
         birth_year,
         ss_item_rev
LIMIT 100;