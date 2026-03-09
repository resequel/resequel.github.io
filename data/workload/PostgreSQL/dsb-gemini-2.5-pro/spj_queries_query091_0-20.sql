
SELECT min(cc.cc_call_center_id),
       min(cc.cc_name),
       min(cc.cc_manager),
       min(cr.cr_net_loss),
       min(cr.cr_item_sk),
       min(cr.cr_order_number)
FROM catalog_returns AS cr
INNER JOIN date_dim AS d ON cr.cr_returned_date_sk = d.d_date_sk
INNER JOIN customer AS c ON cr.cr_returning_customer_sk = c.c_customer_sk
INNER JOIN customer_demographics AS cd ON c.c_current_cdemo_sk = cd.cd_demo_sk
INNER JOIN household_demographics AS hd ON c.c_current_hdemo_sk = hd.hd_demo_sk
INNER JOIN customer_address AS ca ON c.c_current_addr_sk = ca.ca_address_sk
INNER JOIN call_center AS cc ON cr.cr_call_center_sk = cc.cc_call_center_sk
WHERE d.d_year = 1999
  AND d.d_moy = 5
  AND (cd.cd_marital_status,
       cd.cd_education_status) IN (('M', 'Unknown'), ('W', 'Advanced Degree'))
  AND hd.hd_buy_potential LIKE '0-500%'
  AND ca.ca_gmt_offset = -7;