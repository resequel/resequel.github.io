WITH filtered_customer_info AS
  (SELECT c.c_customer_sk,
          cd.cd_marital_status,
          cd.cd_education_status
   FROM customer c
   JOIN customer_demographics cd ON c.c_current_cdemo_sk = cd.cd_demo_sk
   JOIN household_demographics hd ON c.c_current_hdemo_sk = hd.hd_demo_sk
   JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
   WHERE ca.ca_gmt_offset = -7
     AND hd.hd_buy_potential LIKE '0-500%'
     AND ((cd.cd_marital_status = 'M'
           AND cd.cd_education_status = 'Unknown')
          OR (cd.cd_marital_status = 'W'
              AND cd.cd_education_status = 'Advanced Degree')))
SELECT cc.cc_call_center_id Call_Center,
       cc.cc_name Call_Center_Name,
       cc.cc_manager Manager,
       sum(cr.cr_net_loss) Returns_Loss
FROM catalog_returns cr
JOIN date_dim d ON cr.cr_returned_date_sk = d.d_date_sk
JOIN filtered_customer_info fci ON cr.cr_returning_customer_sk = fci.c_customer_sk
JOIN call_center cc ON cr.cr_call_center_sk = cc.cc_call_center_sk
WHERE d.d_year = 1999
  AND d.d_moy = 5
GROUP BY cc.cc_call_center_id,
         cc.cc_name,
         cc.cc_manager,
         fci.cd_marital_status,
         fci.cd_education_status
ORDER BY sum(cr.cr_net_loss) DESC;