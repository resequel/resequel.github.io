WITH filtered_dates AS
  (SELECT d_date_sk
   FROM date_dim
   WHERE d_month_seq BETWEEN 1193 AND 1193 + 23),
     filtered_cs AS
  (SELECT cs_order_number,
          cs_item_sk,
          cs_warehouse_sk,
          cs_ship_mode_sk,
          cs_call_center_sk
   FROM catalog_sales cs
   JOIN filtered_dates d ON cs.cs_ship_date_sk = d.d_date_sk
   WHERE cs.cs_list_price BETWEEN 77 AND 106)
SELECT min(w.w_warehouse_name),
       min(sm.sm_type),
       min(cc.cc_name),
       min(fcs.cs_order_number),
       min(fcs.cs_item_sk)
FROM filtered_cs fcs
JOIN warehouse w ON fcs.cs_warehouse_sk = w.w_warehouse_sk
JOIN ship_mode sm ON fcs.cs_ship_mode_sk = sm.sm_ship_mode_sk
JOIN call_center cc ON fcs.cs_call_center_sk = cc.cc_call_center_sk
WHERE sm.sm_type = 'TWO DAY'
  AND cc.cc_class = 'small'
  AND w.w_gmt_offset = -5;