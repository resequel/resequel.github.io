
SELECT MIN(cn.name) AS producing_company,
       MIN(lt.link) AS link_type,
       MIN(t.title) AS complete_western_sequel
FROM complete_cast cc
JOIN comp_cast_type cct1 ON cct1.id = cc.subject_id
JOIN comp_cast_type cct2 ON cct2.id = cc.status_id
JOIN movie_companies mc ON mc.movie_id = cc.movie_id
JOIN company_name cn ON cn.id = mc.company_id
JOIN company_type ct ON ct.id = mc.company_type_id
JOIN movie_link ml ON ml.movie_id = cc.movie_id
JOIN link_type lt ON lt.id = ml.link_type_id
JOIN title t ON t.id = cc.movie_id
WHERE cct1.kind = 'cast'
  AND cct2.kind LIKE 'complete%'
  AND cn.country_code <> '[pl]'
  AND (cn.name LIKE '%Film%'
       OR cn.name LIKE '%Warner%')
  AND ct.kind = 'production companies'
  AND lt.link LIKE '%follow%'
  AND mc.note IS NULL
  AND t.production_year BETWEEN 1950 AND 2010
  AND EXISTS
    (SELECT 1
     FROM keyword k
     JOIN movie_keyword mk ON mk.keyword_id = k.id
     WHERE k.keyword = 'sequel'
       AND mk.movie_id = cc.movie_id)
  AND EXISTS
    (SELECT 1
     FROM movie_info mi
     WHERE mi.movie_id = cc.movie_id
       AND mi.info IN ('Sweden', 'Norway', 'Germany', 'Denmark', 'Swedish', 'Denish', 'Norwegian', 'German', 'English'));