
SELECT c.c_customer_id AS customer_id,
       coalesce(c.c_last_name, '') || ', ' || coalesce(c.c_first_name, '') AS customername
FROM customer c,
     customer_address ca,
     customer_demographics cd,
     household_demographics hd,
     income_band ib,
     store_returns sr
WHERE c.c_current_addr_sk = ca.ca_address_sk
  AND c.c_current_cdemo_sk = cd.cd_demo_sk
  AND c.c_current_hdemo_sk = hd.hd_demo_sk
  AND hd.hd_income_band_sk = ib.ib_income_band_sk
  AND cd.cd_demo_sk = sr.sr_cdemo_sk
  AND ca.ca_city = 'Hopewell'
  AND ib.ib_lower_bound >= 32287
  AND ib.ib_upper_bound <= 32287 + 50000
ORDER BY c_customer_id
LIMIT 100;