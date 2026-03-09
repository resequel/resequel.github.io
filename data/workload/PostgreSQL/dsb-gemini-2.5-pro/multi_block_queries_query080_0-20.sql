WITH sr_agg AS
  (SELECT sr_item_sk,
          sr_ticket_number,
          SUM(sr_return_amt) AS r_amt,
          SUM(sr_net_loss) AS r_loss
   FROM store_returns
   GROUP BY sr_item_sk,
            sr_ticket_number),
     cr_agg AS
  (SELECT cr_item_sk,
          cr_order_number,
          SUM(cr_return_amount) AS r_amt,
          SUM(cr_net_loss) AS r_loss
   FROM catalog_returns
   GROUP BY cr_item_sk,
            cr_order_number),
     wr_agg AS
  (SELECT wr_item_sk,
          wr_order_number,
          SUM(wr_return_amt) AS r_amt,
          SUM(wr_net_loss) AS r_loss
   FROM web_returns
   GROUP BY wr_item_sk,
            wr_order_number),
     ssr AS
  (SELECT s.s_store_id,
          SUM(ss.ss_ext_sales_price) AS sales,
          SUM(COALESCE(sr.r_amt, 0)) AS RETURNS,
          SUM(ss.ss_net_profit - COALESCE(sr.r_loss, 0)) AS profit
   FROM store_sales ss
   JOIN
     (SELECT d_date_sk
      FROM date_dim
      WHERE d_date BETWEEN CAST('2001-08-11' AS date) AND CAST('2001-08-11' AS date) + interval '30 day') d ON ss.ss_sold_date_sk = d.d_date_sk
   JOIN
     (SELECT i_item_sk
      FROM item
      WHERE i_current_price > 50
        AND i_category IN ('Jewelry',
                        'Sports')) i ON ss.ss_item_sk = i.i_item_sk
   JOIN
     (SELECT p_promo_sk
      FROM promotion
      WHERE p_channel_email = 'N'
        AND p_channel_tv = 'N'
        AND p_channel_radio = 'Y'
        AND p_channel_press = 'N'
        AND p_channel_event = 'Y') p ON ss.ss_promo_sk = p.p_promo_sk
   JOIN store s ON ss.ss_store_sk = s.s_store_sk
   LEFT JOIN sr_agg sr ON ss.ss_item_sk = sr.sr_item_sk
   AND ss.ss_ticket_number = sr.sr_ticket_number
   WHERE ss.ss_wholesale_cost BETWEEN 45 AND 60
   GROUP BY s.s_store_id),
     csr AS
  (SELECT cp.cp_catalog_page_id,
          SUM(cs.cs_ext_sales_price) AS sales,
          SUM(COALESCE(cr.r_amt, 0)) AS RETURNS,
          SUM(cs.cs_net_profit - COALESCE(cr.r_loss, 0)) AS profit
   FROM catalog_sales cs
   JOIN
     (SELECT d_date_sk
      FROM date_dim
      WHERE d_date BETWEEN CAST('2001-08-11' AS date) AND CAST('2001-08-11' AS date) + interval '30 day') d ON cs.cs_sold_date_sk = d.d_date_sk
   JOIN
     (SELECT i_item_sk
      FROM item
      WHERE i_current_price > 50
        AND i_category IN ('Jewelry',
                        'Sports')) i ON cs.cs_item_sk = i.i_item_sk
   JOIN
     (SELECT p_promo_sk
      FROM promotion
      WHERE p_channel_email = 'N'
        AND p_channel_tv = 'N'
        AND p_channel_radio = 'Y'
        AND p_channel_press = 'N'
        AND p_channel_event = 'Y') p ON cs.cs_promo_sk = p.p_promo_sk
   JOIN catalog_page cp ON cs.cs_catalog_page_sk = cp.cp_catalog_page_sk
   LEFT JOIN cr_agg cr ON cs.cs_item_sk = cr.cr_item_sk
   AND cs.cs_order_number = cr.cr_order_number
   WHERE cs.cs_wholesale_cost BETWEEN 45 AND 60
   GROUP BY cp.cp_catalog_page_id),
     wsr AS
  (SELECT w.web_site_id,
          SUM(ws.ws_ext_sales_price) AS sales,
          SUM(COALESCE(wr.r_amt, 0)) AS RETURNS,
          SUM(ws.ws_net_profit - COALESCE(wr.r_loss, 0)) AS profit
   FROM web_sales ws
   JOIN
     (SELECT d_date_sk
      FROM date_dim
      WHERE d_date BETWEEN CAST('2001-08-11' AS date) AND CAST('2001-08-11' AS date) + interval '30 day') d ON ws.ws_sold_date_sk = d.d_date_sk
   JOIN
     (SELECT i_item_sk
      FROM item
      WHERE i_current_price > 50
        AND i_category IN ('Jewelry',
                        'Sports')) i ON ws.ws_item_sk = i.i_item_sk
   JOIN
     (SELECT p_promo_sk
      FROM promotion
      WHERE p_channel_email = 'N'
        AND p_channel_tv = 'N'
        AND p_channel_radio = 'Y'
        AND p_channel_press = 'N'
        AND p_channel_event = 'Y') p ON ws.ws_promo_sk = p.p_promo_sk
   JOIN web_site w ON ws.ws_web_site_sk = w.web_site_sk
   LEFT JOIN wr_agg wr ON ws.ws_item_sk = wr.wr_item_sk
   AND ws.ws_order_number = wr.wr_order_number
   WHERE ws.ws_wholesale_cost BETWEEN 45 AND 60
   GROUP BY w.web_site_id)
SELECT channel,
       id,
       SUM(sales) AS sales,
       SUM(RETURNS) AS RETURNS,
       SUM(profit) AS profit
FROM
  (SELECT 'store channel' AS channel, 'store' || store_id AS id,
                               sales,
                               RETURNS,
                               profit
   FROM ssr
   UNION ALL SELECT 'catalog channel' AS channel, 'catalog_page' || catalog_page_id AS id,
                                          sales,
                                          RETURNS,
                                          profit
   FROM csr
   UNION ALL SELECT 'web channel' AS channel, 'web_site' || web_site_id AS id,
                                          sales,
                                          RETURNS,
                                          profit
   FROM wsr) x
GROUP BY ROLLUP (channel,
                 id)
ORDER BY channel,
         id
LIMIT 100;