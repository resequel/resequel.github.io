WITH filtered_customers AS
  (SELECT c_customer_sk
   FROM customer
   INNER JOIN customer_demographics ON c_current_cdemo_sk = cd_demo_sk
   INNER JOIN household_demographics ON c_current_hdemo_sk = hd_demo_sk
   INNER JOIN customer_address ON c_current_addr_sk = ca_address_sk
   WHERE ca_gmt_offset = -7
     AND hd_buy_potential LIKE '0-500%'
     AND (cd_marital_status,
          cd_education_status) IN (('M', 'Unknown'), ('W', 'Advanced Degree')))
SELECT min(cc.cc_call_center_id),
       min(cc.cc_name),
       min(cc.cc_manager),
       min(cr.cr_net_loss),
       min(cr.cr_item_sk),
       min(cr.cr_order_number)
FROM catalog_returns cr
INNER JOIN date_dim d ON cr.cr_returned_date_sk = d.d_date_sk
INNER JOIN call_center cc ON cr.cr_call_center_sk = cc.cc_call_center_sk
INNER JOIN filtered_customers fc ON cr.cr_returning_customer_sk = fc.c_customer_sk
WHERE d.d_year = 1999
  AND d.d_moy = 5;