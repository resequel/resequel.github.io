
SELECT MIN(cn.name) AS from_company,
       MIN(lt.link) AS movie_link_type,
       MIN(t.title) AS sequel_movie
FROM movie_companies mc
JOIN company_name cn ON cn.id = mc.company_id
JOIN company_type ct ON ct.id = mc.company_type_id
JOIN title t ON t.id = mc.movie_id
JOIN movie_link ml ON ml.movie_id = t.id
JOIN link_type lt ON lt.id = ml.link_type_id
JOIN movie_keyword mk ON mk.movie_id = t.id
JOIN keyword k ON k.id = mk.keyword_id
WHERE cn.country_code <> '[pl]'
  AND (cn.name LIKE '%Film%'
       OR cn.name LIKE '%Warner%')
  AND ct.kind = 'production companies'
  AND k.keyword = 'sequel'
  AND lt.link LIKE '%follows%'
  AND mc.note IS NULL
  AND t.production_year = 1998
  AND t.title LIKE '%Money%';