WITH ssr AS
  (SELECT s.s_store_id,
          SUM(ss.ss_ext_sales_price) AS sales,
          SUM(COALESCE(sr.sr_return_amt, 0)) AS RETURNS,
          SUM(ss.ss_net_profit - COALESCE(sr.sr_net_loss, 0)) AS profit
   FROM store_sales ss
   JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
   AND d.d_date BETWEEN CAST('2001-08-11' AS date) AND CAST('2001-08-11' AS date) + interval '30 day'
   JOIN item i ON ss.ss_item_sk = i.i_item_sk
   AND i.i_current_price > 50
   AND i.i_category IN ('Jewelry',
                        'Sports')
   JOIN promotion p ON ss.ss_promo_sk = p.p_promo_sk
   AND p.p_channel_email = 'N'
   AND p.p_channel_tv = 'N'
   AND p.p_channel_radio = 'Y'
   AND p.p_channel_press = 'N'
   AND p.p_channel_event = 'Y'
   JOIN store s ON ss.ss_store_sk = s.s_store_sk
   LEFT JOIN store_returns sr ON ss.ss_item_sk = sr.sr_item_sk
   AND ss.ss_ticket_number = sr.sr_ticket_number
   WHERE ss.ss_wholesale_cost BETWEEN 45 AND 60
   GROUP BY s.s_store_id),
     csr AS
  (SELECT cp.cp_catalog_page_id,
          SUM(cs.cs_ext_sales_price) AS sales,
          SUM(COALESCE(cr.cr_return_amount, 0)) AS RETURNS,
          SUM(cs.cs_net_profit - COALESCE(cr.cr_net_loss, 0)) AS profit
   FROM catalog_sales cs
   JOIN date_dim d ON cs.cs_sold_date_sk = d.d_date_sk
   AND d.d_date BETWEEN CAST('2001-08-11' AS date) AND CAST('2001-08-11' AS date) + interval '30 day'
   JOIN item i ON cs.cs_item_sk = i.i_item_sk
   AND i.i_current_price > 50
   AND i.i_category IN ('Jewelry',
                        'Sports')
   JOIN promotion p ON cs.cs_promo_sk = p.p_promo_sk
   AND p.p_channel_email = 'N'
   AND p.p_channel_tv = 'N'
   AND p.p_channel_radio = 'Y'
   AND p.p_channel_press = 'N'
   AND p.p_channel_event = 'Y'
   JOIN catalog_page cp ON cs.cs_catalog_page_sk = cp.cp_catalog_page_sk
   LEFT JOIN catalog_returns cr ON cs.cs_item_sk = cr.cr_item_sk
   AND cs.cs_order_number = cr.cr_order_number
   WHERE cs.cs_wholesale_cost BETWEEN 45 AND 60
   GROUP BY cp.cp_catalog_page_id),
     wsr AS
  (SELECT w.web_site_id,
          SUM(ws.ws_ext_sales_price) AS sales,
          SUM(COALESCE(wr.wr_return_amt, 0)) AS RETURNS,
          SUM(ws.ws_net_profit - COALESCE(wr.wr_net_loss, 0)) AS profit
   FROM web_sales ws
   JOIN date_dim d ON ws.ws_sold_date_sk = d.d_date_sk
   AND d.d_date BETWEEN CAST('2001-08-11' AS date) AND CAST('2001-08-11' AS date) + interval '30 day'
   JOIN item i ON ws.ws_item_sk = i.i_item_sk
   AND i.i_current_price > 50
   AND i.i_category IN ('Jewelry',
                        'Sports')
   JOIN promotion p ON ws.ws_promo_sk = p.p_promo_sk
   AND p.p_channel_email = 'N'
   AND p.p_channel_tv = 'N'
   AND p.p_channel_radio = 'Y'
   AND p.p_channel_press = 'N'
   AND p.p_channel_event = 'Y'
   JOIN web_site w ON ws.ws_web_site_sk = w.web_site_sk
   LEFT JOIN web_returns wr ON ws.ws_item_sk = wr.wr_item_sk
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