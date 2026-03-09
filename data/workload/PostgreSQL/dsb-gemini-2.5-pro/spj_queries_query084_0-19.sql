
SELECT min(c.c_customer_id),
       min(sr.sr_ticket_number),
       min(sr.sr_item_sk)
FROM customer c
JOIN customer_demographics cd ON c.c_current_cdemo_sk = cd.cd_demo_sk
JOIN store_returns sr ON cd.cd_demo_sk = sr.sr_cdemo_sk
WHERE c.c_current_addr_sk IN
    (SELECT ca_address_sk
     FROM customer_address
     WHERE ca_city = 'Hopewell')
  AND c.c_current_hdemo_sk IN
    (SELECT hd.hd_demo_sk
     FROM household_demographics hd
     JOIN income_band ib ON hd.hd_income_band_sk = ib.ib_income_band_sk
     WHERE ib.ib_lower_bound >= 3 * 10000
       AND ib.ib_upper_bound <= 3 * 10000 + 50000);