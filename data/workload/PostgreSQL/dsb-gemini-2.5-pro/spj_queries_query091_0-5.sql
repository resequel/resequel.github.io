
SELECT min(cc.cc_call_center_id),
       min(cc.cc_name),
       min(cc.cc_manager),
       min(cr.cr_net_loss),
       min(cr.cr_item_sk),
       min(cr.cr_order_number)
FROM catalog_returns AS cr
INNER JOIN call_center AS cc ON cr.cr_call_center_sk = cc.cc_call_center_sk
WHERE EXISTS
    (SELECT 1
     FROM date_dim
     WHERE d_date_sk = cr.cr_returned_date_sk
       AND d_year = 1999
       AND d_moy = 5)
  AND EXISTS
    (SELECT 1
     FROM customer c
     WHERE c.c_customer_sk = cr.cr_returning_customer_sk
       AND EXISTS
         (SELECT 1
          FROM customer_address
          WHERE ca_address_sk = c.c_current_addr_sk
            AND ca_gmt_offset = -7)
       AND EXISTS
         (SELECT 1
          FROM household_demographics
          WHERE hd_demo_sk = c.c_current_hdemo_sk
            AND hd_buy_potential LIKE '0-500%')
       AND EXISTS
         (SELECT 1
          FROM customer_demographics
          WHERE cd_demo_sk = c.c_current_cdemo_sk
            AND ((cd_marital_status = 'M'
                  AND cd_education_status = 'Unknown')
                 OR (cd_marital_status = 'W'
                     AND cd_education_status = 'Advanced Degree'))));