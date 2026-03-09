
SELECT min(w.w_warehouse_name),
       min(sm.sm_type),
       min(cc.cc_name),
       min(cs.cs_order_number),
       min(cs.cs_item_sk)
FROM catalog_sales cs,
     warehouse w,
     ship_mode sm,
     call_center cc
WHERE cs.cs_warehouse_sk = w.w_warehouse_sk
  AND cs.cs_ship_mode_sk = sm.sm_ship_mode_sk
  AND cs.cs_call_center_sk = cc.cc_call_center_sk
  AND cs.cs_list_price BETWEEN 77 AND 106
  AND cs.cs_ship_date_sk IN
    (SELECT d_date_sk
     FROM date_dim
     WHERE d_month_seq BETWEEN 1193 AND 1193 + 23)
  AND cs.cs_warehouse_sk IN
    (SELECT w_warehouse_sk
     FROM warehouse
     WHERE w_gmt_offset = -5)
  AND cs.cs_ship_mode_sk IN
    (SELECT sm_ship_mode_sk
     FROM ship_mode
     WHERE sm_type = 'TWO DAY')
  AND cs.cs_call_center_sk IN
    (SELECT cc_call_center_sk
     FROM call_center
     WHERE cc_class = 'small');