SET enable_seqscan = OFF;


SELECT MIN(chn.name) AS voiced_char_name,
       MIN(n.name) AS voicing_actress_name,
       MIN(t.title) AS kung_fu_panda
FROM title t
JOIN movie_info mi ON mi.movie_id = t.id
JOIN cast_info ci ON ci.movie_id = t.id
JOIN name n ON n.id = ci.person_id
JOIN char_name chn ON chn.id = ci.person_role_id
JOIN role_type rt ON rt.id = ci.role_id
JOIN movie_companies mc ON mc.movie_id = t.id
JOIN company_name cn ON cn.id = mc.company_id
JOIN movie_keyword mk ON mk.movie_id = t.id
JOIN keyword k ON k.id = mk.keyword_id
JOIN info_type it ON it.id = mi.info_type_id
WHERE ci.note IN ('(voice)', '(voice: Japanese version)', '(voice) (uncredited)', '(voice: English version)')
  AND cn.country_code = '[us]'
  AND cn.name = 'DreamWorks Animation'
  AND it.info = 'release dates'
  AND k.keyword IN ('hero', 'martial-arts', 'hand-to-hand-combat', 'computer-animated-movie')
  AND mi.info IS NOT NULL
  AND (mi.info LIKE 'Japan:%201%'
       OR mi.info LIKE 'USA:%201%')
  AND n.gender = 'f'
  AND n.name LIKE '%An%'
  AND rt.role = 'actress'
  AND t.production_year > 2010
  AND t.title LIKE 'Kung Fu Panda%';