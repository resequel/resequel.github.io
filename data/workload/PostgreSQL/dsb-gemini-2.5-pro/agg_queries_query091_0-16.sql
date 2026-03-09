
SELECT cc.cc_call_center_id AS Call_Center,
       cc.cc_name AS Call_Center_Name,
       cc.cc_manager AS Manager,
       sum(cr.cr_net_loss) AS Returns_Loss
FROM catalog_returns cr
JOIN call_center cc ON cr.cr_call_center_sk = cc.cc_call_center_sk
WHERE EXISTS
    (SELECT 1
     FROM date_dim d
     WHERE cr.cr_returned_date_sk = d.d_date_sk
       AND d.d_year = 1999
       AND d.d_moy = 5)
  AND EXISTS
    (SELECT 1
     FROM customer c
     JOIN customer_demographics cd ON c.c_current_cdemo_sk = cd.cd_demo_sk
     JOIN household_demographics hd ON c.c_current_hdemo_sk = hd.hd_demo_sk
     JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
     WHERE cr.cr_returning_customer_sk = c.c_customer_sk
       AND ca.ca_gmt_offset = -7
       AND hd.hd_buy_potential LIKE '0-500%'
       AND (cd.cd_marital_status,
            cd.cd_education_status) IN (('M', 'Unknown'), ('W', 'Advanced Degree')))
GROUP BY cc.cc_call_center_id,
         cc.cc_name,
         cc.cc_manager
ORDER BY sum(cr.cr_net_loss) DESC;