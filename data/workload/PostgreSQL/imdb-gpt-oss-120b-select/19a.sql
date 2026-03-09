
SELECT MIN(n.name) AS voicing_actress,
       MIN(t.title) AS voiced_movie
FROM cast_info ci
JOIN name n ON n.id = ci.person_id
JOIN title t ON t.id = ci.movie_id
JOIN movie_companies mc ON mc.movie_id = ci.movie_id
JOIN company_name cn ON cn.id = mc.company_id
JOIN movie_info mi ON mi.movie_id = ci.movie_id
JOIN info_type it ON it.id = mi.info_type_id
JOIN aka_name an ON an.person_id = n.id
JOIN char_name chn ON chn.id = ci.person_role_id
JOIN role_type rt ON rt.id = ci.role_id
WHERE ci.note IN ('(voice)', '(voice: Japanese version)', '(voice) (uncredited)', '(voice: English version)')
  AND cn.country_code = '[us]'
  AND it.info = 'release dates'
  AND mc.note IS NOT NULL
  AND (mc.note LIKE '%(USA)%'
       OR mc.note LIKE '%(worldwide)%')
  AND mi.info IS NOT NULL
  AND (mi.info LIKE 'Japan:%200%'
       OR mi.info LIKE 'USA:%200%')
  AND n.gender = 'f'
  AND n.name LIKE '%Ang%'
  AND rt.role = 'actress'
  AND t.production_year BETWEEN 2005 AND 2009;

