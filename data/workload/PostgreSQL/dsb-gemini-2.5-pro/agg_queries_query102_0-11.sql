WITH filtered_store_sales AS
  (SELECT ss.ss_item_sk,
          ss.ss_customer_sk,
          d1.d_date
   FROM store_sales ss
   JOIN date_dim d1 ON ss.ss_sold_date_sk = d1.d_date_sk
   AND d1.d_year = 2001
   JOIN inventory inv ON ss.ss_item_sk = inv.inv_item_sk
   AND ss.ss_sold_date_sk = inv.inv_date_sk
   AND inv.inv_quantity_on_hand >= ss.ss_quantity)
SELECT cd.cd_gender,
       cd.cd_marital_status,
       cd.cd_education_status,
       hd.hd_vehicle_count,
       count(*) AS cnt
FROM filtered_store_sales fss
JOIN web_sales ws ON fss.ss_item_sk = ws.ws_item_sk
AND fss.ss_customer_sk = ws.ws_bill_customer_sk
JOIN date_dim d2 ON ws.ws_sold_date_sk = d2.d_date_sk
JOIN item i ON ws.ws_item_sk = i.i_item_sk
JOIN customer c ON fss.ss_customer_sk = c.c_customer_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN customer_demographics cd ON c.c_current_cdemo_sk = cd.cd_demo_sk
JOIN household_demographics hd ON c.c_current_hdemo_sk = hd.hd_demo_sk
JOIN warehouse w ON ws.ws_warehouse_sk = w.w_warehouse_sk
JOIN store s ON s.s_state = w.w_state
WHERE ws.ws_wholesale_cost BETWEEN 80 AND 100
  AND i.i_category IN ('Books',
                     'Home',
                     'Sports')
  AND i.i_manager_id IN (3,
                       15,
                       17,
                       26,
                       43,
                       44,
                       55,
                       70,
                       82,
                       95)
  AND ca.ca_state IN ('IN',
                   'LA',
                   'NE',
                   'NM',
                   'OH')
  AND d2.d_date BETWEEN fss.d_date AND (fss.d_date + interval '30 day')
GROUP BY cd.cd_gender,
         cd.cd_marital_status,
         cd.cd_education_status,
         hd.hd_vehicle_count
ORDER BY cnt;