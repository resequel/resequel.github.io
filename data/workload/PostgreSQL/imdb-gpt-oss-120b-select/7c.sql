SET enable_hashjoin = ON;


SELECT MIN(n.name) AS cast_member_name,
       MIN(pi.info) AS cast_member_info
FROM name n
JOIN aka_name an ON n.id = an.person_id
JOIN person_info pi ON pi.person_id = n.id
JOIN cast_info ci ON ci.person_id = n.id
JOIN title t ON t.id = ci.movie_id
JOIN movie_link ml ON ml.linked_movie_id = t.id
JOIN link_type lt ON lt.id = ml.link_type_id
JOIN info_type it ON it.id = pi.info_type_id
WHERE an.name IS NOT NULL
  AND (an.name LIKE 'A%'
       OR an.name LIKE '%a%')
  AND it.info = 'mini biography'
  AND lt.link IN ('references', 'referenced in', 'features', 'featured in')
  AND n.name_pcode_cf BETWEEN 'A' AND 'F'
  AND (n.gender = 'm'
       OR (n.gender = 'f'
           AND n.name LIKE 'A%'))
  AND pi.note IS NOT NULL
  AND t.production_year BETWEEN 1980 AND 2010;