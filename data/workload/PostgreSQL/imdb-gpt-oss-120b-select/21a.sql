
SELECT MIN(cn.name) AS company_name,
       MIN(lt.link) AS link_type,
       MIN(t.title) AS western_follow_up
FROM
  (SELECT *
   FROM company_name cn
   WHERE cn.name LIKE '%Film%'
   UNION ALL SELECT *
   FROM company_name cn
   WHERE cn.name LIKE '%Warner%') cn
JOIN movie_companies mc ON mc.company_id = cn.id
JOIN company_type ct ON ct.id = mc.company_type_id
JOIN title t ON t.id = mc.movie_id
JOIN movie_link ml ON ml.movie_id = t.id
JOIN link_type lt ON lt.id = ml.link_type_id
JOIN movie_keyword mk ON mk.movie_id = t.id
JOIN keyword k ON k.id = mk.keyword_id
JOIN movie_info mi ON mi.movie_id = t.id
WHERE cn.country_code <> '[pl]'
  AND ct.kind = 'production companies'
  AND k.keyword = 'sequel'
  AND lt.link LIKE '%follow%'
  AND mc.note IS NULL
  AND mi.info IN ('Sweden', 'Norway', 'Germany', 'Denmark', 'Swedish', 'Denish', 'Norwegian', 'German')
  AND t.production_year BETWEEN 1950 AND 2000;