
SELECT min(c_customer_id),
       min(sr_ticket_number),
       min(sr_item_sk)
FROM customer
INNER JOIN customer_address ON c_current_addr_sk = ca_address_sk
INNER JOIN customer_demographics ON c_current_cdemo_sk = cd_demo_sk
INNER JOIN household_demographics ON c_current_hdemo_sk = hd_demo_sk
INNER JOIN income_band ON hd_income_band_sk = ib_income_band_sk
INNER JOIN store_returns ON sr_cdemo_sk = cd_demo_sk
WHERE ca_city = 'Hopewell'
  AND ib_lower_bound >= 3 * 10000
  AND ib_upper_bound <= 3 * 10000 + 50000;