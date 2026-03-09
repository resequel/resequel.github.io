WITH filtered_cdemo AS
  (SELECT cd_demo_sk
   FROM customer_demographics
   WHERE cd_marital_status = 'M'
     AND cd_education_status = 'Unknown'
   UNION SELECT cd_demo_sk
   FROM customer_demographics
   WHERE cd_marital_status = 'W'
     AND cd_education_status = 'Advanced Degree'),
     filtered_customers AS
  (SELECT c.c_customer_sk
   FROM customer c
   JOIN filtered_cdemo fcd ON c.c_current_cdemo_sk = fcd.cd_demo_sk
   JOIN household_demographics hd ON c.c_current_hdemo_sk = hd.hd_demo_sk
   JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
   WHERE hd.hd_buy_potential LIKE '0-500%'
     AND ca.ca_gmt_offset = -7)
SELECT min(cc.cc_call_center_id),
       min(cc.cc_name),
       min(cc.cc_manager),
       min(cr.cr_net_loss),
       min(cr.cr_item_sk),
       min(cr.cr_order_number)
FROM catalog_returns cr
JOIN date_dim d ON cr.cr_returned_date_sk = d.d_date_sk
JOIN call_center cc ON cr.cr_call_center_sk = cc.cc_call_center_sk
JOIN filtered_customers fc ON cr.cr_returning_customer_sk = fc.c_customer_sk
WHERE d.d_year = 1999
  AND d.d_moy = 5;