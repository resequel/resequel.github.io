WITH month_seqs AS
  (SELECT
     (SELECT d_month_seq
      FROM date_dim
      WHERE d_date = '1999-02-11') AS ss_m_seq,

     (SELECT d_month_seq
      FROM date_dim
      WHERE d_date = '1999-02-11') AS cs_m_seq,

     (SELECT d_month_seq
      FROM date_dim
      WHERE d_date = '1999-02-11') AS ws_m_seq),
     ss_items AS
  (SELECT i_item_id item_id,
          c_birth_year birth_year,
          sum(ss_ext_sales_price) ss_item_rev
   FROM store_sales
   JOIN item ON ss_item_sk = i_item_sk
   JOIN date_dim ON ss_sold_date_sk = d_date_sk
   JOIN customer ON ss_customer_sk = c_customer_sk
   JOIN month_seqs ON d_month_seq = month_seqs.ss_m_seq
   WHERE ss_list_price BETWEEN 269 AND 298
     AND i_manager_id BETWEEN 28 AND 57
     AND c_birth_year BETWEEN 1938 AND 1944
   GROUP BY i_item_id,
            c_birth_year),
     cs_items AS
  (SELECT i_item_id item_id,
          c_birth_year birth_year,
          sum(cs_ext_sales_price) cs_item_rev
   FROM catalog_sales
   JOIN item ON cs_item_sk = i_item_sk
   JOIN date_dim ON cs_sold_date_sk = d_date_sk
   JOIN customer ON cs_bill_customer_sk = c_customer_sk
   JOIN month_seqs ON d_month_seq = month_seqs.cs_m_seq
   WHERE cs_list_price BETWEEN 269 AND 298
     AND i_manager_id BETWEEN 28 AND 57
     AND c_birth_year BETWEEN 1938 AND 1944
   GROUP BY i_item_id,
            c_birth_year),
     ws_items AS
  (SELECT i_item_id item_id,
          c_birth_year birth_year,
          sum(ws_ext_sales_price) ws_item_rev
   FROM web_sales
   JOIN item ON ws_item_sk = i_item_sk
   JOIN date_dim ON ws_sold_date_sk = d_date_sk
   JOIN customer ON ws_bill_customer_sk = c_customer_sk
   JOIN month_seqs ON d_month_seq = month_seqs.ws_m_seq
   WHERE ws_list_price BETWEEN 269 AND 298
     AND i_manager_id BETWEEN 28 AND 57
     AND c_birth_year BETWEEN 1938 AND 1944
   GROUP BY i_item_id,
            c_birth_year),
     all_items AS
  (SELECT ss_items.item_id,
          ss_items.birth_year,
          ss_items.ss_item_rev,
          cs_items.cs_item_rev,
          ws_items.ws_item_rev
   FROM ss_items
   JOIN cs_items ON ss_items.item_id = cs_items.item_id
   AND ss_items.birth_year = cs_items.birth_year
   JOIN ws_items ON ss_items.item_id = ws_items.item_id
   AND ss_items.birth_year = ws_items.birth_year
   WHERE ss_items.ss_item_rev BETWEEN 0.9 * cs_items.cs_item_rev AND 1.1 * cs_items.cs_item_rev
     AND ss_items.ss_item_rev BETWEEN 0.9 * ws_items.ws_item_rev AND 1.1 * ws_items.ws_item_rev
     AND cs_items.cs_item_rev BETWEEN 0.9 * ss_items.ss_item_rev AND 1.1 * ss_items.ss_item_rev
     AND cs_items.cs_item_rev BETWEEN 0.9 * ws_items.ws_item_rev AND 1.1 * ws_items.ws_item_rev
     AND ws_items.ws_item_rev BETWEEN 0.9 * ss_items.ss_item_rev AND 1.1 * ss_items.ss_item_rev
     AND ws_items.ws_item_rev BETWEEN 0.9 * cs_items.cs_item_rev AND 1.1 * cs_items.cs_item_rev)
SELECT item_id,
       birth_year,
       ss_item_rev,
       ss_item_rev/((ss_item_rev+cs_item_rev+ws_item_rev)/3) * 100 ss_dev,
                                                                      cs_item_rev,
                                                                      cs_item_rev/((ss_item_rev+cs_item_rev+ws_item_rev)/3) * 100 cs_dev,
                                                                                                                                     ws_item_rev,
                                                                                                                                     ws_item_rev/((ss_item_rev+cs_item_rev+ws_item_rev)/3) * 100 ws_dev,
                                                                                                                                                                                                    (ss_item_rev+cs_item_rev+ws_item_rev)/3 average
FROM all_items
ORDER BY item_id,
         birth_year,
         ss_item_rev
LIMIT 100;