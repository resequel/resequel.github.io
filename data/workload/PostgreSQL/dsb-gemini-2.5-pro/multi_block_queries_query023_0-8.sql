WITH frequent_dates AS
  (SELECT d_date_sk
   FROM date_dim
   WHERE d_year = 2001),
     frequent_ss_items AS
  (SELECT i_item_sk
   FROM store_sales
   JOIN item ON ss_item_sk = i_item_sk
   WHERE ss_sold_date_sk IN
       (SELECT d_date_sk
        FROM frequent_dates)
     AND i_manager_id BETWEEN 77 AND 96
     AND i_category IN ('Books',
                        'Jewelry',
                        'Sports')
   GROUP BY i_item_sk,
            ss_sold_date_sk,
            substring(i_item_desc, 1, 30)
   HAVING count(*) > 4),
     max_sales_dates AS
  (SELECT d_date_sk
   FROM date_dim
   WHERE d_year = 2001),
     max_store_sales AS
  (SELECT max(csales) tpcds_cmax
   FROM
     (SELECT sum(ss_quantity*ss_sales_price) csales
      FROM store_sales
      WHERE ss_sold_date_sk IN
          (SELECT d_date_sk
           FROM max_sales_dates)
        AND ss_wholesale_cost BETWEEN 2 AND 12
      GROUP BY ss_customer_sk) tmp1),
     best_ss_customer AS
  (SELECT c_customer_sk
   FROM store_sales
   JOIN customer ON ss_customer_sk = c_customer_sk
   WHERE c_birth_year BETWEEN 1977 AND 1983
   GROUP BY c_customer_sk
   HAVING sum(ss_quantity*ss_sales_price) > (95/100.0) *
     (SELECT tpcds_cmax
      FROM max_store_sales))
SELECT sum(sales)
FROM
  (SELECT cs_quantity*cs_list_price sales
   FROM catalog_sales
   JOIN date_dim ON cs_sold_date_sk = d_date_sk
   WHERE d_year = 2001
     AND d_moy = 10
     AND cs_item_sk IN
       (SELECT i_item_sk
        FROM frequent_ss_items)
     AND cs_bill_customer_sk IN
       (SELECT c_customer_sk
        FROM best_ss_customer)
     AND cs_wholesale_cost BETWEEN 2 AND 12
   UNION ALL SELECT ws_quantity*ws_list_price sales
   FROM web_sales
   JOIN date_dim ON ws_sold_date_sk = d_date_sk
   WHERE d_year = 2001
     AND d_moy = 10
     AND ws_item_sk IN
       (SELECT i_item_sk
        FROM frequent_ss_items)
     AND ws_bill_customer_sk IN
       (SELECT c_customer_sk
        FROM best_ss_customer)
     AND ws_wholesale_cost BETWEEN 2 AND 12) tmp2
LIMIT 100;