WITH sales_ssr AS
  (SELECT s.s_store_id,
          ss.ss_item_sk,
          ss.ss_ticket_number,
          ss.ss_ext_sales_price,
          ss.ss_net_profit
   FROM store_sales ss
   JOIN date_dim d ON ss.ss_sold_date_sk = d.d_date_sk
   JOIN item i ON ss.ss_item_sk = i.i_item_sk
   JOIN promotion p ON ss.ss_promo_sk = p.p_promo_sk
   JOIN store s ON ss.ss_store_sk = s.s_store_sk
   WHERE d.d_date BETWEEN CAST('2001-08-11' AS date) AND CAST('2001-08-11' AS date) + interval '30 day'
     AND i.i_current_price > 50
     AND i.i_category IN ('Jewelry',
                        'Sports')
     AND p.p_channel_email = 'N'
     AND p.p_channel_tv = 'N'
     AND p.p_channel_radio = 'Y'
     AND p.p_channel_press = 'N'
     AND p.p_channel_event = 'Y'
     AND ss.ss_wholesale_cost BETWEEN 45 AND 60),
     returns_ssr AS
  (SELECT sr_item_sk,
          sr_ticket_number,
          SUM(sr_return_amt) AS r_amt,
          SUM(sr_net_loss) AS r_loss
   FROM store_returns
   GROUP BY sr_item_sk,
            sr_ticket_number),
     ssr AS
  (SELECT s.s_store_id,
          SUM(s.ss_ext_sales_price) AS sales,
          SUM(COALESCE(r.r_amt, 0)) AS RETURNS,
          SUM(s.ss_net_profit - COALESCE(r.r_loss, 0)) AS profit
   FROM sales_ssr s
   LEFT JOIN returns_ssr r ON s.ss_item_sk = r.sr_item_sk
   AND s.ss_ticket_number = r.sr_ticket_number
   GROUP BY s.s_store_id),
     sales_csr AS
  (SELECT cp.cp_catalog_page_id,
          cs.cs_item_sk,
          cs.cs_order_number,
          cs.cs_ext_sales_price,
          cs.cs_net_profit
   FROM catalog_sales cs
   JOIN date_dim d ON cs.cs_sold_date_sk = d.d_date_sk
   JOIN item i ON cs.cs_item_sk = i.i_item_sk
   JOIN promotion p ON cs.cs_promo_sk = p.p_promo_sk
   JOIN catalog_page cp ON cs.cs_catalog_page_sk = cp.cp_catalog_page_sk
   WHERE d.d_date BETWEEN CAST('2001-08-11' AS date) AND CAST('2001-08-11' AS date) + interval '30 day'
     AND i.i_current_price > 50
     AND i.i_category IN ('Jewelry',
                        'Sports')
     AND p.p_channel_email = 'N'
     AND p.p_channel_tv = 'N'
     AND p.p_channel_radio = 'Y'
     AND p.p_channel_press = 'N'
     AND p.p_channel_event = 'Y'
     AND cs.cs_wholesale_cost BETWEEN 45 AND 60),
     returns_csr AS
  (SELECT cr_item_sk,
          cr_order_number,
          SUM(cr_return_amount) AS r_amt,
          SUM(cr_net_loss) AS r_loss
   FROM catalog_returns
   GROUP BY cr_item_sk,
            cr_order_number),
     csr AS
  (SELECT s.cp_catalog_page_id,
          SUM(s.cs_ext_sales_price) AS sales,
          SUM(COALESCE(r.r_amt, 0)) AS RETURNS,
          SUM(s.cs_net_profit - COALESCE(r.r_loss, 0)) AS profit
   FROM sales_csr s
   LEFT JOIN returns_csr r ON s.cs_item_sk = r.cr_item_sk
   AND s.cs_order_number = r.cr_order_number
   GROUP BY s.cp_catalog_page_id),
     sales_wsr AS
  (SELECT w.web_site_id,
          ws.ws_item_sk,
          ws.ws_order_number,
          ws.ws_ext_sales_price,
          ws.ws_net_profit
   FROM web_sales ws
   JOIN date_dim d ON ws.ws_sold_date_sk = d.d_date_sk
   JOIN item i ON ws.ws_item_sk = i.i_item_sk
   JOIN promotion p ON ws.ws_promo_sk = p.p_promo_sk
   JOIN web_site w ON ws.ws_web_site_sk = w.web_site_sk
   WHERE d.d_date BETWEEN CAST('2001-08-11' AS date) AND CAST('2001-08-11' AS date) + interval '30 day'
     AND i.i_current_price > 50
     AND i.i_category IN ('Jewelry',
                        'Sports')
     AND p.p_channel_email = 'N'
     AND p.p_channel_tv = 'N'
     AND p.p_channel_radio = 'Y'
     AND p.p_channel_press = 'N'
     AND p.p_channel_event = 'Y'
     AND ws.ws_wholesale_cost BETWEEN 45 AND 60),
     returns_wsr AS
  (SELECT wr_item_sk,
          wr_order_number,
          SUM(wr_return_amt) AS r_amt,
          SUM(wr_net_loss) AS r_loss
   FROM web_returns
   GROUP BY wr_item_sk,
            wr_order_number),
     wsr AS
  (SELECT s.web_site_id,
          SUM(s.ws_ext_sales_price) AS sales,
          SUM(COALESCE(r.r_amt, 0)) AS RETURNS,
          SUM(s.ws_net_profit - COALESCE(r.r_loss, 0)) AS profit
   FROM sales_wsr s
   LEFT JOIN returns_wsr r ON s.ws_item_sk = r.wr_item_sk
   AND s.ws_order_number = r.wr_order_number
   GROUP BY s.web_site_id)
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
   UNION ALL SELECT 'catalog channel' AS channel, 'catalog_page' || cp_catalog_page_id AS id,
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