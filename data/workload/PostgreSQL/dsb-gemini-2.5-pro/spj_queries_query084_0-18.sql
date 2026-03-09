
SELECT min(c.c_customer_id),
       min(sr.sr_ticket_number),
       min(sr.sr_item_sk)
FROM customer c
JOIN customer_demographics cd ON c.c_current_cdemo_sk = cd.cd_demo_sk
JOIN store_returns sr ON cd.cd_demo_sk = sr.sr_cdemo_sk
WHERE EXISTS
    (SELECT 1
     FROM customer_address ca
     WHERE ca.ca_address_sk = c.c_current_addr_sk
       AND ca.ca_city = 'Hopewell')
  AND EXISTS
    (SELECT 1
     FROM household_demographics hd
     JOIN income_band ib ON hd.hd_income_band_sk = ib.ib_income_band_sk
     WHERE hd.hd_demo_sk = c.c_current_hdemo_sk
       AND ib.ib_lower_bound >= 3 * 10000
       AND ib.ib_upper_bound <= 3 * 10000 + 50000);