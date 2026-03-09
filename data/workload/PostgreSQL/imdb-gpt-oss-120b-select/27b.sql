WITH bf AS
  (SELECT mk.movie_id
   FROM movie_keyword mk
   JOIN keyword k ON k.id = mk.keyword_id
   WHERE k.keyword = 'sequel')
SELECT MIN(cn.name) AS producing_company,
       MIN(lt.link) AS link_type,
       MIN(t.title) AS complete_western_sequel
FROM title t
JOIN complete_cast cc ON cc.movie_id = t.id
JOIN comp_cast_type cct2 ON cct2.id = cc.status_id
AND cct2.kind = 'complete'
JOIN movie_companies mc ON mc.movie_id = t.id
JOIN company_name cn ON cn.id = mc.company_id
JOIN company_type ct ON ct.id = mc.company_type_id
AND ct.kind = 'production companies'
JOIN movie_info mi ON mi.movie_id = t.id
AND mi.info IN ('Sweden', 'Germany', 'Swedish', 'German')
JOIN movie_link ml ON ml.movie_id = t.id
JOIN link_type lt ON lt.id = ml.link_type_id
AND lt.link LIKE '%follow%'
WHERE cn.country_code <> '[pl]'
  AND (cn.name LIKE '%Film%'
       OR cn.name LIKE '%Warner%')
  AND mc.note IS NULL
  AND t.production_year = 1998
  AND t.id IN
    (SELECT movie_id
     FROM bf); 