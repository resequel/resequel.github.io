
SELECT MIN(mi.info) AS budget,
       MIN(t.title) AS unsuccsessful_movie
FROM title t
JOIN movie_companies mc ON t.id = mc.movie_id
JOIN company_name cn ON cn.id = mc.company_id
JOIN company_type ct ON ct.id = mc.company_type_id
JOIN movie_info mi ON t.id = mi.movie_id
JOIN info_type it1 ON it1.id = mi.info_type_id
JOIN movie_info_idx mi_idx ON t.id = mi_idx.movie_id
JOIN info_type it2 ON it2.id = mi_idx.info_type_id
WHERE cn.country_code = '[us]'
  AND ct.kind IS NOT NULL
  AND (ct.kind = 'production companies'
       OR ct.kind = 'distributors')
  AND it1.info = 'budget'
  AND it2.info = 'bottom 10 rank'
  AND t.production_year > 2000
  AND (t.title LIKE 'Birdemic%'
       OR t.title LIKE '%Movie%');