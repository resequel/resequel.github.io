WITH filtered_dates AS
  (SELECT d_date_sk
   FROM date_dim
   WHERE d_year = 2002
     AND d_moy = 8),
     filtered_items AS
  (SELECT i_item_sk,
          i_brand_id,
          i_brand,
          i_manufact_id,
          i_manufact
   FROM item
   WHERE i_category = 'Home'),
     customer_zips AS
  (SELECT c.c_customer_sk,
          SUBSTRING(ca.ca_zip, 1, 5) AS cust_zip_part
   FROM customer c
   JOIN customer_address ca ON c.c_current_addr_sk = ca.ca_address_sk
   WHERE c.c_birth_month = 4
     AND ca.ca_state = 'GA'),
     store_zips AS
  (SELECT s_store_sk,
          SUBSTRING(s_zip, 1, 5) AS store_zip_part
   FROM store),
     sales_agg AS
  (SELECT ss.ss_customer_sk,
          ss.ss_store_sk,
          i.i_brand_id,
          i.i_brand,
          i.i_manufact_id,
          i.i_manufact,
          sum(ss.ss_ext_sales_price) AS price
   FROM store_sales ss
   JOIN filtered_dates d ON ss.ss_sold_date_sk = d.d_date_sk
   JOIN filtered_items i ON ss.ss_item_sk = i.i_item_sk
   WHERE ss.ss_wholesale_cost BETWEEN 80 AND 100
   GROUP BY ss.ss_customer_sk,
            ss.ss_store_sk,
            i.i_brand_id,
            i.i_brand,
            i.i_manufact_id,
            i.i_manufact)
SELECT sa.i_brand_id,
       sa.i_brand,
       sa.i_manufact_id,
       sa.i_manufact,
       sum(sa.price) AS ext_price
FROM sales_agg sa
JOIN customer_zips cz ON sa.ss_customer_sk = cz.c_customer_sk
JOIN store_zips sz ON sa.ss_store_sk = sz.s_store_sk
WHERE cz.cust_zip_part <> sz.store_zip_part
GROUP BY sa.i_brand,
         sa.i_brand_id,
         sa.i_manufact_id,
         sa.i_manufact
ORDER BY ext_price DESC,
         sa.i_brand,
         sa.i_brand_id,
         sa.i_manufact_id,
         sa.i_manufact
LIMIT 100;