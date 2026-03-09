
SELECT MIN(n.name) AS voicing_actress,
       MIN(t.title) AS kung_fu_panda
FROM cast_info ci
JOIN name n ON n.id = ci.person_id
JOIN title t ON t.id = ci.movie_id
JOIN movie_companies mc ON mc.movie_id = t.id
JOIN movie_info mi ON mi.movie_id = t.id
JOIN role_type rt ON rt.id = ci.role_id
JOIN info_type it ON it.id = mi.info_type_id
JOIN company_name cn ON cn.id = mc.company_id
WHERE ci.note = '(voice)'
  AND cn.country_code = '[us]'
  AND it.info = 'release dates'
  AND mc.note LIKE '%(200%)%'
  AND (mc.note LIKE '%(USA)%'
       OR mc.note LIKE '%(worldwide)%')
  AND mi.info IS NOT NULL
  AND (mi.info LIKE 'Japan:%2007%'
       OR mi.info LIKE 'USA:%2008%')
  AND n.gender = 'f'
  AND n.name LIKE '%Angel%'
  AND rt.role = 'actress'
  AND t.production_year BETWEEN 2007 AND 2008
  AND t.title LIKE '%Kung%Fu%Panda%'
  AND EXISTS
    (SELECT 1
     FROM aka_name an
     WHERE an.person_id = ci.person_id)
  AND EXISTS
    (SELECT 1
     FROM char_name chn
     WHERE chn.id = ci.person_role_id);