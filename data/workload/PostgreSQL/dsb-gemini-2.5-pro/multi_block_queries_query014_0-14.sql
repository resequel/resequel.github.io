WITH avg_sales AS
  (SELECT avg(quantity * list_price) AS average_sales
   FROM
     (SELECT ss_quantity AS quantity,
             ss_list_price AS list_price
      FROM store_sales,
           date_dim
      WHERE ss_sold_date_sk = d_date_sk
        AND d_year BETWEEN 1998 AND 1998 + 2
        AND ss_wholesale_cost BETWEEN 80 AND 100
      UNION ALL SELECT cs_quantity,
                       cs_list_price
      FROM catalog_sales,
           date_dim
      WHERE cs_sold_date_sk = d_date_sk
        AND d_year BETWEEN 1998 AND 1998 + 2
        AND cs_wholesale_cost BETWEEN 80 AND 100
      UNION ALL SELECT ws_quantity,
                       ws_list_price
      FROM web_sales,
           date_dim
      WHERE ws_sold_date_sk = d_date_sk
        AND d_year BETWEEN 1998 AND 1998 + 2
        AND ws_wholesale_cost BETWEEN 80 AND 100) sales_union),
     cross_items AS MATERIALIZED
  (SELECT i_item_sk
   FROM item,
     (SELECT iss.i_brand_id, iss.i_class_id, iss.i_category_id
      FROM store_sales, item iss, date_dim d1
      WHERE ss_item_sk = iss.i_item_sk
        AND ss_sold_date_sk = d1.d_date_sk
        AND d1.d_year BETWEEN 1998 AND 1998 + 2
        AND iss.i_category IN ('Books',
                           'Home',
                           'Jewelry')
        AND iss.i_manager_id BETWEEN 28 AND 37
        AND ss_wholesale_cost BETWEEN 80 AND 100 INTERSECT SELECT ics.i_brand_id, ics.i_class_id, ics.i_category_id
      FROM catalog_sales, item ics, date_dim d2
      WHERE cs_item_sk = ics.i_item_sk
        AND cs_sold_date_sk = d2.d_date_sk
        AND d2.d_year BETWEEN 1998 AND 1998 + 2
        AND ics.i_category IN ('Books',
                           'Home',
                           'Jewelry')
        AND ics.i_manager_id BETWEEN 28 AND 37
        AND cs_wholesale_cost BETWEEN 80 AND 100 INTERSECT SELECT iws.i_brand_id, iws.i_class_id, iws.i_category_id
      FROM web_sales, item iws, date_dim d3
      WHERE ws_item_sk = iws.i_item_sk
        AND ws_sold_date_sk = d3.d_date_sk
        AND d3.d_year BETWEEN 1998 AND 1998 + 2
        AND ws_wholesale_cost BETWEEN 80 AND 100) y
   WHERE i_brand_id = y.i_brand_id
     AND i_class_id = y.i_class_id
     AND i_category_id = y.i_category_id
     AND i_category IN ('Books',
                        'Home',
                        'Jewelry')
     AND i_manager_id BETWEEN 28 AND 37),
     this_year AS
  (SELECT i.i_brand_id,
          i.i_class_id,
          i.i_category_id,
          sum(ss.ss_quantity*ss.ss_list_price) sales,
          count(*) number_sales
   FROM store_sales ss
   JOIN item i ON ss.ss_item_sk = i.i_item_sk
   JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
   JOIN cross_items ci ON ss.ss_item_sk = ci.i_item_sk
   WHERE d.d_week_seq =
       (SELECT d_week_seq
        FROM date_dim
        WHERE d_year = 1998 + 1
          AND d_moy = 12
          AND d_dom = 5)
     AND i.i_category IN ('Books',
                        'Home',
                        'Jewelry')
     AND i.i_manager_id BETWEEN 28 AND 37
     AND ss.ss_wholesale_cost BETWEEN 80 AND 100
   GROUP BY i.i_brand_id,
            i.i_class_id,
            i.i_category_id),
     last_year AS
  (SELECT i.i_brand_id,
          i.i_class_id,
          i.i_category_id,
          sum(ss.ss_quantity*ss.ss_list_price) sales,
          count(*) number_sales
   FROM store_sales ss
   JOIN item i ON ss.ss_item_sk = i.i_item_sk
   JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
   JOIN cross_items ci ON ss.ss_item_sk = ci.i_item_sk
   WHERE d.d_week_seq =
       (SELECT d_week_seq
        FROM date_dim
        WHERE d_year = 1998
          AND d_moy = 12
          AND d_dom = 5)
     AND i.i_category IN ('Books',
                        'Home',
                        'Jewelry')
     AND ss.ss_wholesale_cost BETWEEN 80 AND 100
     AND i.i_manager_id BETWEEN 28 AND 37
   GROUP BY i.i_brand_id,
            i.i_class_id,
            i.i_category_id)
SELECT 'store' AS ty_channel,
          ty.i_brand_id AS ty_brand,
          ty.i_class_id AS ty_class,
          ty.i_category_id AS ty_category,
          ty.sales AS ty_sales,
          ty.number_sales AS ty_number_sales, 'store' AS ly_channel,
                                                 ly.i_brand_id AS ly_brand,
                                                 ly.i_class_id AS ly_class,
                                                 ly.i_category_id AS ly_category,
                                                 ly.sales AS ly_sales,
                                                 ly.number_sales AS ly_number_sales
FROM this_year ty
JOIN last_year ly ON ty.i_brand_id = ly.i_brand_id
AND ty.i_class_id = ly.i_class_id
AND ty.i_category_id = ly.i_category_id
CROSS JOIN avg_sales
WHERE ty.sales > avg_sales.average_sales
  AND ly.sales > avg_sales.average_sales
ORDER BY ty_channel,
         ty_brand,
         ty_class,
         ty_category
LIMIT 100;