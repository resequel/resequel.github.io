
SELECT MIN(mc.note) AS production_note,
       MIN(t.title) AS movie_title,
       MIN(t.production_year) AS movie_year
FROM company_type ct
JOIN movie_companies mc ON ct.id = mc.company_type_id
JOIN title t ON t.id = mc.movie_id
WHERE ct.kind = 'production companies'
  AND mc.note NOT LIKE '%(as Metro-Goldwyn-Mayer Pictures)%'
  AND (mc.note LIKE '%(co-production)%'
       OR mc.note LIKE '%(presents)%')
  AND EXISTS
    (SELECT 1
     FROM movie_info_idx mi_idx
     JOIN info_type it ON it.id = mi_idx.info_type_id
     WHERE mi_idx.movie_id = t.id
       AND it.info = 'top 250 rank');