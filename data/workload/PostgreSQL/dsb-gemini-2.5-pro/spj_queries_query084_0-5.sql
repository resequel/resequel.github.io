
SELECT min(c.c_customer_id),
       min(sr.sr_ticket_number),
       min(sr.sr_item_sk)
FROM income_band ib
JOIN household_demographics hd ON ib.ib_income_band_sk = hd.hd_income_band_sk
JOIN customer c ON hd.hd_demo_sk = c.c_current_hdemo_sk
JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
JOIN customer_demographics cd ON c.c_current_cdemo_sk = cd.cd_demo_sk
JOIN store_returns sr ON cd.cd_demo_sk = sr.sr_cdemo_sk
WHERE ca.ca_city = 'Hopewell'
  AND ib.ib_lower_bound >= 3 * 10000
  AND ib.ib_upper_bound <= 3 * 10000 + 50000;