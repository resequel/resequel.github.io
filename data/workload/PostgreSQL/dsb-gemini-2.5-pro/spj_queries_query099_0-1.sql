WITH filtered_dates AS
  (SELECT d_date_sk
   FROM date_dim
   WHERE d_month_seq BETWEEN 1193 AND 1193 + 23),
     filtered_warehouse AS
  (SELECT w_warehouse_sk,
          w_warehouse_name
   FROM warehouse
   WHERE w_gmt_offset = -5),
     filtered_ship_mode AS
  (SELECT sm_ship_mode_sk,
          sm_type
   FROM ship_mode
   WHERE sm_type = 'TWO DAY'),
     filtered_call_center AS
  (SELECT cc_call_center_sk,
          cc_name
   FROM call_center
   WHERE cc_class = 'small')
SELECT min(w.w_warehouse_name),
       min(sm.sm_type),
       min(cc.cc_name),
       min(cs.cs_order_number),
       min(cs.cs_item_sk)
FROM catalog_sales AS cs
JOIN filtered_dates AS d ON cs.cs_ship_date_sk = d.d_date_sk
JOIN filtered_warehouse AS w ON cs.cs_warehouse_sk = w.w_warehouse_sk
JOIN filtered_ship_mode AS sm ON cs.cs_ship_mode_sk = sm.sm_ship_mode_sk
JOIN filtered_call_center AS cc ON cs.cs_call_center_sk = cc.cc_call_center_sk
WHERE cs.cs_list_price BETWEEN 77 AND 106;