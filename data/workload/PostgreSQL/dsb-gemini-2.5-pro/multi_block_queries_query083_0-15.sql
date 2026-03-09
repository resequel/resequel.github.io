WITH sr_months AS
  (SELECT DISTINCT d_month_seq
   FROM date_dim
   WHERE d_date IN ('1998-03-05',
                              '1998-06-15',
                              '1998-09-12',
                              '1998-10-31')),
     cr_months AS
  (SELECT DISTINCT d_month_seq
   FROM date_dim
   WHERE d_date IN ('1998-03-05',
                              '1998-06-15',
                              '1998-09-12',
                              '1998-10-31')),
     wr_months AS
  (SELECT DISTINCT d_month_seq
   FROM date_dim
   WHERE d_date IN ('1998-03-05',
                              '1998-06-15',
                              '1998-09-12',
                              '1998-10-31')),
     sr_items AS
  (SELECT i_item_id item_id,
          sum(sr_return_quantity) sr_item_qty
   FROM store_returns
   INNER JOIN item ON sr_item_sk = i_item_sk
   INNER JOIN date_dim ON sr_returned_date_sk = d_date_sk
   INNER JOIN sr_months ON date_dim.d_month_seq = sr_months.d_month_seq
   WHERE i_category IN ('Books',
                        'Sports')
     AND i_manager_id BETWEEN 36 AND 45
     AND sr_return_amt / sr_return_quantity BETWEEN 141 AND 170
     AND sr_reason_sk IN (6,
                          29,
                          42,
                          45,
                          62)
   GROUP BY i_item_id),
     cr_items AS
  (SELECT i_item_id item_id,
          sum(cr_return_quantity) cr_item_qty
   FROM catalog_returns
   INNER JOIN item ON cr_item_sk = i_item_sk
   INNER JOIN date_dim ON cr_returned_date_sk = d_date_sk
   INNER JOIN cr_months ON date_dim.d_month_seq = cr_months.d_month_seq
   WHERE i_category IN ('Books',
                        'Sports')
     AND i_manager_id BETWEEN 36 AND 45
     AND cr_return_amount / cr_return_quantity BETWEEN 141 AND 170
     AND cr_reason_sk IN (6,
                          29,
                          42,
                          45,
                          62)
   GROUP BY i_item_id),
     wr_items AS
  (SELECT i_item_id item_id,
          sum(wr_return_quantity) wr_item_qty
   FROM web_returns
   INNER JOIN item ON wr_item_sk = i_item_sk
   INNER JOIN date_dim ON wr_returned_date_sk = d_date_sk
   INNER JOIN wr_months ON date_dim.d_month_seq = wr_months.d_month_seq
   WHERE i_category IN ('Books',
                        'Sports')
     AND i_manager_id BETWEEN 36 AND 45
     AND wr_return_amt / wr_return_quantity BETWEEN 141 AND 170
     AND wr_reason_sk IN (6,
                          29,
                          42,
                          45,
                          62)
   GROUP BY i_item_id)
SELECT sr_items.item_id,
       sr_item_qty,
       sr_item_qty/(sr_item_qty+cr_item_qty+wr_item_qty)/3.0 * 100 sr_dev,
                                                                    cr_item_qty,
                                                                    cr_item_qty/(sr_item_qty+cr_item_qty+wr_item_qty)/3.0 * 100 cr_dev,
                                                                                                                                 wr_item_qty,
                                                                                                                                 wr_item_qty/(sr_item_qty+cr_item_qty+wr_item_qty)/3.0 * 100 wr_dev,
                                                                                                                                                                                              (sr_item_qty+cr_item_qty+wr_item_qty)/3.0 average
FROM sr_items
INNER JOIN cr_items ON sr_items.item_id = cr_items.item_id
INNER JOIN wr_items ON sr_items.item_id = wr_items.item_id
ORDER BY sr_items.item_id,
         sr_item_qty
LIMIT 100;