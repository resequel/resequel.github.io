WITH valid_dates_A AS
  (SELECT d_date_sk
   FROM date_dim
   WHERE d_month_seq IN
       (SELECT d_month_seq
        FROM date_dim
        WHERE d_date IN ('1998-03-05',
                              '1998-06-15',
                              '1998-09-12',
                              '1998-10-31'))),
     valid_dates_C AS
  (SELECT d_date_sk
   FROM date_dim
   WHERE d_month_seq IN
       (SELECT d_month_seq
        FROM date_dim
        WHERE d_date IN ('1998-03-05',
                              '1998-06-15',
                              '1998-09-12',
                              '1998-10-31'))),
     valid_dates_E AS
  (SELECT d_date_sk
   FROM date_dim
   WHERE d_month_seq IN
       (SELECT d_month_seq
        FROM date_dim
        WHERE d_date IN ('1998-03-05',
                              '1998-06-15',
                              '1998-09-12',
                              '1998-10-31'))),
     sr_items AS
  (SELECT i.i_item_id AS item_id,
          sum(sr.sr_return_quantity) AS sr_item_qty
   FROM store_returns sr
   JOIN valid_dates_A vd ON sr.sr_returned_date_sk = vd.d_date_sk
   JOIN item i ON sr.sr_item_sk = i.i_item_sk
   WHERE i.i_category IN ('Books',
                        'Sports')
     AND i.i_manager_id BETWEEN 36 AND 45
     AND sr.sr_return_amt / sr.sr_return_quantity BETWEEN 141 AND 170
     AND sr.sr_reason_sk IN (6,
                          29,
                          42,
                          45,
                          62)
   GROUP BY i.i_item_id),
     cr_items AS
  (SELECT i.i_item_id AS item_id,
          sum(cr.cr_return_quantity) AS cr_item_qty
   FROM catalog_returns cr
   JOIN valid_dates_C vd ON cr.cr_returned_date_sk = vd.d_date_sk
   JOIN item i ON cr.cr_item_sk = i.i_item_sk
   WHERE i.i_category IN ('Books',
                        'Sports')
     AND i.i_manager_id BETWEEN 36 AND 45
     AND cr.cr_return_amount / cr.cr_return_quantity BETWEEN 141 AND 170
     AND cr.cr_reason_sk IN (6,
                          29,
                          42,
                          45,
                          62)
   GROUP BY i.i_item_id),
     wr_items AS
  (SELECT i.i_item_id AS item_id,
          sum(wr.wr_return_quantity) AS wr_item_qty
   FROM web_returns wr
   JOIN valid_dates_E vd ON wr.wr_returned_date_sk = vd.d_date_sk
   JOIN item i ON wr.wr_item_sk = i.i_item_sk
   WHERE i.i_category IN ('Books',
                        'Sports')
     AND i.i_manager_id BETWEEN 36 AND 45
     AND wr.wr_return_amt / wr.wr_return_quantity BETWEEN 141 AND 170
     AND wr.wr_reason_sk IN (6,
                          29,
                          42,
                          45,
                          62)
   GROUP BY i.i_item_id)
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