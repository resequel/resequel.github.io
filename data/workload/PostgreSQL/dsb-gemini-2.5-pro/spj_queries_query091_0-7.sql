WITH filtered_customers AS
  (SELECT c_customer_sk
   FROM customer
   INNER JOIN customer_demographics ON c_current_cdemo_sk = cd_demo_sk
   INNER JOIN household_demographics ON c_current_hdemo_sk = hd_demo_sk
   INNER JOIN customer_address ON c_current_addr_sk = ca_address_sk
   WHERE ca_gmt_offset = -7
     AND hd_buy_potential LIKE '0-500%'
     AND ((cd_marital_status = 'M'
           AND cd_education_status = 'Unknown')
          OR (cd_marital_status = 'W'
              AND cd_education_status = 'Advanced Degree'))),
     filtered_dates AS
  (SELECT d_date_sk
   FROM date_dim
   WHERE d_year = 1999
     AND d_moy = 5)
SELECT min(cc.cc_call_center_id),
       min(cc.cc_name),
       min(cc.cc_manager),
       min(cr.cr_net_loss),
       min(cr.cr_item_sk),
       min(cr.cr_order_number)
FROM catalog_returns AS cr
INNER JOIN filtered_dates AS d ON cr.cr_returned_date_sk = d.d_date_sk
INNER JOIN filtered_customers AS c ON cr.cr_returning_customer_sk = c.c_customer_sk
INNER JOIN call_center AS cc ON cr.cr_call_center_sk = cc.cc_call_center_sk;