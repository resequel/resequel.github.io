
SELECT c.c_customer_id AS customer_id,
       coalesce(c.c_last_name, '') || ', ' || coalesce(c.c_first_name, '') AS customername
FROM customer c
WHERE c.c_current_addr_sk IN
    (SELECT ca_address_sk
     FROM customer_address
     WHERE ca_city = 'Hopewell')
  AND c.c_current_hdemo_sk IN
    (SELECT hd_demo_sk
     FROM household_demographics hd
     JOIN income_band ib ON hd.hd_income_band_sk = ib.ib_income_band_sk
     WHERE ib.ib_lower_bound >= 32287
       AND ib.ib_upper_bound <= 32287 + 50000)
  AND EXISTS
    (SELECT 1
     FROM store_returns sr
     WHERE sr.sr_cdemo_sk = c.c_current_cdemo_sk)
ORDER BY c_customer_id
LIMIT 100;