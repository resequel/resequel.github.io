WITH cr_agg AS
  (SELECT cr_item_sk,
          cr_order_number,
          sum(cr_return_amount) AS return_amount,
          sum(cr_net_loss) AS net_loss
   FROM catalog_returns
   GROUP BY cr_item_sk,
            cr_order_number),
     filtered_dates_ss AS
  (SELECT d_date_sk
   FROM date_dim
   WHERE d_date BETWEEN cast('2001-08-11' AS date) AND cast('2001-08-11' AS date) + interval '30 day'),
     filtered_items_ss AS
  (SELECT i_item_sk
   FROM item
   WHERE i_current_price > 50
     AND i_category IN (('Jewelry',
                        'Sports'))),
     filtered_promos_ss AS
  (SELECT p_promo_sk
   FROM promotion
   WHERE p_channel_email = 'N'
     AND p_channel_tv = 'N'
     AND p_channel_radio = 'Y'
     AND p_channel_press = 'N'
     AND p_channel_event = 'Y'),
     ssr AS
  (SELECT s.s_store_id AS store_id,
          sum(ss.ss_ext_sales_price) AS sales,
          sum(coalesce(sr.sr_return_amt, 0)) AS RETURNS,
          sum(ss.ss_net_profit - coalesce(sr.sr_net_loss, 0)) AS profit
   FROM store_sales ss
   JOIN filtered_dates_ss d ON ss.ss_sold_date_sk = d.d_date_sk
   JOIN filtered_items_ss i ON ss.ss_item_sk = i.i_item_sk
   JOIN filtered_promos_ss p ON ss.ss_promo_sk = p.p_promo_sk
   JOIN store s ON ss.ss_store_sk = s.s_store_sk
   LEFT JOIN store_returns sr ON ss.ss_item_sk = sr.sr_item_sk
   AND ss.ss_ticket_number = sr.sr_ticket_number
   WHERE ss.ss_wholesale_cost BETWEEN 45 AND 60
   GROUP BY s.s_store_id),
     filtered_dates_cs AS
  (SELECT d_date_sk
   FROM date_dim
   WHERE d_date BETWEEN cast('2001-08-11' AS date) AND cast('2001-08-11' AS date) + interval '30 day'),
     filtered_items_cs AS
  (SELECT i_item_sk
   FROM item
   WHERE i_current_price > 50
     AND i_category IN (('Jewelry',
                        'Sports'))),
     filtered_promos_cs AS
  (SELECT p_promo_sk
   FROM promotion
   WHERE p_channel_email = 'N'
     AND p_channel_tv = 'N'
     AND p_channel_radio = 'Y'
     AND p_channel_press = 'N'
     AND p_channel_event = 'Y'),
     csr AS
  (SELECT cp.cp_catalog_page_id AS catalog_page_id,
          sum(cs.cs_ext_sales_price) AS sales,
          sum(coalesce(cr.return_amount, 0)) AS RETURNS,
          sum(cs.cs_net_profit - coalesce(cr.net_loss, 0)) AS profit
   FROM catalog_sales cs
   JOIN filtered_dates_cs d ON cs.cs_sold_date_sk = d.d_date_sk
   JOIN filtered_items_cs i ON cs.cs_item_sk = i.i_item_sk
   JOIN filtered_promos_cs p ON cs.cs_promo_sk = p.p_promo_sk
   JOIN catalog_page cp ON cs.cs_catalog_page_sk = cp.cp_catalog_page_sk
   LEFT JOIN cr_agg cr ON cs.cs_item_sk = cr.cr_item_sk
   AND cs.cs_order_number = cr.cr_order_number
   WHERE cs.cs_wholesale_cost BETWEEN 45 AND 60
   GROUP BY cp.cp_catalog_page_id),
     filtered_dates_ws AS
  (SELECT d_date_sk
   FROM date_dim
   WHERE d_date BETWEEN cast('2001-08-11' AS date) AND cast('2001-08-11' AS date) + interval '30 day'),
     filtered_items_ws AS
  (SELECT i_item_sk
   FROM item
   WHERE i_current_price > 50
     AND i_category IN (('Jewelry',
                        'Sports'))),
     filtered_promos_ws AS
  (SELECT p_promo_sk
   FROM promotion
   WHERE p_channel_email = 'N'
     AND p_channel_tv = 'N'
     AND p_channel_radio = 'Y'
     AND p_channel_press = 'N'
     AND p_channel_event = 'Y'),
     wsr AS
  (SELECT w.web_site_id,
          sum(ws.ws_ext_sales_price) AS sales,
          sum(coalesce(wr.wr_return_amt, 0)) AS RETURNS,
          sum(ws.ws_net_profit - coalesce(wr.wr_net_loss, 0)) AS profit
   FROM web_sales ws
   JOIN filtered_dates_ws d ON ws.ws_sold_date_sk = d.d_date_sk
   JOIN filtered_items_ws i ON ws.ws_item_sk = i.i_item_sk
   JOIN filtered_promos_ws p ON ws.ws_promo_sk = p.p_promo_sk
   JOIN web_site w ON ws.ws_web_site_sk = w.web_site_sk
   LEFT JOIN web_returns wr ON ws.ws_item_sk = wr.wr_item_sk
   AND ws.ws_order_number = wr.wr_order_number
   WHERE ws.ws_wholesale_cost BETWEEN 45 AND 60
   GROUP BY w.web_site_id)
SELECT channel,
       id,
       sum(sales) AS sales,
       sum(RETURNS) AS RETURNS,
       sum(profit) AS profit
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