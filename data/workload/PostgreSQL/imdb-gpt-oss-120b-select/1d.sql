
SELECT MIN(mc.note) AS production_note,
       MIN(t.title) AS movie_title,
       MIN(t.production_year) AS movie_year
FROM company_type ct
JOIN movie_companies mc ON ct.id = mc.company_type_id
JOIN title t ON t.id = mc.movie_id
JOIN movie_info_idx mi_idx ON t.id = mi_idx.movie_id
JOIN info_type it ON it.id = mi_idx.info_type_id
WHERE ct.kind = 'production companies'
  AND it.info = 'bottom 10 rank'
  AND mc.note NOT LIKE '%(as Metro-Goldwyn-Mayer Pictures)%'
  AND t.production_year > 2000;