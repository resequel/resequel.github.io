WITH mc_filtered AS
  (SELECT *
   FROM movie_companies
   WHERE company_type_id =
       (SELECT id
        FROM company_type
        WHERE kind = 'production companies'))
SELECT MIN(cn.name) AS movie_company,
       MIN(mi_idx.info) AS rating,
       MIN(t.title) AS mainstream_movie
FROM title t
JOIN mc_filtered mc ON mc.movie_id = t.id
JOIN company_name cn ON cn.id = mc.company_id
JOIN movie_info_idx mi_idx ON mi_idx.movie_id = t.id
JOIN info_type it2 ON it2.id = mi_idx.info_type_id
WHERE cn.country_code = '[us]'
  AND it2.info = 'rating'
  AND mi_idx.info > '7.0'
  AND t.production_year BETWEEN 2000 AND 2010
  AND EXISTS
    (SELECT 1
     FROM movie_info mi
     JOIN info_type it1 ON it1.id = mi.info_type_id
     WHERE mi.movie_id = t.id
       AND it1.info = 'genres'
       AND mi.info IN ('Drama', 'Horror', 'Western', 'Family'));