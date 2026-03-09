WITH avg_sales AS
  (SELECT avg(quantity*list_price) average_sales
   FROM
     (SELECT ss_quantity quantity,
             ss_list_price list_price
      FROM store_sales,
           date_dim
      WHERE ss_sold_date_sk = d_date_sk
        AND d_year BETWEEN 1998 AND 1998 + 2
        AND ss_wholesale_cost BETWEEN 80 AND 100
      UNION ALL SELECT cs_quantity quantity,
                       cs_list_price list_price
      FROM catalog_sales,
           date_dim
      WHERE cs_sold_date_sk = d_date_sk
        AND d_year BETWEEN 1998 AND 1998 + 2
        AND cs_wholesale_cost BETWEEN 80 AND 100
      UNION ALL SELECT ws_quantity quantity,
                       ws_list_price list_price
      FROM web_sales,
           date_dim
      WHERE ws_sold_date_sk = d_date_sk
        AND ws_wholesale_cost BETWEEN 80 AND 100
        AND d_year BETWEEN 1998 AND 1998 + 2) x),
     common_bci AS
  (SELECT i_brand_id,
          i_class_id,
          i_category_id
   FROM
     (SELECT DISTINCT iss.i_brand_id,
                      iss.i_class_id,
                      iss.i_category_id
      FROM store_sales
      JOIN date_dim d1 ON ss_sold_date_sk = d1.d_date_sk
      JOIN item iss ON ss_item_sk = iss.i_item_sk
      WHERE d1.d_year BETWEEN 1998 AND 1998 + 2
        AND iss.i_category IN ('Books',
                           'Home',
                           'Jewelry')
        AND iss.i_manager_id BETWEEN 28 AND 37
        AND ss_wholesale_cost BETWEEN 80 AND 100) INTERSECT SELECT DISTINCT ics.i_brand_id,
                                                                                 ics.i_class_id,
                                                                                 ics.i_category_id
   FROM catalog_sales
   JOIN date_dim d2 ON cs_sold_date_sk = d2.d_date_sk
   JOIN item ics ON cs_item_sk = ics.i_item_sk
   WHERE d2.d_year BETWEEN 1998 AND 1998 + 2
     AND ics.i_category IN ('Books',
                           'Home',
                           'Jewelry')
     AND ics.i_manager_id BETWEEN 28 AND 37
     AND cs_wholesale_cost BETWEEN 80 AND 100 INTERSECT SELECT DISTINCT iws.i_brand_id,
                                                                             iws.i_class_id,
                                                                             iws.i_category_id
   FROM web_sales
   JOIN date_dim d3 ON ws_sold_date_sk = d3.d_date_sk
   JOIN item iws ON ws_item_sk = iws.i_item_sk
   WHERE d3.d_year BETWEEN 1998 AND 1998 + 2
     AND ws_wholesale_cost BETWEEN 80 AND 100),
     cross_items AS
  (SELECT i_item_sk
   FROM item i
   JOIN common_bci c ON i.i_brand_id = c.i_brand_id
   AND i.i_class_id = c.i_class_id
   AND i.i_category_id = c.i_category_id
   WHERE i.i_category IN ('Books',
                        'Home',
                        'Jewelry')
     AND i.i_manager_id BETWEEN 28 AND 37),
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
   JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
   JOIN item i ON ss.ss_item_sk = i.i_item_sk
   JOIN cross_items ci ON ss.ss_item_sk = ci.ss_item_sk
   WHERE d.d_week_seq IN (
                            (SELECT d_week_seq
                             FROM date_dim
                             WHERE d_year = 1998 + 1
                               AND d_moy = 12
                               AND d_dom = 5),
                            (SELECT d_week_seq
                             FROM date_dim
                             WHERE d_year = 1998
                               AND d_moy = 12
                               AND d_dom = 5))
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