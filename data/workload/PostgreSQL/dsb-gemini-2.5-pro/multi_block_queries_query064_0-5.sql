WITH cs_ui AS
  (SELECT cs_item_sk
   FROM catalog_sales
   JOIN catalog_returns ON cs_item_sk = cr_item_sk
   AND cs_order_number = cr_order_number
   WHERE cs_wholesale_cost BETWEEN 80 AND 100
   GROUP BY cs_item_sk
   HAVING sum(cs_ext_list_price) > 2 * sum(cr_refunded_cash+cr_reversed_charge+cr_store_credit)),
     yearly_data AS
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
          d3.d_year s2year,
          d1.d_year,
          ss_wholesale_cost,
          ss_list_price,
          ss_coupon_amt
   FROM store_sales,
        store_returns,
        cs_ui,
        date_dim d1,
        date_dim d2,
        date_dim d3,
        store,
        customer,
        customer_demographics cd1,
        customer_demographics cd2,
        promotion,
        household_demographics hd1,
        household_demographics hd2,
        customer_address ad1,
        customer_address ad2,
        income_band ib1,
        income_band ib2,
        item
   WHERE ss_store_sk = s_store_sk
     AND ss_sold_date_sk = d1.d_date_sk
     AND ss_customer_sk = c_customer_sk
     AND ss_cdemo_sk= cd1.cd_demo_sk
     AND ss_hdemo_sk = hd1.hd_demo_sk
     AND ss_addr_sk = ad1.ca_address_sk
     AND ss_item_sk = i_item_sk
     AND ss_item_sk = sr_item_sk
     AND ss_ticket_number = sr_ticket_number
     AND ss_item_sk = cs_ui.cs_item_sk
     AND c_current_cdemo_sk = cd2.cd_demo_sk
     AND c_current_hdemo_sk = hd2.hd_demo_sk
     AND c_current_addr_sk = ad2.ca_address_sk
     AND c_first_sales_date_sk = d2.d_date_sk
     AND c_first_shipto_date_sk = d3.d_date_sk
     AND ss_promo_sk = p_promo_sk
     AND hd1.hd_income_band_sk = ib1.ib_income_band_sk
     AND hd2.hd_income_band_sk = ib2.ib_income_band_sk
     AND cd1.cd_marital_status <> cd2.cd_marital_status
     AND i_current_price BETWEEN 1 AND 1 + 10
     AND p_channel_email = 'Y'
     AND p_channel_tv = 'Y'
     AND p_channel_radio = 'Y'
     AND ad2.ca_state IN ('GA',
                          'IL',
                          'OH')
     AND ss_wholesale_cost BETWEEN 80 AND 100
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
     AND d1.d_year IN (1999, 1999 + 1)),
     aggregated_sales AS
  (SELECT i_product_name,
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
          s2year,
          MAX(CASE
                  WHEN d_year = 1999 THEN cnt
              END) AS cnt1,
          MAX(CASE
                  WHEN d_year = 1999 THEN s1
              END) AS s11,
          MAX(CASE
                  WHEN d_year = 1999 THEN s2
              END) AS s21,
          MAX(CASE
                  WHEN d_year = 1999 THEN s3
              END) AS s31,
          MAX(CASE
                  WHEN d_year = 1999 + 1 THEN cnt
              END) AS cnt2,
          MAX(CASE
                  WHEN d_year = 1999 + 1 THEN s1
              END) AS s12,
          MAX(CASE
                  WHEN d_year = 1999 + 1 THEN s2
              END) AS s22,
          MAX(CASE
                  WHEN d_year = 1999 + 1 THEN s3
              END) AS s32
   FROM
     (SELECT i_product_name,
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
             s2year,
             d_year,
             count(*) AS cnt,
             sum(ss_wholesale_cost) AS s1,
             sum(ss_list_price) AS s2,
             sum(ss_coupon_amt) AS s3
      FROM yearly_data
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
               s2year,
               d_year) AS grouped_data
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
FROM aggregated_sales
WHERE cnt2 <= cnt1
ORDER BY product_name,
         store_name,
         cnt2,
         s11,
         s12;