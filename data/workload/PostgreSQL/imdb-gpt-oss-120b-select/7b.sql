
SELECT MIN(n.name) AS of_person,
       MIN(t.title) AS biography_movie
FROM name n
JOIN aka_name an ON n.id = an.person_id
JOIN person_info pi ON n.id = pi.person_id
JOIN info_type it ON pi.info_type_id = it.id
JOIN cast_info ci ON ci.person_id = n.id
JOIN title t ON t.id = ci.movie_id
JOIN movie_link ml ON ml.linked_movie_id = t.id
JOIN link_type lt ON lt.id = ml.link_type_id
WHERE n.name_pcode_cf LIKE 'D%'
  AND n.gender = 'm'
  AND an.name LIKE '%a%'
  AND pi.note = 'Volker Boehm'
  AND it.info = 'mini biography'
  AND lt.link = 'features'
  AND t.production_year BETWEEN 1980 AND 1984 /*+ Leading(n an pi it ci t ml lt) */;

