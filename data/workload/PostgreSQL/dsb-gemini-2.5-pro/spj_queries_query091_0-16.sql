WITH customer_subset AS
  (SELECT c_customer_sk,
          c_current_cdemo_sk
   FROM customer c
   JOIN household_demographics hd ON c.c_current_hdemo_sk = hd.hd_demo_sk
   JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
   WHERE hd.hd_buy_potential LIKE '0-500%'
     AND ca.ca_gmt_offset = -7),
     final_customers AS
  (SELECT cs.c_customer_sk
   FROM customer_subset cs
   JOIN customer_demographics cd ON cs.c_current_cdemo_sk = cd.cd_demo_sk
   WHERE cd.cd_marital_status = 'M'
     AND cd.cd_education_status = 'Unknown'
   UNION SELECT cs.c_customer_sk
   FROM customer_subset cs
   JOIN customer_demographics cd ON cs.c_current_cdemo_sk = cd.cd_demo_sk
   WHERE cd.cd_marital_status = 'W'
     AND cd.cd_education_status = 'Advanced Degree')
SELECT min(cc.cc_call_center_id),
       min(cc.cc_name),
       min(cc.cc_manager),
       min(cr.cr_net_loss),
       min(cr.cr_item_sk),
       min(cr.cr_order_number)
FROM catalog_returns cr
JOIN date_dim d ON cr.cr_returned_date_sk = d.d_date_sk
JOIN call_center cc ON cr.cr_call_center_sk = cc.cc_call_center_sk
JOIN final_customers fc ON cr.cr_returning_customer_sk = fc.c_customer_sk
WHERE d.d_year = 1999
  AND d.d_moy = 5;