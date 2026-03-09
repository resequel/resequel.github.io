
SELECT MIN(mc.note) AS production_note,
       MIN(t.title) AS movie_title,
       MIN(t.production_year) AS movie_year
FROM movie_companies mc
JOIN company_type ct ON ct.id = mc.company_type_id
AND ct.kind = 'production companies'
JOIN title t ON t.id = mc.movie_id
AND t.production_year BETWEEN 2005 AND 2010
WHERE mc.note NOT LIKE '%(as Metro-Goldwyn-Mayer Pictures)%'
  AND EXISTS
    (SELECT 1
     FROM movie_info_idx mi_idx
     JOIN info_type it ON it.id = mi_idx.info_type_id
     WHERE mi_idx.movie_id = mc.movie_id
       AND it.info = 'bottom 10 rank');