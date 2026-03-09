WITH filtered_customers AS
  (SELECT c.c_customer_id,
          c.c_current_cdemo_sk
   FROM customer c
   WHERE c.c_current_addr_sk IN
       (SELECT ca_address_sk
        FROM customer_address
        WHERE ca_city = 'Hopewell')
     AND c.c_current_hdemo_sk IN
       (SELECT hd_demo_sk
        FROM household_demographics
        WHERE hd_income_band_sk IN
            (SELECT ib_income_band_sk
             FROM income_band
             WHERE ib_lower_bound >= 3 * 10000
               AND ib_upper_bound <= 3 * 10000 + 50000)))
SELECT min(fc.c_customer_id),
       min(sr.sr_ticket_number),
       min(sr.sr_item_sk)
FROM store_returns sr
JOIN customer_demographics cd ON sr.sr_cdemo_sk = cd.cd_demo_sk
JOIN filtered_customers fc ON cd.cd_demo_sk = fc.c_current_cdemo_sk;