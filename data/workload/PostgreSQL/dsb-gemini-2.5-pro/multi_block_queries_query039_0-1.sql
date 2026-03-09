WITH inv AS
  (SELECT w_warehouse_sk,
          i_item_sk,
          d_moy,
          mean,
          stdev / NULLIF(mean, 0) AS cov
   FROM
     (SELECT w.w_warehouse_sk,
             i.i_item_sk,
             d.d_moy,
             stddev_samp(inv.inv_quantity_on_hand) AS stdev,
             avg(inv.inv_quantity_on_hand) AS mean
      FROM inventory inv
      JOIN item i ON inv.inv_item_sk = i.i_item_sk
      JOIN warehouse w ON inv.inv_warehouse_sk = w.w_warehouse_sk
      JOIN date_dim d ON inv.inv_date_sk = d.d_date_sk
      WHERE d.d_year = 1998
        AND i.i_category IN ('Books',
                           'Home')
        AND i.i_manager_id BETWEEN 28 AND 47
        AND inv.inv_quantity_on_hand BETWEEN 225 AND 425
      GROUP BY w.w_warehouse_sk,
               i.i_item_sk,
               d.d_moy
      HAVING (stddev_samp(inv.inv_quantity_on_hand) / NULLIF(avg(inv.inv_quantity_on_hand), 0)) > 1) foo)
SELECT inv1.w_warehouse_sk,
       inv1.i_item_sk,
       inv1.d_moy,
       inv1.mean,
       inv1.cov,
       inv2.w_warehouse_sk,
       inv2.i_item_sk,
       inv2.d_moy,
       inv2.mean,
       inv2.cov
FROM inv inv1
JOIN inv inv2 ON inv1.i_item_sk = inv2.i_item_sk
AND inv1.w_warehouse_sk = inv2.w_warehouse_sk
WHERE inv1.d_moy = 2
  AND inv2.d_moy = 2 + 1
ORDER BY inv1.w_warehouse_sk,
         inv1.i_item_sk,
         inv1.d_moy,
         inv1.mean,
         inv1.cov,
         inv2.d_moy,
         inv2.mean,
         inv2.cov;