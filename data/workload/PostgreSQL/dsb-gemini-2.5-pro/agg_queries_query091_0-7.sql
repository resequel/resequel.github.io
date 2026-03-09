WITH filtered_dates AS
  (SELECT d_date_sk
   FROM date_dim
   WHERE d_year = 1999
     AND d_moy = 5),
     filtered_customers AS
  (SELECT c.c_customer_sk,
          cd.cd_marital_status,
          cd.cd_education_status
   FROM customer c
   JOIN customer_demographics cd ON c.c_current_cdemo_sk = cd.cd_demo_sk
   WHERE (cd.cd_marital_status,
          cd.cd_education_status) IN (('M', 'Unknown'), ('W', 'Advanced Degree'))
     AND c.c_current_hdemo_sk IN
       (SELECT hd_demo_sk
        FROM household_demographics
        WHERE hd_buy_potential LIKE '0-500%')
     AND c.c_current_addr_sk IN
       (SELECT ca_address_sk
        FROM customer_address
        WHERE ca_gmt_offset = -7))
SELECT cc.cc_call_center_id Call_Center,
       cc.cc_name Call_Center_Name,
       cc.cc_manager Manager,
       sum(cr.cr_net_loss) Returns_Loss
FROM catalog_returns cr
JOIN filtered_dates fd ON cr.cr_returned_date_sk = fd.d_date_sk
JOIN filtered_customers fc ON cr.cr_returning_customer_sk = fc.c_customer_sk
JOIN call_center cc ON cr.cr_call_center_sk = cc.cc_call_center_sk
GROUP BY cc.cc_call_center_id,
         cc.cc_name,
         cc.cc_manager,
         fc.cd_marital_status,
         fc.cd_education_status
ORDER BY sum(cr.cr_net_loss) DESC;