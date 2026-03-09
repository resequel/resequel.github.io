WITH monthly_inv_stats AS
  (SELECT inv.inv_warehouse_sk AS w_warehouse_sk,
          inv.inv_item_sk AS i_item_sk,
          d.d_moy,
          avg(inv.inv_quantity_on_hand) AS mean,
          stddev_samp(inv.inv_quantity_on_hand) / NULLIF(avg(inv.inv_quantity_on_hand), 0) AS cov
   FROM inventory inv
   JOIN date_dim d ON inv.inv_date_sk = d.d_date_sk
   JOIN item i ON inv.inv_item_sk = i.i_item_sk
   WHERE d.d_year = 1998
     AND (d.d_moy = 2
          OR d.d_moy = 2 + 1)
     AND i.i_category IN ('Books',
                           'Home')
     AND i.i_manager_id BETWEEN 28 AND 47
     AND inv.inv_quantity_on_hand BETWEEN 225 AND 425
   GROUP BY inv.inv_warehouse_sk,
            inv.inv_item_sk,
            d.d_moy
   HAVING (stddev_samp(inv.inv_quantity_on_hand) / NULLIF(avg(inv.inv_quantity_on_hand), 0)) > 1)
SELECT p.w_warehouse_sk,
       p.i_item_sk,
       p.d_moy1,
       p.mean1,
       p.cov1,
       p.w_warehouse_sk,
       p.i_item_sk,
       p.d_moy2,
       p.mean2,
       p.cov2
FROM
  (SELECT s.w_warehouse_sk,
          s.i_item_sk,
          MAX(CASE
                  WHEN s.d_moy = 2 THEN s.d_moy
              END) AS d_moy1,
          MAX(CASE
                  WHEN s.d_moy = 2 THEN s.mean
              END) AS mean1,
          MAX(CASE
                  WHEN s.d_moy = 2 THEN s.cov
              END) AS cov1,
          MAX(CASE
                  WHEN s.d_moy = 2 + 1 THEN s.d_moy
              END) AS d_moy2,
          MAX(CASE
                  WHEN s.d_moy = 2 + 1 THEN s.mean
              END) AS mean2,
          MAX(CASE
                  WHEN s.d_moy = 2 + 1 THEN s.cov
              END) AS cov2
   FROM monthly_inv_stats s
   GROUP BY s.w_warehouse_sk,
            s.i_item_sk
   HAVING COUNT(s.d_moy) = 2) p
ORDER BY p.w_warehouse_sk,
         p.i_item_sk,
         p.d_moy1,
         p.mean1,
         p.cov1,
         p.d_moy2,
         p.mean2,
         p.cov2;