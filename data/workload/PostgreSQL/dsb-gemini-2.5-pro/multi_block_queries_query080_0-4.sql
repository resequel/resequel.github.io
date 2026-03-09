WITH ss_sr AS
  (SELECT ss.ss_sold_date_sk,
          ss.ss_item_sk,
          ss.ss_promo_sk,
          ss.ss_store_sk,
          ss.ss_ext_sales_price,
          ss.ss_net_profit,
          sr.sr_return_amt,
          sr.sr_net_loss
   FROM store_sales ss
   LEFT JOIN store_returns sr ON ss.ss_item_sk = sr.sr_item_sk
   AND ss.ss_ticket_number = sr.sr_ticket_number
   WHERE ss.ss_wholesale_cost BETWEEN 45 AND 60),
     ssr AS
  (SELECT s.s_store_id AS store_id,
          sum(ss_sr.ss_ext_sales_price) AS sales,
          sum(coalesce(ss_sr.sr_return_amt, 0)) AS RETURNS,
          sum(ss_sr.ss_net_profit - coalesce(ss_sr.sr_net_loss, 0)) AS profit
   FROM ss_sr
   JOIN date_dim d ON ss_sr.ss_sold_date_sk = d.d_date_sk
   JOIN item i ON ss_sr.ss_item_sk = i.i_item_sk
   JOIN promotion p ON ss_sr.ss_promo_sk = p.p_promo_sk
   JOIN store s ON ss_sr.ss_store_sk = s.s_store_sk
   WHERE d.d_date BETWEEN cast('2001-08-11' AS date) AND cast('2001-08-11' AS date) + interval '30 day'
     AND i.i_current_price > 50
     AND i.i_category IN (('Jewelry',
                        'Sports'))
     AND p.p_channel_email = 'N'
     AND p.p_channel_tv = 'N'
     AND p.p_channel_radio = 'Y'
     AND p.p_channel_press = 'N'
     AND p.p_channel_event = 'Y'
   GROUP BY s.s_store_id),
     cs_cr AS
  (SELECT cs.cs_sold_date_sk,
          cs.cs_item_sk,
          cs.cs_promo_sk,
          cs.cs_catalog_page_sk,
          cs.cs_ext_sales_price,
          cs.cs_net_profit,
          cr.cr_return_amount,
          cr.cr_net_loss
   FROM catalog_sales cs
   LEFT JOIN catalog_returns cr ON cs.cs_item_sk = cr.cr_item_sk
   AND cs.cs_order_number = cr.cr_order_number
   WHERE cs.cs_wholesale_cost BETWEEN 45 AND 60),
     csr AS
  (SELECT cp.cp_catalog_page_id AS catalog_page_id,
          sum(cs_cr.cs_ext_sales_price) AS sales,
          sum(coalesce(cs_cr.cr_return_amount, 0)) AS RETURNS,
          sum(cs_cr.cs_net_profit - coalesce(cs_cr.cr_net_loss, 0)) AS profit
   FROM cs_cr
   JOIN date_dim d ON cs_cr.cs_sold_date_sk = d.d_date_sk
   JOIN item i ON cs_cr.cs_item_sk = i.i_item_sk
   JOIN promotion p ON cs_cr.cs_promo_sk = p.p_promo_sk
   JOIN catalog_page cp ON cs_cr.cs_catalog_page_sk = cp.cp_catalog_page_sk
   WHERE d.d_date BETWEEN cast('2001-08-11' AS date) AND cast('2001-08-11' AS date) + interval '30 day'
     AND i.i_current_price > 50
     AND i.i_category IN (('Jewelry',
                        'Sports'))
     AND p.p_channel_email = 'N'
     AND p.p_channel_tv = 'N'
     AND p.p_channel_radio = 'Y'
     AND p.p_channel_press = 'N'
     AND p.p_channel_event = 'Y'
   GROUP BY cp.cp_catalog_page_id),
     ws_wr AS
  (SELECT ws.ws_sold_date_sk,
          ws.ws_item_sk,
          ws.ws_promo_sk,
          ws.ws_web_site_sk,
          ws.ws_ext_sales_price,
          ws.ws_net_profit,
          wr.wr_return_amt,
          wr.wr_net_loss
   FROM web_sales ws
   LEFT JOIN web_returns wr ON ws.ws_item_sk = wr.wr_item_sk
   AND ws.ws_order_number = wr.wr_order_number
   WHERE ws.ws_wholesale_cost BETWEEN 45 AND 60),
     wsr AS
  (SELECT w.web_site_id,
          sum(ws_wr.ws_ext_sales_price) AS sales,
          sum(coalesce(ws_wr.wr_return_amt, 0)) AS RETURNS,
          sum(ws_wr.ws_net_profit - coalesce(ws_wr.wr_net_loss, 0)) AS profit
   FROM ws_wr
   JOIN date_dim d ON ws_wr.ws_sold_date_sk = d.d_date_sk
   JOIN item i ON ws_wr.ws_item_sk = i.i_item_sk
   JOIN promotion p ON ws_wr.ws_promo_sk = p.p_promo_sk
   JOIN web_site w ON ws_wr.ws_web_site_sk = w.web_site_sk
   WHERE d.d_date BETWEEN cast('2001-08-11' AS date) AND cast('2001-08-11' AS date) + interval '30 day'
     AND i.i_current_price > 50
     AND i.i_category IN (('Jewelry',
                        'Sports'))
     AND p.p_channel_email = 'N'
     AND p.p_channel_tv = 'N'
     AND p.p_channel_radio = 'Y'
     AND p.p_channel_press = 'N'
     AND p.p_channel_event = 'Y'
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