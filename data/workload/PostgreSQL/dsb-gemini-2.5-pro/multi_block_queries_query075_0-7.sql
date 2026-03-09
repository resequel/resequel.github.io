WITH curr_yr_sales AS
  (SELECT i_brand_id,
          i_class_id,
          i_category_id,
          i_manufact_id,
          SUM(cs_quantity - COALESCE(cr_return_quantity, 0)) AS sales_cnt,
          SUM(cs_ext_sales_price - COALESCE(cr_return_amount, 0.0)) AS sales_amt
   FROM catalog_sales
   JOIN item ON i_item_sk = cs_item_sk
   JOIN date_dim ON d_date_sk = cs_sold_date_sk
   LEFT JOIN catalog_returns ON cs_order_number = cr_order_number
   AND cs_item_sk = cr_item_sk
   AND cr_reason_sk IN (7,
                             10,
                             12,
                             29,
                             45)
   WHERE d_year = 1999
     AND i_category = 'Sports'
     AND cs_list_price > 0
     AND cs_sales_price / cs_list_price BETWEEN 80 * 0.01 AND 100 * 0.01
   GROUP BY i_brand_id,
            i_class_id,
            i_category_id,
            i_manufact_id),
     prev_yr_sales AS
  (SELECT i_brand_id,
          i_class_id,
          i_category_id,
          i_manufact_id,
          SUM(cs_quantity - COALESCE(cr_return_quantity, 0)) AS sales_cnt,
          SUM(cs_ext_sales_price - COALESCE(cr_return_amount, 0.0)) AS sales_amt
   FROM catalog_sales
   JOIN item ON i_item_sk = cs_item_sk
   JOIN date_dim ON d_date_sk = cs_sold_date_sk
   LEFT JOIN catalog_returns ON cs_order_number = cr_order_number
   AND cs_item_sk = cr_item_sk
   AND cr_reason_sk IN (7,
                             10,
                             12,
                             29,
                             45)
   WHERE d_year = 1999 - 1
     AND i_category = 'Sports'
     AND cs_list_price > 0
     AND cs_sales_price / cs_list_price BETWEEN 80 * 0.01 AND 100 * 0.01
   GROUP BY i_brand_id,
            i_class_id,
            i_category_id,
            i_manufact_id)
SELECT (1999 - 1) AS prev_year, 1999 AS YEAR,
                                        curr_yr.i_brand_id,
                                        curr_yr.i_class_id,
                                        curr_yr.i_category_id,
                                        curr_yr.i_manufact_id,
                                        prev_yr.sales_cnt AS prev_yr_cnt,
                                        curr_yr.sales_cnt AS curr_yr_cnt,
                                        curr_yr.sales_cnt - prev_yr.sales_cnt AS sales_cnt_diff,
                                        curr_yr.sales_amt - prev_yr.sales_amt AS sales_amt_diff
FROM curr_yr_sales curr_yr
JOIN prev_yr_sales prev_yr ON curr_yr.i_brand_id = prev_yr.i_brand_id
AND curr_yr.i_class_id = prev_yr.i_class_id
AND curr_yr.i_category_id = prev_yr.i_category_id
AND curr_yr.i_manufact_id = prev_yr.i_manufact_id
WHERE prev_yr.sales_cnt > 0
  AND CAST(curr_yr.sales_cnt AS DECIMAL(17, 2)) / CAST(prev_yr.sales_cnt AS DECIMAL(17, 2)) < 0.9
ORDER BY sales_cnt_diff,
         sales_amt_diff
LIMIT 100;