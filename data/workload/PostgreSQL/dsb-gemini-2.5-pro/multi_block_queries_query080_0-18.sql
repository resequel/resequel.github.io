WITH sales_dates_ss AS
  (SELECT ss.*
   FROM store_sales ss
   JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
   WHERE d.d_date BETWEEN cast('2001-08-11' AS date) AND cast('2001-08-11' AS date) + interval '30 day'),
     sales_items_ss AS
  (SELECT sd.*
   FROM sales_dates_ss sd
   JOIN item i ON sd.ss_item_sk = i.i_item_sk
   WHERE i.i_current_price > 50
     AND i.i_category IN (('Jewelry',
                        'Sports'))),
     sales_promo_ss AS
  (SELECT si.*
   FROM sales_items_ss si
   JOIN promotion p ON si.ss_promo_sk = p.p_promo_sk
   WHERE p.p_channel_email = 'N'
     AND p.p_channel_tv = 'N'
     AND p.p_channel_radio = 'Y'
     AND p.p_channel_press = 'N'
     AND p.p_channel_event = 'Y'),
     ssr AS
  (SELECT s.s_store_id AS store_id,
          sum(sp.ss_ext_sales_price) AS sales,
          sum(coalesce(sr.sr_return_amt, 0)) AS RETURNS,
          sum(sp.ss_net_profit - coalesce(sr.sr_net_loss, 0)) AS profit
   FROM sales_promo_ss sp
   JOIN store s ON sp.ss_store_sk = s.s_store_sk
   LEFT JOIN store_returns sr ON sp.ss_item_sk = sr.sr_item_sk
   AND sp.ss_ticket_number = sr.sr_ticket_number
   WHERE sp.ss_wholesale_cost BETWEEN 45 AND 60
   GROUP BY s.s_store_id),
     sales_dates_cs AS
  (SELECT cs.*
   FROM catalog_sales cs
   JOIN date_dim d ON cs.cs_sold_date_sk = d.d_date_sk
   WHERE d.d_date BETWEEN cast('2001-08-11' AS date) AND cast('2001-08-11' AS date) + interval '30 day'),
     sales_items_cs AS
  (SELECT sd.*
   FROM sales_dates_cs sd
   JOIN item i ON sd.cs_item_sk = i.i_item_sk
   WHERE i.i_current_price > 50
     AND i.i_category IN (('Jewelry',
                        'Sports'))),
     sales_promo_cs AS
  (SELECT si.*
   FROM sales_items_cs si
   JOIN promotion p ON si.cs_promo_sk = p.p_promo_sk
   WHERE p.p_channel_email = 'N'
     AND p.p_channel_tv = 'N'
     AND p.p_channel_radio = 'Y'
     AND p.p_channel_press = 'N'
     AND p.p_channel_event = 'Y'),
     csr AS
  (SELECT cp.cp_catalog_page_id AS catalog_page_id,
          sum(sp.cs_ext_sales_price) AS sales,
          sum(coalesce(cr.cr_return_amount, 0)) AS RETURNS,
          sum(sp.cs_net_profit - coalesce(cr.cr_net_loss, 0)) AS profit
   FROM sales_promo_cs sp
   JOIN catalog_page cp ON sp.cs_catalog_page_sk = cp.cp_catalog_page_sk
   LEFT JOIN catalog_returns cr ON sp.cs_item_sk = cr.cr_item_sk
   AND sp.cs_order_number = cr.cr_order_number
   WHERE sp.cs_wholesale_cost BETWEEN 45 AND 60
   GROUP BY cp.cp_catalog_page_id),
     sales_dates_ws AS
  (SELECT ws.*
   FROM web_sales ws
   JOIN date_dim d ON ws.ws_sold_date_sk = d.d_date_sk
   WHERE d.d_date BETWEEN cast('2001-08-11' AS date) AND cast('2001-08-11' AS date) + interval '30 day'),
     sales_items_ws AS
  (SELECT sd.*
   FROM sales_dates_ws sd
   JOIN item i ON sd.ws_item_sk = i.i_item_sk
   WHERE i.i_current_price > 50
     AND i.i_category IN (('Jewelry',
                        'Sports'))),
     sales_promo_ws AS
  (SELECT si.*
   FROM sales_items_ws si
   JOIN promotion p ON si.ws_promo_sk = p.p_promo_sk
   WHERE p.p_channel_email = 'N'
     AND p.p_channel_tv = 'N'
     AND p.p_channel_radio = 'Y'
     AND p.p_channel_press = 'N'
     AND p.p_channel_event = 'Y'),
     wsr AS
  (SELECT w.web_site_id,
          sum(sp.ws_ext_sales_price) AS sales,
          sum(coalesce(wr.wr_return_amt, 0)) AS RETURNS,
          sum(sp.ws_net_profit - coalesce(wr.wr_net_loss, 0)) AS profit
   FROM sales_promo_ws sp
   JOIN web_site w ON sp.ws_web_site_sk = w.web_site_sk
   LEFT JOIN web_returns wr ON sp.ws_item_sk = wr.wr_item_sk
   AND sp.ws_order_number = wr.wr_order_number
   WHERE sp.ws_wholesale_cost BETWEEN 45 AND 60
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