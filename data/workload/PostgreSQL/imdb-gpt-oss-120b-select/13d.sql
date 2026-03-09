
CREATE TEMP TABLE tmp_cn ON
COMMIT
DROP AS
SELECT id,
       name
FROM company_name
WHERE country_code = '[us]';


SELECT MIN(tmp_cn.name) AS producing_company,
       MIN(miidx.info) AS rating,
       MIN(t.title) AS movie
FROM tmp_cn
JOIN movie_companies mc ON tmp_cn.id = mc.company_id
JOIN company_type ct ON ct.id = mc.company_type_id
JOIN title t ON t.id = mc.movie_id
JOIN kind_type kt ON kt.id = t.kind_id
JOIN movie_info_idx miidx ON miidx.movie_id = t.id
JOIN info_type it ON it.id = miidx.info_type_id
JOIN movie_info mi ON mi.movie_id = t.id
JOIN info_type it2 ON it2.id = mi.info_type_id
WHERE ct.kind = 'production companies'
  AND it.info = 'rating'
  AND it2.info = 'release dates'
  AND kt.kind = 'movie';