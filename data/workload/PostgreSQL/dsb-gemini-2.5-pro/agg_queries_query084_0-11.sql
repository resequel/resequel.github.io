WITH filtered_ca AS
  (SELECT ca_address_sk
   FROM customer_address
   WHERE ca_city = 'Hopewell'),
     filtered_ib AS
  (SELECT ib_income_band_sk
   FROM income_band
   WHERE ib_lower_bound >= 32287
     AND ib_upper_bound <= 32287 + 50000),
     filtered_hd AS
  (SELECT hd.hd_demo_sk
   FROM household_demographics hd
   JOIN filtered_ib fi ON hd.hd_income_band_sk = fi.ib_income_band_sk)
SELECT c.c_customer_id AS customer_id,
       coalesce(c.c_last_name, '') || ', ' || coalesce(c.c_first_name, '') AS customername
FROM customer c
JOIN filtered_ca ON c.c_current_addr_sk = filtered_ca.ca_address_sk
JOIN filtered_hd ON c.c_current_hdemo_sk = filtered_hd.hd_demo_sk
WHERE EXISTS
    (SELECT 1
     FROM store_returns sr
     WHERE sr.sr_cdemo_sk = c.c_current_cdemo_sk)
ORDER BY c_customer_id
LIMIT 100;