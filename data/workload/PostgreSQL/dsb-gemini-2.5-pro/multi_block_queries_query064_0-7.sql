WITH interesting_catalog_items AS
  (SELECT cs_item_sk
   FROM catalog_sales
   JOIN catalog_returns ON cs_item_sk = cr_item_sk
   AND cs_order_number = cr_order_number
   WHERE cs_wholesale_cost BETWEEN 80 AND 100
   GROUP BY cs_item_sk
   HAVING sum(cs_ext_list_price) > 2 * sum(cr_refunded_cash + cr_reversed_charge + cr_store_credit)),
     aggregated_sales AS
  (SELECT i.i_product_name,
          i.i_item_sk,
          s.s_store_name,
          s.s_zip,
          ad1.ca_street_number b_street_number,
          ad1.ca_street_name b_street_name,
          ad1.ca_city b_city,
          ad1.ca_zip b_zip,
          ad2.ca_street_number c_street_number,
          ad2.ca_street_name c_street_name,
          ad2.ca_city c_city,
          ad2.ca_zip c_zip,
          d2.d_year AS fsyear,
          d3.d_year AS s2year,
          sum(CASE
                  WHEN d1.d_year = 1999 THEN 1
                  ELSE 0
              END) AS cnt1,
          sum(CASE
                  WHEN d1.d_year = 1999 THEN ss.ss_wholesale_cost
                  ELSE 0
              END) AS s11,
          sum(CASE
                  WHEN d1.d_year = 1999 THEN ss.ss_list_price
                  ELSE 0
              END) AS s21,
          sum(CASE
                  WHEN d1.d_year = 1999 THEN ss.ss_coupon_amt
                  ELSE 0
              END) AS s31,
          sum(CASE
                  WHEN d1.d_year = 1999 + 1 THEN 1
                  ELSE 0
              END) AS cnt2,
          sum(CASE
                  WHEN d1.d_year = 1999 + 1 THEN ss.ss_wholesale_cost
                  ELSE 0
              END) AS s12,
          sum(CASE
                  WHEN d1.d_year = 1999 + 1 THEN ss.ss_list_price
                  ELSE 0
              END) AS s22,
          sum(CASE
                  WHEN d1.d_year = 1999 + 1 THEN ss.ss_coupon_amt
                  ELSE 0
              END) AS s32
   FROM store_sales ss
   JOIN store_returns sr ON ss.ss_item_sk = sr.sr_item_sk
   AND ss.ss_ticket_number = sr.sr_ticket_number
   JOIN interesting_catalog_items ici ON ss.ss_item_sk = ici.cs_item_sk
   JOIN item i ON ss.ss_item_sk = i.i_item_sk
   JOIN store s ON ss.s_store_sk = s.s_store_sk
   JOIN date_dim d1 ON ss.ss_sold_date_sk = d1.d_date_sk
   JOIN customer c ON ss.ss_customer_sk = c.c_customer_sk
   JOIN customer_demographics cd1 ON ss.ss_cdemo_sk = cd1.cd_demo_sk
   JOIN customer_demographics cd2 ON c.c_current_cdemo_sk = cd2.cd_demo_sk
   JOIN household_demographics hd1 ON ss.ss_hdemo_sk = hd1.hd_demo_sk
   JOIN household_demographics hd2 ON c.c_current_hdemo_sk = hd2.hd_demo_sk
   JOIN customer_address ad1 ON ss.ss_addr_sk = ad1.ca_address_sk
   JOIN customer_address ad2 ON c.c_current_addr_sk = ad2.ca_address_sk
   JOIN income_band ib1 ON hd1.hd_income_band_sk = ib1.ib_income_band_sk
   JOIN income_band ib2 ON hd2.hd_income_band_sk = ib2.ib_income_band_sk
   JOIN promotion p ON ss.ss_promo_sk = p.p_promo_sk
   JOIN date_dim d2 ON c.c_first_sales_date_sk = d2.d_date_sk
   JOIN date_dim d3 ON c.c_first_shipto_date_sk = d3.d_date_sk
   WHERE d1.d_year IN (1999, 1999 + 1)
     AND i.i_current_price BETWEEN 1 AND 1 + 10
     AND p.p_channel_email = 'Y'
     AND p.p_channel_tv = 'Y'
     AND p.p_channel_radio = 'Y'
     AND ad2.ca_state IN ('GA',
                          'IL',
                          'OH')
     AND ss.ss_wholesale_cost BETWEEN 80 AND 100
     AND cd1.cd_marital_status IN ('W',
                                   'W',
                                   'D')
     AND cd1.cd_education_status IN ('College',
                                     '4 yr Degree',
                                     'College')
     AND cd2.cd_marital_status IN ('W',
                                   'W',
                                   'D')
     AND cd2.cd_education_status IN ('College',
                                     '4 yr Degree',
                                     'College')
     AND cd1.cd_marital_status <> cd2.cd_marital_status
   GROUP BY i.i_product_name,
            i.i_item_sk,
            s.s_store_name,
            s.s_zip,
            ad1.ca_street_number,
            ad1.ca_street_name,
            ad1.ca_city,
            ad1.ca_zip,
            ad2.ca_street_number,
            ad2.ca_street_name,
            ad2.ca_city,
            ad2.ca_zip,
            d2.d_year,
            d3.d_year)
SELECT product_name,
       store_name,
       store_zip,
       b_street_number,
       b_street_name,
       b_city,
       b_zip,
       c_street_number,
       c_street_name,
       c_city,
       c_zip, 1999 AS syear,
                 cnt1 AS cnt,
                 s11,
                 s21,
                 s31,
                 s12,
                 s22,
                 s32, 1999 + 1 AS syear,
                                 cnt2 AS cnt
FROM aggregated_sales
WHERE cnt2 <= cnt1
  AND cnt1 > 0
ORDER BY product_name,
         store_name,
         cnt2,
         s11,
         s12;