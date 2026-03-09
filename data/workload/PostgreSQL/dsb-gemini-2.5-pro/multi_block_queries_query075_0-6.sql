WITH catalog_sales_filtered AS
  (SELECT d.d_year,
          i.i_brand_id,
          i.i_class_id,
          i.i_category_id,
          i.i_manufact_id,
          cs.cs_quantity - COALESCE(cr.cr_return_quantity, 0) AS sales_cnt,
          cs.cs_ext_sales_price - COALESCE(cr.cr_return_amount, 0.0) AS sales_amt
   FROM catalog_sales cs
   JOIN date_dim d ON cs.cs_sold_date_sk = d.d_date_sk
   JOIN item i ON cs.cs_item_sk = i.i_item_sk
   LEFT JOIN catalog_returns cr ON cs.cs_order_number = cr.cr_order_number
   AND cs.cs_item_sk = cr.cr_item_sk
   AND cr.cr_reason_sk IN (7,
                             10,
                             12,
                             29,
                             45)
   WHERE d.d_year IN (1999, 1999 - 1)
     AND i.i_category = 'Sports'
     AND cs.cs_list_price > 0
     AND cs.cs_sales_price / cs.cs_list_price BETWEEN 80 * 0.01 AND 100 * 0.01),
     comparison_sales AS
  (SELECT i_brand_id,
          i_class_id,
          i_category_id,
          i_manufact_id,
          SUM(CASE
                  WHEN d_year = 1999 THEN sales_cnt
                  ELSE 0
              END) AS curr_yr_cnt,
          SUM(CASE
                  WHEN d_year = 1999 THEN sales_amt
                  ELSE 0
              END) AS curr_yr_amt,
          SUM(CASE
                  WHEN d_year = 1999 - 1 THEN sales_cnt
                  ELSE 0
              END) AS prev_yr_cnt,
          SUM(CASE
                  WHEN d_year = 1999 - 1 THEN sales_amt
                  ELSE 0
              END) AS prev_yr_amt
   FROM catalog_sales_filtered
   GROUP BY i_brand_id,
            i_class_id,
            i_category_id,
            i_manufact_id)
SELECT (1999 - 1) AS prev_year, 1999 AS YEAR,
                                        i_brand_id,
                                        i_class_id,
                                        i_category_id,
                                        i_manufact_id,
                                        prev_yr_cnt,
                                        curr_yr_cnt,
                                        curr_yr_cnt - prev_yr_cnt AS sales_cnt_diff,
                                        curr_yr_amt - prev_yr_amt AS sales_amt_diff
FROM comparison_sales
WHERE prev_yr_cnt > 0
  AND CAST(curr_yr_cnt AS DECIMAL(17, 2)) / CAST(prev_yr_cnt AS DECIMAL(17, 2)) < 0.9
ORDER BY sales_cnt_diff,
         sales_amt_diff
LIMIT 100;