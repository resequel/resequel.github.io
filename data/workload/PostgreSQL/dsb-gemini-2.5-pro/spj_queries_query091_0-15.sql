WITH filtered_dates AS
  (SELECT d_date_sk
   FROM date_dim
   WHERE d_year = 1999
     AND d_moy = 5),
     filtered_cust_demos AS
  (SELECT cd_demo_sk
   FROM customer_demographics
   WHERE (cd_marital_status = 'M'
          AND cd_education_status = 'Unknown')
     OR (cd_marital_status = 'W'
         AND cd_education_status = 'Advanced Degree')),
     filtered_house_demos AS
  (SELECT hd_demo_sk
   FROM household_demographics
   WHERE hd_buy_potential LIKE '0-500%'),
     filtered_addresses AS
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
INNER JOIN filtered_dates d ON cr.cr_returned_date_sk = d.d_date_sk
INNER JOIN call_center cc ON cr.cr_call_center_sk = cc.cc_call_center_sk
INNER JOIN customer c ON cr.cr_returning_customer_sk = c.c_customer_sk
INNER JOIN filtered_cust_demos cd ON c.c_current_cdemo_sk = cd.cd_demo_sk
INNER JOIN filtered_house_demos hd ON c.c_current_hdemo_sk = hd.hd_demo_sk
INNER JOIN filtered_addresses ca ON c.c_current_addr_sk = ca.ca_address_sk;