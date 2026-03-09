
SELECT cn.name AS company_name,
       lt.link AS link_type,
       t.title AS german_follow_up
FROM company_name cn
JOIN movie_companies mc ON mc.company_id = cn.id
JOIN company_type ct ON mc.company_type_id = ct.id
JOIN title t ON t.id = mc.movie_id
JOIN movie_keyword mk ON mk.movie_id = t.id
JOIN keyword k ON k.id = mk.keyword_id
JOIN movie_link ml ON ml.movie_id = t.id
JOIN link_type lt ON lt.id = ml.link_type_id
JOIN movie_info mi ON mi.movie_id = t.id
WHERE cn.country_code <> '[pl]'
  AND (cn.name LIKE '%Film%'
       OR cn.name LIKE '%Warner%')
  AND ct.kind = 'production companies'
  AND k.keyword = 'sequel'
  AND lt.link LIKE '%follow%'
  AND mc.note IS NULL
  AND mi.info IN ('Germany', 'German')
  AND t.production_year BETWEEN 2000 AND 2010
GROUP BY cn.name,
         lt.link,
         t.title
ORDER BY cn.name
LIMIT 1; 