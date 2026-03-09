WITH filtered_dates_ss AS
  (SELECT d_date_sk
   FROM date_dim
   WHERE d_month_seq BETWEEN 1185 AND 1185 + 11),
     filtered_dates_cs AS
  (SELECT d_date_sk
   FROM date_dim
   WHERE d_month_seq BETWEEN 1185 AND 1185 + 11),
     filtered_dates_ws AS
  (SELECT d_date_sk
   FROM date_dim
   WHERE d_month_seq BETWEEN 1185 AND 1185 + 11)
SELECT count(*)
FROM customer c
WHERE c.c_birth_month IN (2,
                           3,
                           10,
                           12)
  AND c.c_birth_month IN (2,
                           3,
                           10,
                           12)
  AND c.c_birth_month IN (2,
                           3,
                           10,
                           12)
  AND EXISTS
    (SELECT 1
     FROM store_sales ss
     JOIN filtered_dates_ss d ON ss.ss_sold_date_sk = d.d_date_sk
     WHERE ss.ss_customer_sk = c.c_customer_sk
       AND ss.ss_list_price BETWEEN 28 AND 87
       AND ss.ss_wholesale_cost BETWEEN 80 AND 100)
  AND EXISTS
    (SELECT 1
     FROM catalog_sales cs
     JOIN filtered_dates_cs d ON cs.cs_sold_date_sk = d.d_date_sk
     WHERE cs.cs_bill_customer_sk = c.c_customer_sk
       AND cs.cs_list_price BETWEEN 28 AND 87
       AND cs.cs_wholesale_cost BETWEEN 80 AND 100)
  AND EXISTS
    (SELECT 1
     FROM web_sales ws
     JOIN filtered_dates_ws d ON ws.ws_sold_date_sk = d.d_date_sk
     WHERE ws.ws_bill_customer_sk = c.c_customer_sk
       AND ws.ws_list_price BETWEEN 28 AND 87
       AND ws.ws_wholesale_cost BETWEEN 80 AND 100)
LIMIT 100;