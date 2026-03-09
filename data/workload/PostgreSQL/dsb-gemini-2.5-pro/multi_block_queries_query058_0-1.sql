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
     unioned_sales AS
  (SELECT i.i_item_id,
          c.c_birth_year,
          ss.ss_ext_sales_price AS ss_price,
          0 AS cs_price,
          0 AS ws_price
   FROM store_sales ss
   JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
   AND d.d_month_seq =
     (SELECT ss_month
      FROM month_seqs)
   JOIN item i ON ss.ss_item_sk = i.i_item_sk
   AND i.i_manager_id BETWEEN 28 AND 57
   JOIN customer c ON ss.ss_customer_sk = c.c_customer_sk
   AND c.c_birth_year BETWEEN 1938 AND 1944
   WHERE ss.ss_list_price BETWEEN 269 AND 298
   UNION ALL SELECT i.i_item_id,
                    c.c_birth_year,
                    0,
                    cs.cs_ext_sales_price,
                    0
   FROM catalog_sales cs
   JOIN date_dim d ON cs.cs_sold_date_sk = d.d_date_sk
   AND d.d_month_seq =
     (SELECT cs_month
      FROM month_seqs)
   JOIN item i ON cs.cs_item_sk = i.i_item_sk
   AND i.i_manager_id BETWEEN 28 AND 57
   JOIN customer c ON cs.cs_bill_customer_sk = c.c_customer_sk
   AND c.c_birth_year BETWEEN 1938 AND 1944
   WHERE cs.cs_list_price BETWEEN 269 AND 298
   UNION ALL SELECT i.i_item_id,
                    c.c_birth_year,
                    0,
                    0,
                    ws.ws_ext_sales_price
   FROM web_sales ws
   JOIN date_dim d ON ws.ws_sold_date_sk = d.d_date_sk
   AND d.d_month_seq =
     (SELECT ws_month
      FROM month_seqs)
   JOIN item i ON ws.ws_item_sk = i.i_item_sk
   AND i.i_manager_id BETWEEN 28 AND 57
   JOIN customer c ON ws.ws_bill_customer_sk = c.c_customer_sk
   AND c.c_birth_year BETWEEN 1938 AND 1944
   WHERE ws.ws_list_price BETWEEN 269 AND 298),
     final_rev AS
  (SELECT i_item_id AS item_id,
          c_birth_year AS birth_year,
          SUM(ss_price) AS ss_item_rev,
          SUM(cs_price) AS cs_item_rev,
          SUM(ws_price) AS ws_item_rev
   FROM unioned_sales
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