
SELECT MIN(an.name) AS alternative_name,
       MIN(chn.name) AS voiced_char_name,
       MIN(n.name) AS voicing_actress,
       MIN(t.title) AS american_movie
FROM aka_name an
JOIN name n ON an.person_id = n.id
JOIN cast_info ci ON ci.person_id = n.id
JOIN char_name chn ON chn.id = ci.person_role_id
JOIN title t ON ci.movie_id = t.id
JOIN movie_companies mc ON t.id = mc.movie_id
JOIN company_name cn ON mc.company_id = cn.id
JOIN role_type rt ON ci.role_id = rt.id
WHERE ci.note IN ('(voice)', '(voice: Japanese version)', '(voice) (uncredited)', '(voice: English version)')
  AND cn.country_code = '[us]'
  AND n.gender = 'f'
  AND rt.role = 'actress';