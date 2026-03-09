WITH filtered_mi AS
  (SELECT mi.movie_id,
          mi.info
   FROM movie_info mi
   JOIN info_type it1 ON it1.id = mi.info_type_id
   WHERE it1.info = 'genres'
     AND mi.info IN ('Drama', 'Horror'))
SELECT MIN(cn.name) AS movie_company,
       MIN(mi_idx.info) AS rating,
       MIN(t.title) AS drama_horror_movie
FROM title t
JOIN movie_companies mc ON mc.movie_id = t.id
JOIN company_name cn ON cn.id = mc.company_id
JOIN company_type ct ON ct.id = mc.company_type_id
JOIN movie_info_idx mi_idx ON mi_idx.movie_id = t.id
JOIN info_type it2 ON it2.id = mi_idx.info_type_id
JOIN filtered_mi fm ON fm.movie_id = t.id
WHERE cn.country_code = '[us]'
  AND ct.kind = 'production companies'
  AND it2.info = 'rating'
  AND mi_idx.info > '8.0'
  AND t.production_year BETWEEN 2005 AND 2008;