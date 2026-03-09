WITH set_hash AS
  (SELECT set_config('enable_hashjoin', 'on', FALSE) AS dummy)
SELECT MIN(mi.info) AS release_date,
       MIN(miidx.info) AS rating,
       MIN(t.title) AS german_movie
FROM title t
JOIN kind_type kt ON kt.id = t.kind_id
AND kt.kind = 'movie'
JOIN movie_companies mc ON mc.movie_id = t.id
JOIN company_name cn ON cn.id = mc.company_id
AND cn.country_code = '[de]'
JOIN company_type ct ON ct.id = mc.company_type_id
AND ct.kind = 'production companies'
JOIN movie_info mi ON mi.movie_id = t.id
JOIN info_type it2 ON it2.id = mi.info_type_id
AND it2.info = 'release dates'
JOIN movie_info_idx miidx ON miidx.movie_id = t.id
JOIN info_type it ON it.id = miidx.info_type_id
AND it.info = 'rating'
WHERE TRUE;