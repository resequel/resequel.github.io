WITH cs_ui AS
  (SELECT cs_item_sk
   FROM catalog_sales
   JOIN catalog_returns ON cs_item_sk = cr_item_sk
   AND cs_order_number = cr_order_number
   WHERE cs_wholesale_cost BETWEEN 80 AND 100
   GROUP BY cs_item_sk
   HAVING sum(cs_ext_list_price) > 2 * sum(cr_refunded_cash + cr_reversed_charge + cr_store_credit)),
     cross_sales_aggregated AS
  (SELECT i_product_name,
          i_item_sk,
          s_store_name,
          s_zip,
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
          COUNT(*) FILTER (
                           WHERE d1.d_year = 1999) AS cnt1,
          SUM(ss_wholesale_cost) FILTER (
                                         WHERE d1.d_year = 1999) AS s11,
          SUM(ss_list_price) FILTER (
                                     WHERE d1.d_year = 1999) AS s21,
          SUM(ss_coupon_amt) FILTER (
                                     WHERE d1.d_year = 1999) AS s31,
          COUNT(*) FILTER (
                           WHERE d1.d_year = 1999 + 1) AS cnt2,
          SUM(ss_wholesale_cost) FILTER (
                                         WHERE d1.d_year = 1999 + 1) AS s12,
          SUM(ss_list_price) FILTER (
                                     WHERE d1.d_year = 1999 + 1) AS s22,
          SUM(ss_coupon_amt) FILTER (
                                     WHERE d1.d_year = 1999 + 1) AS s32
   FROM store_sales
   JOIN store_returns ON ss_item_sk = sr_item_sk
   AND ss_ticket_number = sr_ticket_number
   JOIN cs_ui ON ss_item_sk = cs_ui.cs_item_sk
   JOIN date_dim d1 ON ss_sold_date_sk = d1.d_date_sk
   AND d1.d_year IN (1999, 1999 + 1)
   JOIN item ON ss_item_sk = i_item_sk
   AND i_current_price BETWEEN 1 AND 1 + 10
   JOIN store ON ss_store_sk = s_store_sk
   JOIN customer ON ss_customer_sk = c_customer_sk
   JOIN customer_demographics cd1 ON ss_cdemo_sk = cd1.cd_demo_sk
   AND cd1.cd_marital_status IN ('W',
                                   'W',
                                   'D')
   AND cd1.cd_education_status IN ('College',
                                     '4 yr Degree',
                                     'College')
   JOIN household_demographics hd1 ON ss_hdemo_sk = hd1.hd_demo_sk
   JOIN customer_address ad1 ON ss_addr_sk = ad1.ca_address_sk
   JOIN promotion ON ss_promo_sk = p_promo_sk
   AND p_channel_email = 'Y'
   AND p_channel_tv = 'Y'
   AND p_channel_radio = 'Y'
   JOIN customer_demographics cd2 ON c_current_cdemo_sk = cd2.cd_demo_sk
   AND cd2.cd_marital_status IN ('W',
                                   'W',
                                   'D')
   AND cd2.cd_education_status IN ('College',
                                     '4 yr Degree',
                                     'College')
   JOIN household_demographics hd2 ON c_current_hdemo_sk = hd2.hd_demo_sk
   JOIN customer_address ad2 ON c_current_addr_sk = ad2.ca_address_sk
   AND ad2.ca_state IN ('GA',
                          'IL',
                          'OH')
   JOIN income_band ib1 ON hd1.hd_income_band_sk = ib1.ib_income_band_sk
   JOIN income_band ib2 ON hd2.hd_income_band_sk = ib2.ib_income_band_sk
   JOIN date_dim d2 ON c_first_sales_date_sk = d2.d_date_sk
   JOIN date_dim d3 ON c_first_shipto_date_sk = d3.d_date_sk
   WHERE ss_wholesale_cost BETWEEN 80 AND 100
     AND cd1.cd_marital_status <> cd2.cd_marital_status
   GROUP BY i_product_name,
            i_item_sk,
            s_store_name,
            s_zip,
            b_street_number,
            b_street_name,
            b_city,
            b_zip,
            c_street_number,
            c_street_name,
            c_city,
            c_zip,
            fsyear,
            s2year)
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
FROM cross_sales_aggregated
WHERE cnt2 <= cnt1
  AND cnt1 > 0
ORDER BY product_name,
         store_name,
         cnt2,
         s11,
         s12;