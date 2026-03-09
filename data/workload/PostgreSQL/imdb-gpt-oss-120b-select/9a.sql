
SELECT MIN(an.name) AS alternative_name,
       MIN(chn.name) AS character_name,
       MIN(t.title) AS movie
FROM name n
JOIN cast_info ci ON n.id = ci.person_id
JOIN aka_name an ON an.person_id = n.id
JOIN char_name chn ON chn.id = ci.person_role_id
JOIN title t ON t.id = ci.movie_id
JOIN movie_companies mc ON mc.movie_id = t.id
JOIN company_name cn ON cn.id = mc.company_id
JOIN role_type rt ON rt.id = ci.role_id
WHERE ci.note IN ('(voice)', '(voice: Japanese version)', '(voice) (uncredited)', '(voice: English version)')
  AND cn.country_code = '[us]'
  AND mc.note IS NOT NULL
  AND (mc.note LIKE '%(USA)%'
       OR mc.note LIKE '%(worldwide)%')
  AND n.gender = 'f'
  AND n.name LIKE '%Ang%'
  AND rt.role = 'actress'
  AND t.production_year BETWEEN 2005 AND 2015;