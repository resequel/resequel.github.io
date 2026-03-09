WITH results AS
  (SELECT cc.cc_call_center_id,
          cc.cc_name,
          cc.cc_manager,
          cr.cr_net_loss
   FROM catalog_returns cr
   JOIN date_dim d ON cr.cr_returned_date_sk = d.d_date_sk
   JOIN customer c ON cr.cr_returning_customer_sk = c.c_customer_sk
   JOIN customer_demographics cd ON c.c_current_cdemo_sk = cd.cd_demo_sk
   JOIN household_demographics hd ON c.c_current_hdemo_sk = hd.hd_demo_sk
   JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
   JOIN call_center cc ON cr.cr_call_center_sk = cc.cc_call_center_sk
   WHERE d.d_year = 1999
     AND d.d_moy = 5
     AND hd.hd_buy_potential LIKE '0-500%'
     AND ca.ca_gmt_offset = -7
     AND cd.cd_marital_status = 'M'
     AND cd.cd_education_status = 'Unknown'
   UNION ALL SELECT cc.cc_call_center_id,
                    cc.cc_name,
                    cc.cc_manager,
                    cr.cr_net_loss
   FROM catalog_returns cr
   JOIN date_dim d ON cr.cr_returned_date_sk = d.d_date_sk
   JOIN customer c ON cr.cr_returning_customer_sk = c.c_customer_sk
   JOIN customer_demographics cd ON c.c_current_cdemo_sk = cd.cd_demo_sk
   JOIN household_demographics hd ON c.c_current_hdemo_sk = hd.hd_demo_sk
   JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
   JOIN call_center cc ON cr.cr_call_center_sk = cc.cc_call_center_sk
   WHERE d.d_year = 1999
     AND d.d_moy = 5
     AND hd.hd_buy_potential LIKE '0-500%'
     AND ca.ca_gmt_offset = -7
     AND cd.cd_marital_status = 'W'
     AND cd.cd_education_status = 'Advanced Degree')
SELECT cc_call_center_id AS Call_Center,
       cc_name AS Call_Center_Name,
       cc_manager AS Manager,
       sum(cr_net_loss) AS Returns_Loss
FROM results
GROUP BY cc_call_center_id,
         cc_name,
         cc_manager
ORDER BY Returns_Loss DESC;