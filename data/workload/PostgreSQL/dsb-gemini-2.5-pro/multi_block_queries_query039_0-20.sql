WITH inv AS
  (SELECT w.w_warehouse_sk,
          i.i_item_sk,
          d.d_moy,
          stddev_samp(inv.inv_quantity_on_hand) stdev,
          avg(inv.inv_quantity_on_hand) mean
   FROM inventory inv
   JOIN
     (SELECT d_date_sk,
             d_moy
      FROM date_dim
      WHERE d_year = 1998) d ON inv.inv_date_sk = d.d_date_sk
   JOIN
     (SELECT i_item_sk
      FROM item
      WHERE i_category IN ('Books',
                           'Home')
        AND i_manager_id BETWEEN 28 AND 47) i ON inv.inv_item_sk = i.i_item_sk
   JOIN warehouse w ON inv.inv_warehouse_sk = w.w_warehouse_sk
   WHERE inv.inv_quantity_on_hand BETWEEN 225 AND 425
   GROUP BY w.w_warehouse_sk,
            i.i_item_sk,
            d.d_moy)
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
FROM
  (SELECT *,
          CASE mean
              WHEN 0 THEN NULL
              ELSE stdev/mean
          END cov
   FROM inv
   WHERE CASE mean
             WHEN 0 THEN 0
             ELSE stdev/mean
         END > 1) inv1
JOIN
  (SELECT *,
          CASE mean
              WHEN 0 THEN NULL
              ELSE stdev/mean
          END cov
   FROM inv
   WHERE CASE mean
             WHEN 0 THEN 0
             ELSE stdev/mean
         END > 1) inv2 ON inv1.i_item_sk = inv2.i_item_sk
AND inv1.w_warehouse_sk = inv2.w_warehouse_sk
WHERE inv1.d_moy = 2
  AND inv2.d_moy = 2 + 1
  AND inv1.cov > 1.5
ORDER BY inv1.w_warehouse_sk,
         inv1.i_item_sk,
         inv1.d_moy,
         inv1.mean,
         inv1.cov,
         inv2.d_moy,
         inv2.mean,
         inv2.cov;