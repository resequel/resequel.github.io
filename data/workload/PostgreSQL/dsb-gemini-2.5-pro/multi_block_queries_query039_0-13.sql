WITH inv_stats AS
  (SELECT inv.inv_warehouse_sk,
          i.i_item_sk,
          d.d_moy,
          avg(inv.inv_quantity_on_hand) AS mean,
          stddev_samp(inv.inv_quantity_on_hand) AS stdev
   FROM inventory inv
   JOIN date_dim d ON inv.inv_date_sk = d.d_date_sk
   JOIN item i ON inv.inv_item_sk = i.i_item_sk
   WHERE d.d_year = 1998
     AND d.d_moy IN (2, 2 + 1)
     AND i.i_category IN ('Books',
                           'Home')
     AND i.i_manager_id BETWEEN 28 AND 47
     AND inv.inv_quantity_on_hand BETWEEN 225 AND 425
   GROUP BY inv.inv_warehouse_sk,
            i.i_item_sk,
            d.d_moy),
     cov_calc AS
  (SELECT inv_warehouse_sk,
          i_item_sk,
          d_moy,
          mean,
          CASE
              WHEN mean = 0 THEN NULL
              ELSE stdev / mean
          END AS cov
   FROM inv_stats
   WHERE CASE
             WHEN mean = 0 THEN 0
             ELSE stdev / mean
         END > 1),
     paired_inv AS
  (SELECT inv_warehouse_sk,
          i_item_sk,
          d_moy,
          mean,
          cov,
          LAG(d_moy, 1) OVER (PARTITION BY inv_warehouse_sk, i_item_sk
                              ORDER BY d_moy) AS prev_moy,
          LAG(mean, 1) OVER (PARTITION BY inv_warehouse_sk, i_item_sk
                             ORDER BY d_moy) AS prev_mean,
          LAG(cov, 1) OVER (PARTITION BY inv_warehouse_sk, i_item_sk
                            ORDER BY d_moy) AS prev_cov
   FROM cov_calc)
SELECT p.inv_warehouse_sk,
       p.i_item_sk,
       p.prev_moy,
       p.prev_mean,
       p.prev_cov,
       p.inv_warehouse_sk,
       p.i_item_sk,
       p.d_moy,
       p.mean,
       p.cov
FROM paired_inv p
WHERE p.d_moy = (2 + 1)
  AND p.prev_moy = 2
ORDER BY p.inv_warehouse_sk,
         p.i_item_sk,
         p.prev_moy,
         p.prev_mean,
         p.prev_cov,
         p.d_moy,
         p.mean,
         p.cov;