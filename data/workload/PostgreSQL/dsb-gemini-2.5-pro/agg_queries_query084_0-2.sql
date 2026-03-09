WITH filtered_customers AS
  (SELECT c.c_customer_id,
          c.c_last_name,
          c.c_first_name,
          c.c_current_cdemo_sk
   FROM customer c
   JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
   JOIN household_demographics hd ON c.c_current_hdemo_sk = hd.hd_demo_sk
   JOIN income_band ib ON hd.hd_income_band_sk = ib.ib_income_band_sk
   WHERE ca.ca_city = 'Hopewell'
     AND ib.ib_lower_bound >= 32287
     AND ib.ib_upper_bound <= 32287 + 50000),
     returned_demos AS
  (SELECT DISTINCT sr_cdemo_sk
   FROM store_returns)
SELECT fc.c_customer_id AS customer_id,
       coalesce(fc.c_last_name, '') || ', ' || coalesce(fc.c_first_name, '') AS customername
FROM filtered_customers fc
JOIN returned_demos rd ON fc.c_current_cdemo_sk = rd.sr_cdemo_sk
ORDER BY c_customer_id
LIMIT 100;