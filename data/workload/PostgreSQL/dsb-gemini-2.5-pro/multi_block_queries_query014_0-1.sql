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
        AND ss_wholesale_cost BETWEEN 80 AND 100) INTERSECT
     (SELECT DISTINCT ics.i_brand_id,
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
        AND cs_wholesale_cost BETWEEN 80 AND 100) INTERSECT
     (SELECT DISTINCT iws.i_brand_id,
                      iws.i_class_id,
                      iws.i_category_id
      FROM web_sales
      JOIN date_dim d3 ON ws_sold_date_sk = d3.d_date_sk
      JOIN item iws ON ws_item_sk = iws.i_item_sk
      WHERE d3.d_year BETWEEN 1998 AND 1998 + 2
        AND ws_wholesale_cost BETWEEN 80 AND 100)),
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
     this_year AS
  (SELECT 'store' channel,
             i_brand_id,
             i_class_id,
             i_category_id,
             sum(ss_quantity*ss_list_price) sales,
             count(*) number_sales
   FROM store_sales
   JOIN item ON ss_item_sk = i_item_sk
   JOIN date_dim ON ss_sold_date_sk = d_date_sk
   WHERE ss_item_sk IN
       (SELECT ss_item_sk
        FROM cross_items)
     AND d_week_seq =
       (SELECT d_week_seq
        FROM date_dim
        WHERE d_year = 1998 + 1
          AND d_moy = 12
          AND d_dom = 5)
     AND i_category IN ('Books',
                        'Home',
                        'Jewelry')
     AND i_manager_id BETWEEN 28 AND 37
     AND ss_wholesale_cost BETWEEN 80 AND 100
   GROUP BY i_brand_id,
            i_class_id,
            i_category_id),
     last_year AS
  (SELECT 'store' channel,
             i_brand_id,
             i_class_id,
             i_category_id,
             sum(ss_quantity*ss_list_price) sales,
             count(*) number_sales
   FROM store_sales
   JOIN item ON ss_item_sk = i_item_sk
   JOIN date_dim ON ss_sold_date_sk = d_date_sk
   WHERE ss_item_sk IN
       (SELECT ss_item_sk
        FROM cross_items)
     AND d_week_seq =
       (SELECT d_week_seq
        FROM date_dim
        WHERE d_year = 1998
          AND d_moy = 12
          AND d_dom = 5)
     AND i_category IN ('Books',
                        'Home',
                        'Jewelry')
     AND ss_wholesale_cost BETWEEN 80 AND 100
     AND i_manager_id BETWEEN 28 AND 37
   GROUP BY i_brand_id,
            i_class_id,
            i_category_id)
SELECT this_year.channel ty_channel,
       this_year.i_brand_id ty_brand,
       this_year.i_class_id ty_class,
       this_year.i_category_id ty_category,
       this_year.sales ty_sales,
       this_year.number_sales ty_number_sales,
       last_year.channel ly_channel,
       last_year.i_brand_id ly_brand,
       last_year.i_class_id ly_class,
       last_year.i_category_id ly_category,
       last_year.sales ly_sales,
       last_year.number_sales ly_number_sales
FROM this_year
JOIN last_year ON this_year.i_brand_id= last_year.i_brand_id
AND this_year.i_class_id = last_year.i_class_id
AND this_year.i_category_id = last_year.i_category_id,
    avg_sales
WHERE this_year.sales > avg_sales.average_sales
  AND last_year.sales > avg_sales.average_sales
ORDER BY this_year.channel,
         this_year.i_brand_id,
         this_year.i_class_id,
         this_year.i_category_id
LIMIT 100;