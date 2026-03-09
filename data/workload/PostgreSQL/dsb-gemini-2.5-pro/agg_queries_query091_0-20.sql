WITH filtered_customers AS
  (SELECT c.c_customer_sk,
          c.c_current_cdemo_sk
   FROM customer c
   JOIN household_demographics hd ON c.c_current_hdemo_sk = hd.hd_demo_sk
   JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
   WHERE ca.ca_gmt_offset = -7
     AND hd.hd_buy_potential LIKE '0-500%'),
     unioned_returns AS
  (SELECT cr.cr_call_center_sk,
          cr.cr_net_loss,
          cd.cd_marital_status,
          cd.cd_education_status
   FROM catalog_returns cr
   JOIN filtered_customers fc ON cr.cr_returning_customer_sk = fc.c_customer_sk
   JOIN customer_demographics cd ON fc.c_current_cdemo_sk = cd.cd_demo_sk
   WHERE cr.cr_returned_date_sk IN
       (SELECT d_date_sk
        FROM date_dim
        WHERE d_year = 1999
          AND d_moy = 5)
     AND cd.cd_marital_status = 'M'
     AND cd.cd_education_status = 'Unknown'
   UNION ALL SELECT cr.cr_call_center_sk,
                    cr.cr_net_loss,
                    cd.cd_marital_status,
                    cd.cd_education_status
   FROM catalog_returns cr
   JOIN filtered_customers fc ON cr.cr_returning_customer_sk = fc.c_customer_sk
   JOIN customer_demographics cd ON fc.c_current_cdemo_sk = cd.cd_demo_sk
   WHERE cr.cr_returned_date_sk IN
       (SELECT d_date_sk
        FROM date_dim
        WHERE d_year = 1999
          AND d_moy = 5)
     AND cd.cd_marital_status = 'W'
     AND cd.cd_education_status = 'Advanced Degree')
SELECT cc.cc_call_center_id Call_Center,
       cc.cc_name Call_Center_Name,
       cc.cc_manager Manager,
       sum(ur.cr_net_loss) Returns_Loss
FROM unioned_returns ur
JOIN call_center cc ON ur.cr_call_center_sk = cc.cc_call_center_sk
GROUP BY cc.cc_call_center_id,
         cc.cc_name,
         cc.cc_manager,
         ur.cd_marital_status,
         ur.cd_education_status
ORDER BY sum(ur.cr_net_loss) DESC;