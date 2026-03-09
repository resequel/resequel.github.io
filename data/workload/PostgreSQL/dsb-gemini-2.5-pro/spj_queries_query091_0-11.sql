
SELECT min(cc.cc_call_center_id),
       min(cc.cc_name),
       min(cc.cc_manager),
       min(cr.cr_net_loss),
       min(cr.cr_item_sk),
       min(cr.cr_order_number)
FROM catalog_returns AS cr
INNER JOIN call_center AS cc ON cr.cr_call_center_sk = cc.cc_call_center_sk
WHERE cr.cr_returned_date_sk IN
    (SELECT d_date_sk
     FROM date_dim
     WHERE d_year = 1999
       AND d_moy = 5)
  AND cr.cr_returning_customer_sk IN
    (SELECT c_customer_sk
     FROM customer
     WHERE c_current_addr_sk IN
         (SELECT ca_address_sk
          FROM customer_address
          WHERE ca_gmt_offset = -7)
       AND c_current_hdemo_sk IN
         (SELECT hd_demo_sk
          FROM household_demographics
          WHERE hd_buy_potential LIKE '0-500%')
       AND c_current_cdemo_sk IN
         (SELECT cd_demo_sk
          FROM customer_demographics
          WHERE (cd_marital_status = 'M'
                 AND cd_education_status = 'Unknown')
            OR (cd_marital_status = 'W'
                AND cd_education_status = 'Advanced Degree')));