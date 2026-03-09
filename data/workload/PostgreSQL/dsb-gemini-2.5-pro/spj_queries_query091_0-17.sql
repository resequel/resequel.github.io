WITH filtered_returns_by_date AS
  (SELECT cr.cr_net_loss,
          cr.cr_item_sk,
          cr.cr_order_number,
          cr.cr_call_center_sk,
          cr.cr_returning_customer_sk
   FROM catalog_returns cr
   JOIN date_dim d ON cr.cr_returned_date_sk = d.d_date_sk
   WHERE d.d_year = 1999
     AND d.d_moy = 5)
SELECT min(cc.cc_call_center_id),
       min(cc.cc_name),
       min(cc.cc_manager),
       min(fr.cr_net_loss),
       min(fr.cr_item_sk),
       min(fr.cr_order_number)
FROM filtered_returns_by_date fr
JOIN call_center cc ON fr.cr_call_center_sk = cc.cc_call_center_sk
WHERE EXISTS
    (SELECT 1
     FROM customer c
     JOIN customer_demographics cd ON c.c_current_cdemo_sk = cd.cd_demo_sk
     JOIN household_demographics hd ON c.c_current_hdemo_sk = hd.hd_demo_sk
     JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
     WHERE fr.cr_returning_customer_sk = c.c_customer_sk
       AND ((cd.cd_marital_status = 'M'
             AND cd.cd_education_status = 'Unknown')
            OR (cd.cd_marital_status = 'W'
                AND cd.cd_education_status = 'Advanced Degree'))
       AND hd.hd_buy_potential LIKE '0-500%'
       AND ca.ca_gmt_offset = -7);