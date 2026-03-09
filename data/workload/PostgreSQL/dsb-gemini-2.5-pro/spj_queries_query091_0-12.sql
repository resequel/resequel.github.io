WITH filtered_customers AS
  (SELECT c.c_customer_sk
   FROM customer c
   JOIN customer_demographics cd ON c.c_current_cdemo_sk = cd.cd_demo_sk
   JOIN household_demographics hd ON c.c_current_hdemo_sk = hd.hd_demo_sk
   JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
   WHERE ((cd.cd_marital_status = 'M'
           AND cd.cd_education_status = 'Unknown')
          OR (cd.cd_marital_status = 'W'
              AND cd.cd_education_status = 'Advanced Degree'))
     AND hd.hd_buy_potential LIKE '0-500%'
     AND ca.ca_gmt_offset = -7)
SELECT min(cc.cc_call_center_id),
       min(cc.cc_name),
       min(cc.cc_manager),
       min(cr.cr_net_loss),
       min(cr.cr_item_sk),
       min(cr.cr_order_number)
FROM catalog_returns cr
JOIN call_center cc ON cr.cr_call_center_sk = cc.cc_call_center_sk
JOIN filtered_customers fc ON cr.cr_returning_customer_sk = fc.c_customer_sk
WHERE cr.cr_returned_date_sk IN
    (SELECT d_date_sk
     FROM date_dim
     WHERE d_year = 1999
       AND d_moy = 5);