
CREATE TEMP TABLE tmp_name ON
COMMIT
DROP AS
SELECT id,
       name,
       gender,
       name_pcode_cf
FROM name
WHERE name_pcode_cf BETWEEN 'A' AND 'F'
  AND (gender = 'm'
       OR (gender = 'f'
           AND name LIKE 'B%'));


SELECT MIN(n.name) AS of_person,
       MIN(t.title) AS biography_movie
FROM tmp_name n
JOIN aka_name an ON an.person_id = n.id
AND an.name LIKE '%a%'
JOIN person_info pi ON pi.person_id = n.id
AND pi.note = 'Volker Boehm'
JOIN info_type it ON it.id = pi.info_type_id
AND it.info = 'mini biography'
JOIN cast_info ci ON ci.person_id = n.id
JOIN title t ON t.id = ci.movie_id
AND t.production_year BETWEEN 1980 AND 1995
JOIN movie_link ml ON ml.linked_movie_id = t.id
JOIN link_type lt ON lt.id = ml.link_type_id
AND lt.link = 'features';