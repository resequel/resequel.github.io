WITH frequent_ss_items AS
  (SELECT substring(i_item_desc, 1, 30) itemdesc,
          i_item_sk item_sk,
          d_date solddate,
          count(*) cnt
   FROM store_sales,
        date_dim,
        item
   WHERE ss_sold_date_sk = d_date_sk
     AND ss_item_sk = i_item_sk
     AND d_year = 2001
     AND i_manager_id BETWEEN 77 AND 96
     AND i_category IN ('Books',
                        'Jewelry',
                        'Sports')
   GROUP BY substring(i_item_desc, 1, 30),
            i_item_sk,
            d_date
   HAVING count(*) >4),
     max_store_sales AS
  (SELECT max(csales) tpcds_cmax
   FROM
     (SELECT c_customer_sk,
             sum(ss_quantity*ss_sales_price) csales
      FROM store_sales,
           customer,
           date_dim
      WHERE ss_customer_sk = c_customer_sk
        AND ss_sold_date_sk = d_date_sk
        AND d_year = 2001
        AND ss_wholesale_cost BETWEEN 2 AND 12
      GROUP BY c_customer_sk) tmp1),
     best_ss_customer AS
  (SELECT c_customer_sk
   FROM store_sales,
        customer
   WHERE ss_customer_sk = c_customer_sk
     AND c_birth_year BETWEEN 1977 AND 1983
   GROUP BY c_customer_sk
   HAVING sum(ss_quantity*ss_sales_price) > (95/100.0) *
     (SELECT *
      FROM max_store_sales))
SELECT sum(sales)
FROM
  (SELECT cs.cs_quantity * cs.cs_list_price AS sales
   FROM catalog_sales AS cs
   JOIN date_dim AS d ON cs.cs_sold_date_sk = d.d_date_sk
   JOIN
     (SELECT DISTINCT item_sk
      FROM frequent_ss_items) AS fsi ON cs.cs_item_sk = fsi.item_sk
   JOIN best_ss_customer AS bsc ON cs.cs_bill_customer_sk = bsc.c_customer_sk
   WHERE d.d_year = 2001
     AND d.d_moy = 10
     AND cs.cs_wholesale_cost BETWEEN 2 AND 12
   UNION ALL SELECT ws.ws_quantity * ws.ws_list_price AS sales
   FROM web_sales AS ws
   JOIN date_dim AS d ON ws.ws_sold_date_sk = d.d_date_sk
   JOIN
     (SELECT DISTINCT item_sk
      FROM frequent_ss_items) AS fsi ON ws.ws_item_sk = fsi.item_sk
   JOIN best_ss_customer AS bsc ON ws.ws_bill_customer_sk = bsc.c_customer_sk
   WHERE d.d_year = 2001
     AND d.d_moy = 10
     AND ws.ws_wholesale_cost BETWEEN 2 AND 12) tmp2
LIMIT 100;