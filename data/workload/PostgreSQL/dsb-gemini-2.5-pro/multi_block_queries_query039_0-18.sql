WITH monthly_stats AS
  (SELECT i.i_item_sk,
          inv.inv_warehouse_sk,
          avg(inv.inv_quantity_on_hand) FILTER (
                                                WHERE d.d_moy = 2) AS mean1,
          stddev_samp(inv.inv_quantity_on_hand) FILTER (
                                                        WHERE d.d_moy = 2) AS stdev1,
          avg(inv.inv_quantity_on_hand) FILTER (
                                                WHERE d.d_moy = 2 + 1) AS mean2,
          stddev_samp(inv.inv_quantity_on_hand) FILTER (
                                                        WHERE d.d_moy = 2 + 1) AS stdev2
   FROM inventory inv
   JOIN date_dim d ON inv.inv_date_sk = d.d_date_sk
   JOIN item i ON inv.inv_item_sk = i.i_item_sk
   WHERE d.d_year = 1998
     AND d.d_moy IN (2, 2 + 1)
     AND i.i_category IN ('Books',
                           'Home')
     AND i.i_manager_id BETWEEN 28 AND 47
     AND inv.inv_quantity_on_hand BETWEEN 225 AND 425
   GROUP BY i.i_item_sk,
            inv.inv_warehouse_sk)
SELECT s.inv_warehouse_sk,
       s.i_item_sk, 2 AS d_moy1,
                       s.mean1,
                       CASE
                           WHEN s.mean1 = 0 THEN NULL
                           ELSE s.stdev1 / s.mean1
                       END AS cov1,
                       s.inv_warehouse_sk,
                       s.i_item_sk, 2 + 1 AS d_moy2,
                                               s.mean2,
                                               CASE
                                                   WHEN s.mean2 = 0 THEN NULL
                                                   ELSE s.stdev2 / s.mean2
                                               END AS cov2
FROM monthly_stats s
WHERE (CASE
           WHEN s.mean1 = 0 THEN 0
           ELSE s.stdev1 / s.mean1
       END) > 1
  AND (CASE
           WHEN s.mean2 = 0 THEN 0
           ELSE s.stdev2 / s.mean2
       END) > 1
ORDER BY s.inv_warehouse_sk,
         s.i_item_sk,
         d_moy1,
         s.mean1,
         cov1,
         d_moy2,
         s.mean2,
         cov2;