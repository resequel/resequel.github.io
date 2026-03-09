WITH qualified_customers AS
  (SELECT c.c_customer_sk
   FROM customer c
   JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
   WHERE ca.ca_city = 'Hopewell' INTERSECT SELECT c.c_customer_sk
   FROM customer c
   JOIN household_demographics hd ON c.c_current_hdemo_sk = hd.hd_demo_sk
   JOIN income_band ib ON hd.hd_income_band_sk = ib.ib_income_band_sk
   WHERE ib.ib_lower_bound >= 32287
     AND ib.ib_upper_bound <= 32287 + 50000 INTERSECT SELECT c.c_customer_sk
   FROM customer c
   JOIN store_returns sr ON c.c_current_cdemo_sk = sr.sr_cdemo_sk)
SELECT c.c_customer_id AS customer_id,
       coalesce(c.c_last_name, '') || ', ' || coalesce(c.c_first_name, '') AS customername
FROM customer c
JOIN qualified_customers qc ON c.c_customer_sk = qc.c_customer_sk
ORDER BY c.c_customer_id
LIMIT 100;