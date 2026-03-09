
SELECT MIN(cn.name) AS producing_company,
       MIN(lt.link) AS link_type,
       MIN(t.title) AS complete_western_sequel
FROM title t
JOIN complete_cast cc ON cc.movie_id = t.id
JOIN comp_cast_type cct1 ON cct1.id = cc.subject_id
JOIN comp_cast_type cct2 ON cct2.id = cc.status_id
JOIN movie_companies mc ON mc.movie_id = t.id
JOIN company_type ct ON ct.id = mc.company_type_id
JOIN company_name cn ON cn.id = mc.company_id
JOIN movie_info mi ON mi.movie_id = t.id
JOIN movie_keyword mk ON mk.movie_id = t.id
JOIN keyword k ON k.id = mk.keyword_id
AND k.keyword = 'sequel'
JOIN movie_link ml ON ml.movie_id = t.id
JOIN link_type lt ON lt.id = ml.link_type_id
AND lt.link LIKE '%follow%'
WHERE cct1.kind IN ('cast', 'crew')
  AND cct2.kind = 'complete'
  AND cn.country_code <> '[pl]'
  AND (cn.name LIKE '%Film%'
       OR cn.name LIKE '%Warner%')
  AND ct.kind = 'production companies'
  AND mi.info IN ('Sweden', 'Germany', 'Swedish', 'German')
  AND t.production_year BETWEEN 1950 AND 2000
  AND mc.note IS NULL;