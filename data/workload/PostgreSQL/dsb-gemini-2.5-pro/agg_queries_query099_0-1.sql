WITH filtered_cs AS
  (SELECT cs_sold_date_sk,
          cs_ship_date_sk,
          cs_warehouse_sk,
          cs_ship_mode_sk,
          cs_call_center_sk
   FROM catalog_sales
   WHERE cs_list_price BETWEEN 77 AND 106),
     filtered_dates AS
  (SELECT d_date_sk
   FROM date_dim
   WHERE d_month_seq BETWEEN 1193 AND 1193 + 23),
     filtered_warehouses AS
  (SELECT w_warehouse_sk,
          substring(w_warehouse_name, 1, 20) AS warehouse_name_part
   FROM warehouse
   WHERE w_gmt_offset = -5),
     filtered_ship_modes AS
  (SELECT sm_ship_mode_sk,
          sm_type
   FROM ship_mode
   WHERE sm_type = 'TWO DAY'),
     filtered_call_centers AS
  (SELECT cc_call_center_sk,
          cc_name
   FROM call_center
   WHERE cc_class = 'small')
SELECT fw.warehouse_name_part,
       fsm.sm_type,
       fcc.cc_name,
       COUNT(*) FILTER (
                        WHERE fcs.cs_ship_date_sk - fcs.cs_sold_date_sk <= 30) AS "30 days",
       COUNT(*) FILTER (
                        WHERE fcs.cs_ship_date_sk - fcs.cs_sold_date_sk > 30
                          AND fcs.cs_ship_date_sk - fcs.cs_sold_date_sk <= 60) AS "31-60 days",
       COUNT(*) FILTER (
                        WHERE fcs.cs_ship_date_sk - fcs.cs_sold_date_sk > 60
                          AND fcs.cs_ship_date_sk - fcs.cs_sold_date_sk <= 90) AS "61-90 days",
       COUNT(*) FILTER (
                        WHERE fcs.cs_ship_date_sk - fcs.cs_sold_date_sk > 90
                          AND fcs.cs_ship_date_sk - fcs.cs_sold_date_sk <= 120) AS "91-120 days",
       COUNT(*) FILTER (
                        WHERE fcs.cs_ship_date_sk - fcs.cs_sold_date_sk > 120) AS ">120 days"
FROM filtered_cs fcs
JOIN filtered_dates fd ON fcs.cs_ship_date_sk = fd.d_date_sk
JOIN filtered_warehouses fw ON fcs.cs_warehouse_sk = fw.w_warehouse_sk
JOIN filtered_ship_modes fsm ON fcs.cs_ship_mode_sk = fsm.sm_ship_mode_sk
JOIN filtered_call_centers fcc ON fcs.cs_call_center_sk = fcc.cc_call_center_sk
GROUP BY fw.warehouse_name_part,
         fsm.sm_type,
         fcc.cc_name
ORDER BY fw.warehouse_name_part,
         fsm.sm_type,
         fcc.cc_name
LIMIT 100;