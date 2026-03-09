WITH sr_candidate_items AS
  (SELECT i_item_sk,
          i_item_id
   FROM item
   WHERE i_category IN ('Books',
                        'Sports')
     AND i_manager_id BETWEEN 36 AND 45),
     cr_candidate_items AS
  (SELECT i_item_sk,
          i_item_id
   FROM item
   WHERE i_category IN ('Books',
                        'Sports')
     AND i_manager_id BETWEEN 36 AND 45),
     wr_candidate_items AS
  (SELECT i_item_sk,
          i_item_id
   FROM item
   WHERE i_category IN ('Books',
                        'Sports')
     AND i_manager_id BETWEEN 36 AND 45),
     sr_items AS
  (SELECT ci.item_id,
          sum(sr.sr_return_quantity) AS sr_item_qty
   FROM store_returns sr
   JOIN sr_candidate_items ci ON sr.sr_item_sk = ci.i_item_sk
   JOIN date_dim d1 ON sr.sr_returned_date_sk = d1.d_date_sk
   JOIN
     (SELECT DISTINCT d_month_seq
      FROM date_dim
      WHERE d_date IN ('1998-03-05',
                              '1998-06-15',
                              '1998-09-12',
                              '1998-10-31')) d2 ON d1.d_month_seq = d2.d_month_seq
   WHERE sr.sr_return_amt BETWEEN sr.sr_return_quantity * 141 AND sr.sr_return_quantity * 170
     AND sr.sr_reason_sk IN (6,
                          29,
                          42,
                          45,
                          62)
   GROUP BY ci.item_id),
     cr_items AS
  (SELECT ci.item_id,
          sum(cr.cr_return_quantity) AS cr_item_qty
   FROM catalog_returns cr
   JOIN cr_candidate_items ci ON cr.cr_item_sk = ci.i_item_sk
   JOIN date_dim d1 ON cr.cr_returned_date_sk = d1.d_date_sk
   JOIN
     (SELECT DISTINCT d_month_seq
      FROM date_dim
      WHERE d_date IN ('1998-03-05',
                              '1998-06-15',
                              '1998-09-12',
                              '1998-10-31')) d2 ON d1.d_month_seq = d2.d_month_seq
   WHERE cr.cr_return_amount BETWEEN cr.cr_return_quantity * 141 AND cr.cr_return_quantity * 170
     AND cr.cr_reason_sk IN (6,
                          29,
                          42,
                          45,
                          62)
   GROUP BY ci.item_id),
     wr_items AS
  (SELECT ci.item_id,
          sum(wr.wr_return_quantity) AS wr_item_qty
   FROM web_returns wr
   JOIN wr_candidate_items ci ON wr.wr_item_sk = ci.i_item_sk
   JOIN date_dim d1 ON wr.wr_returned_date_sk = d1.d_date_sk
   JOIN
     (SELECT DISTINCT d_month_seq
      FROM date_dim
      WHERE d_date IN ('1998-03-05',
                              '1998-06-15',
                              '1998-09-12',
                              '1998-10-31')) d2 ON d1.d_month_seq = d2.d_month_seq
   WHERE wr.wr_return_amt BETWEEN wr.wr_return_quantity * 141 AND wr.wr_return_quantity * 170
     AND wr.wr_reason_sk IN (6,
                          29,
                          42,
                          45,
                          62)
   GROUP BY ci.item_id)
SELECT sr_items.item_id,
       sr_item_qty,
       sr_item_qty/(sr_item_qty+cr_item_qty+wr_item_qty)/3.0 * 100 sr_dev,
                                                                    cr_item_qty,
                                                                    cr_item_qty/(sr_item_qty+cr_item_qty+wr_item_qty)/3.0 * 100 cr_dev,
                                                                                                                                 wr_item_qty,
                                                                                                                                 wr_item_qty/(sr_item_qty+cr_item_qty+wr_item_qty)/3.0 * 100 wr_dev,
                                                                                                                                                                                              (sr_item_qty+cr_item_qty+wr_item_qty)/3.0 average
FROM sr_items
JOIN cr_items ON sr_items.item_id = cr_items.item_id
JOIN wr_items ON sr_items.item_id = wr_items.item_id
ORDER BY sr_items.item_id,
         sr_item_qty
LIMIT 100;