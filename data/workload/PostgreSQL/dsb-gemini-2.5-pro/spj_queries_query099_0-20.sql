WITH qualified_sales AS
  (SELECT cs_order_number,
          cs_item_sk,
          cs_warehouse_sk,
          cs_ship_mode_sk,
          cs_call_center_sk
   FROM catalog_sales
   WHERE cs_list_price BETWEEN 77 AND 106)
SELECT min(w.w_warehouse_name),
       min(sm.sm_type),
       min(cc.cc_name),
       min(qs.cs_order_number),
       min(qs.cs_item_sk)
FROM qualified_sales AS qs
JOIN date_dim AS d ON qs.cs_ship_date_sk = d.d_date_sk
JOIN warehouse AS w ON qs.cs_warehouse_sk = w.w_warehouse_sk
JOIN ship_mode AS sm ON qs.cs_ship_mode_sk = sm.sm_ship_mode_sk
JOIN call_center AS cc ON qs.cs_call_center_sk = cc.cc_call_center_sk
WHERE d.d_month_seq BETWEEN 1193 AND 1193 + 23
  AND w.w_gmt_offset = -5
  AND sm.sm_type = 'TWO DAY'
  AND cc.cc_class = 'small';