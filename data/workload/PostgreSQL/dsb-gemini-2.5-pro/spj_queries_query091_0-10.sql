WITH filtered_dates AS
  (SELECT d_date_sk
   FROM date_dim
   WHERE d_year = 1999
     AND d_moy = 5),
     filtered_cdemo AS
  (SELECT cd_demo_sk
   FROM customer_demographics
   WHERE (cd_marital_status = 'M'
          AND cd_education_status = 'Unknown')
     OR (cd_marital_status = 'W'
         AND cd_education_status = 'Advanced Degree')),
     filtered_hdemo AS
  (SELECT hd_demo_sk
   FROM household_demographics
   WHERE hd_buy_potential LIKE '0-500%'),
     filtered_addr AS
  (SELECT ca_address_sk
   FROM customer_address
   WHERE ca_gmt_offset = -7)
SELECT min(cc.cc_call_center_id),
       min(cc.cc_name),
       min(cc.cc_manager),
       min(cr.cr_net_loss),
       min(cr.cr_item_sk),
       min(cr.cr_order_number)
FROM catalog_returns cr
JOIN filtered_dates fd ON cr.cr_returned_date_sk = fd.d_date_sk
JOIN call_center cc ON cr.cr_call_center_sk = cc.cc_call_center_sk
JOIN customer c ON cr.cr_returning_customer_sk = c.c_customer_sk
JOIN filtered_cdemo fcd ON c.c_current_cdemo_sk = fcd.cd_demo_sk
JOIN filtered_hdemo fhd ON c.c_current_hdemo_sk = fhd.hd_demo_sk
JOIN filtered_addr fa ON c.c_current_addr_sk = fa.ca_address_sk;