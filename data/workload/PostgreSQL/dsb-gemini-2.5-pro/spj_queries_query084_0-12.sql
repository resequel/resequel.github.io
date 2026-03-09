
SELECT min(qc.c_customer_id),
       min(sr.sr_ticket_number),
       min(sr.sr_item_sk)
FROM store_returns sr
JOIN
  (SELECT c.c_current_cdemo_sk,
          c.c_customer_id
   FROM income_band ib
   JOIN household_demographics hd ON ib.ib_income_band_sk = hd.hd_income_band_sk
   JOIN customer c ON hd.hd_demo_sk = c.c_current_hdemo_sk
   JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
   WHERE ca.ca_city = 'Hopewell'
     AND ib.ib_lower_bound >= 3 * 10000
     AND ib.ib_upper_bound <= 3 * 10000 + 50000) AS qc ON sr.sr_cdemo_sk = qc.c_current_cdemo_sk;