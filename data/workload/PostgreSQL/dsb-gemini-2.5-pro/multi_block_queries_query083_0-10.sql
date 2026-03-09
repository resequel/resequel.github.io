WITH all_returns AS
  (SELECT i_item_id,
          'sr' AS SOURCE,
          sr_return_quantity AS qty
   FROM store_returns
   INNER JOIN item ON sr_item_sk = i_item_sk
   INNER JOIN date_dim ON sr_returned_date_sk = d_date_sk
   WHERE d_month_seq IN
       (SELECT d_month_seq
        FROM date_dim
        WHERE d_date IN ('1998-03-05',
                              '1998-06-15',
                              '1998-09-12',
                              '1998-10-31'))
     AND i_category IN ('Books',
                        'Sports')
     AND i_manager_id BETWEEN 36 AND 45
     AND sr_return_amt BETWEEN 141 * sr_return_quantity AND 170 * sr_return_quantity
     AND sr_reason_sk IN (6,
                          29,
                          42,
                          45,
                          62)
   UNION ALL SELECT i_item_id,
                    'cr' AS SOURCE,
                    cr_return_quantity AS qty
   FROM catalog_returns
   INNER JOIN item ON cr_item_sk = i_item_sk
   INNER JOIN date_dim ON cr_returned_date_sk = d_date_sk
   WHERE d_month_seq IN
       (SELECT d_month_seq
        FROM date_dim
        WHERE d_date IN ('1998-03-05',
                              '1998-06-15',
                              '1998-09-12',
                              '1998-10-31'))
     AND i_category IN ('Books',
                        'Sports')
     AND i_manager_id BETWEEN 36 AND 45
     AND cr_return_amount BETWEEN 141 * cr_return_quantity AND 170 * cr_return_quantity
     AND cr_reason_sk IN (6,
                          29,
                          42,
                          45,
                          62)
   UNION ALL SELECT i_item_id,
                    'wr' AS SOURCE,
                    wr_return_quantity AS qty
   FROM web_returns
   INNER JOIN item ON wr_item_sk = i_item_sk
   INNER JOIN date_dim ON wr_returned_date_sk = d_date_sk
   WHERE d_month_seq IN
       (SELECT d_month_seq
        FROM date_dim
        WHERE d_date IN ('1998-03-05',
                              '1998-06-15',
                              '1998-09-12',
                              '1998-10-31'))
     AND i_category IN ('Books',
                        'Sports')
     AND i_manager_id BETWEEN 36 AND 45
     AND wr_return_amt BETWEEN 141 * wr_return_quantity AND 170 * wr_return_quantity
     AND wr_reason_sk IN (6,
                          29,
                          42,
                          45,
                          62)),
     agg_returns AS
  (SELECT item_id,
          sum(CASE
                  WHEN SOURCE = 'sr' THEN qty
                  ELSE 0
              END) AS sr_item_qty,
          sum(CASE
                  WHEN SOURCE = 'cr' THEN qty
                  ELSE 0
              END) AS cr_item_qty,
          sum(CASE
                  WHEN SOURCE = 'wr' THEN qty
                  ELSE 0
              END) AS wr_item_qty
   FROM all_returns
   GROUP BY item_id)
SELECT item_id,
       sr_item_qty,
       sr_item_qty/(sr_item_qty+cr_item_qty+wr_item_qty)/3.0 * 100 sr_dev,
                                                                    cr_item_qty,
                                                                    cr_item_qty/(sr_item_qty+cr_item_qty+wr_item_qty)/3.0 * 100 cr_dev,
                                                                                                                                 wr_item_qty,
                                                                                                                                 wr_item_qty/(sr_item_qty+cr_item_qty+wr_item_qty)/3.0 * 100 wr_dev,
                                                                                                                                                                                              (sr_item_qty+cr_item_qty+wr_item_qty)/3.0 average
FROM agg_returns
WHERE sr_item_qty > 0
  AND cr_item_qty > 0
  AND wr_item_qty > 0
ORDER BY item_id,
         sr_item_qty
LIMIT 100;