WITH avg_sales AS
  (SELECT avg(quantity * list_price) AS average_sales
   FROM
     (SELECT ss_quantity AS quantity,
             ss_list_price AS list_price
      FROM store_sales
      JOIN date_dim ON ss_sold_date_sk = d_date_sk
      WHERE d_year BETWEEN 1998 AND 1998 + 2
        AND ss_wholesale_cost BETWEEN 80 AND 100
      UNION ALL SELECT cs_quantity,
                       cs_list_price
      FROM catalog_sales
      JOIN date_dim ON cs_sold_date_sk = d_date_sk
      WHERE d_year BETWEEN 1998 AND 1998 + 2
        AND cs_wholesale_cost BETWEEN 80 AND 100
      UNION ALL SELECT ws_quantity,
                       ws_list_price
      FROM web_sales
      JOIN date_dim ON ws_sold_date_sk = d_date_sk
      WHERE d_year BETWEEN 1998 AND 1998 + 2
        AND ws_wholesale_cost BETWEEN 80 AND 100) sales_data),
     common_bci AS
  (SELECT i_brand_id,
          i_class_id,
          i_category_id
   FROM
     (SELECT DISTINCT iss.i_brand_id,
                      iss.i_class_id,
                      iss.i_category_id,
                      1 AS channel
      FROM store_sales
      JOIN date_dim d1 ON ss_sold_date_sk = d1.d_date_sk
      JOIN item iss ON ss_item_sk = iss.i_item_sk
      WHERE d1.d_year BETWEEN 1998 AND 1998 + 2
        AND iss.i_category IN ('Books',
                           'Home',
                           'Jewelry')
        AND iss.i_manager_id BETWEEN 28 AND 37
        AND ss_wholesale_cost BETWEEN 80 AND 100
      UNION ALL SELECT DISTINCT ics.i_brand_id,
                                ics.i_class_id,
                                ics.i_category_id,
                                2 AS channel
      FROM catalog_sales
      JOIN date_dim d2 ON cs_sold_date_sk = d2.d_date_sk
      JOIN item ics ON cs_item_sk = ics.i_item_sk
      WHERE d2.d_year BETWEEN 1998 AND 1998 + 2
        AND ics.i_category IN ('Books',
                           'Home',
                           'Jewelry')
        AND ics.i_manager_id BETWEEN 28 AND 37
        AND cs_wholesale_cost BETWEEN 80 AND 100
      UNION ALL SELECT DISTINCT iws.i_brand_id,
                                iws.i_class_id,
                                iws.i_category_id,
                                3 AS channel
      FROM web_sales
      JOIN date_dim d3 ON ws_sold_date_sk = d3.d_date_sk
      JOIN item iws ON ws_item_sk = iws.i_item_sk
      WHERE d3.d_year BETWEEN 1998 AND 1998 + 2
        AND ws_wholesale_cost BETWEEN 80 AND 100) channel_bci
   GROUP BY i_brand_id,
            i_class_id,
            i_category_id
   HAVING COUNT(DISTINCT channel) = 3),
     target_weeks AS
  (SELECT d_week_seq,
          d_year
   FROM date_dim
   WHERE (d_year = 1998 + 1
          AND d_moy = 12
          AND d_dom = 5)
     OR (d_year = 1998
         AND d_moy = 12
         AND d_dom = 5)),
     yearly_sales AS
  (SELECT i.i_brand_id,
          i.i_class_id,
          i.i_category_id,
          SUM(CASE
                  WHEN d.d_year = 1998 + 1 THEN ss.ss_quantity * ss.ss_list_price
              END) AS this_year_sales,
          COUNT(CASE
                    WHEN d.d_year = 1998 + 1 THEN 1
                END) AS this_year_number_sales,
          SUM(CASE
                  WHEN d.d_year = 1998 THEN ss.ss_quantity * ss.ss_list_price
              END) AS last_year_sales,
          COUNT(CASE
                    WHEN d.d_year = 1998 THEN 1
                END) AS last_year_number_sales
   FROM store_sales ss
   JOIN item i ON ss.ss_item_sk = i.i_item_sk
   JOIN common_bci c ON i.i_brand_id = c.i_brand_id
   AND i.i_class_id = c.i_class_id
   AND i.i_category_id = c.i_category_id
   JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
   JOIN target_weeks tw ON d.d_week_seq = tw.d_week_seq
   WHERE i.i_category IN ('Books',
                        'Home',
                        'Jewelry')
     AND i.i_manager_id BETWEEN 28 AND 37
     AND ((d.d_year = 1998 + 1
           AND i.i_category IN ('Books',
                        'Home',
                        'Jewelry')
           AND i.i_manager_id BETWEEN 28 AND 37
           AND ss.ss_wholesale_cost BETWEEN 80 AND 100)
          OR (d.d_year = 1998
              AND i.i_category IN ('Books',
                        'Home',
                        'Jewelry')
              AND i.i_manager_id BETWEEN 28 AND 37
              AND ss.ss_wholesale_cost BETWEEN 80 AND 100))
   GROUP BY i.i_brand_id,
            i.i_class_id,
            i.i_category_id)
SELECT 'store' AS ty_channel,
          ys.i_brand_id AS ty_brand,
          ys.i_class_id AS ty_class,
          ys.i_category_id AS ty_category,
          ys.this_year_sales AS ty_sales,
          ys.this_year_number_sales AS ty_number_sales, 'store' AS ly_channel,
                                                           ys.i_brand_id AS ly_brand,
                                                           ys.i_class_id AS ly_class,
                                                           ys.i_category_id AS ly_category,
                                                           ys.last_year_sales AS ly_sales,
                                                           ys.last_year_number_sales AS ly_number_sales
FROM yearly_sales ys,
     avg_sales av
WHERE ys.this_year_sales > av.average_sales
  AND ys.last_year_sales > av.average_sales
ORDER BY ty_channel,
         ty_brand,
         ty_class,
         ty_category
LIMIT 100;