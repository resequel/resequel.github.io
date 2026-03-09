WITH cs_ui AS
  (SELECT cs_item_sk
   FROM catalog_sales
   JOIN catalog_returns ON cs_item_sk = cr_item_sk
   AND cs_order_number = cr_order_number
   WHERE cs_wholesale_cost BETWEEN 80 AND 100
   GROUP BY cs_item_sk
   HAVING sum(cs_ext_list_price) > 2 * sum(cr_refunded_cash+cr_reversed_charge+cr_store_credit)),
     filtered_ss AS
  (SELECT *
   FROM store_sales
   WHERE ss_wholesale_cost BETWEEN 80 AND 100),
     filtered_cd1 AS
  (SELECT *
   FROM customer_demographics
   WHERE cd_marital_status IN ('W',
                                   'W',
                                   'D')
     AND cd_education_status IN ('College',
                                     '4 yr Degree',
                                     'College')),
     filtered_cd2 AS
  (SELECT *
   FROM customer_demographics
   WHERE cd_marital_status IN ('W',
                                   'W',
                                   'D')
     AND cd_education_status IN ('College',
                                     '4 yr Degree',
                                     'College')),
     cross_sales AS
  (SELECT i_product_name product_name,
          i_item_sk item_sk,
          s_store_name store_name,
          s_zip store_zip,
          ad1.ca_street_number b_street_number,
          ad1.ca_street_name b_street_name,
          ad1.ca_city b_city,
          ad1.ca_zip b_zip,
          ad2.ca_street_number c_street_number,
          ad2.ca_street_name c_street_name,
          ad2.ca_city c_city,
          ad2.ca_zip c_zip,
          d1.d_year AS syear,
          d2.d_year AS fsyear,
          d3.d_year s2year,
          count(*) cnt,
          sum(ss.ss_wholesale_cost) s1,
          sum(ss.ss_list_price) s2,
          sum(ss.ss_coupon_amt) s3
   FROM filtered_ss ss
   JOIN store_returns sr ON ss.ss_item_sk = sr.sr_item_sk
   AND ss.ss_ticket_number = sr.sr_ticket_number
   JOIN cs_ui ON ss.ss_item_sk = cs_ui.cs_item_sk
   JOIN item i ON ss.ss_item_sk = i.i_item_sk
   JOIN store s ON ss.s_store_sk = s.s_store_sk
   JOIN date_dim d1 ON ss.ss_sold_date_sk = d1.d_date_sk
   JOIN customer c ON ss.ss_customer_sk = c.c_customer_sk
   JOIN filtered_cd1 cd1 ON ss.ss_cdemo_sk = cd1.cd_demo_sk
   JOIN filtered_cd2 cd2 ON c.c_current_cdemo_sk = cd2.cd_demo_sk
   JOIN household_demographics hd1 ON ss.ss_hdemo_sk = hd1.hd_demo_sk
   JOIN household_demographics hd2 ON c.c_current_hdemo_sk = hd2.hd_demo_sk
   JOIN customer_address ad1 ON ss.ss_addr_sk = ad1.ca_address_sk
   JOIN customer_address ad2 ON c.c_current_addr_sk = ad2.ca_address_sk
   JOIN income_band ib1 ON hd1.hd_income_band_sk = ib1.ib_income_band_sk
   JOIN income_band ib2 ON hd2.hd_income_band_sk = ib2.ib_income_band_sk
   JOIN promotion p ON ss.ss_promo_sk = p.p_promo_sk
   JOIN date_dim d2 ON c.c_first_sales_date_sk = d2.d_date_sk
   JOIN date_dim d3 ON c.c_first_shipto_date_sk = d3.d_date_sk
   WHERE cd1.cd_marital_status <> cd2.cd_marital_status
     AND i.i_current_price BETWEEN 1 AND 1 + 10
     AND p.p_channel_email = 'Y'
     AND p.p_channel_tv = 'Y'
     AND p.p_channel_radio = 'Y'
     AND ad2.ca_state IN ('GA',
                          'IL',
                          'OH')
   GROUP BY i_product_name,
            i_item_sk,
            s_store_name,
            s_zip,
            ad1.ca_street_number,
            ad1.ca_street_name,
            ad1.ca_city,
            ad1.ca_zip,
            ad2.ca_street_number,
            ad2.ca_street_name,
            ad2.ca_city,
            ad2.ca_zip,
            d1.d_year,
            d2.d_year,
            d3.d_year)
SELECT cs1.product_name,
       cs1.store_name,
       cs1.store_zip,
       cs1.b_street_number,
       cs1.b_street_name,
       cs1.b_city,
       cs1.b_zip,
       cs1.c_street_number,
       cs1.c_street_name,
       cs1.c_city,
       cs1.c_zip,
       cs1.syear,
       cs1.cnt,
       cs1.s1 AS s11,
       cs1.s2 AS s21,
       cs1.s3 AS s31,
       cs2.s1 AS s12,
       cs2.s2 AS s22,
       cs2.s3 AS s32,
       cs2.syear,
       cs2.cnt
FROM cross_sales cs1,
     cross_sales cs2
WHERE cs1.item_sk=cs2.item_sk
  AND cs1.syear = 1999
  AND cs2.syear = 1999 + 1
  AND cs2.cnt <= cs1.cnt
  AND cs1.store_name = cs2.store_name
  AND cs1.store_zip = cs2.store_zip
ORDER BY cs1.product_name,
         cs1.store_name,
         cs2.cnt,
         cs1.s1,
         cs2.s1;