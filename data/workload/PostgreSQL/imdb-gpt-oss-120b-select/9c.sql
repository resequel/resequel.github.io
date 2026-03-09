WITH filtered_data AS MATERIALIZED
  (SELECT ci.id, ci.person_id, ci.person_role_id, ci.movie_id, ci.role_id, n.name AS actress_name, an.name AS alt_name, chn.name AS voiced_name, t.title AS movie_title, cn.country_code, rt.role, ci.note
   FROM cast_info ci
   JOIN name n ON n.id = ci.person_id
   JOIN aka_name an ON an.person_id = n.id
   JOIN char_name chn ON chn.id = ci.person_role_id
   JOIN title t ON t.id = ci.movie_id
   JOIN movie_companies mc ON mc.movie_id = t.id
   JOIN company_name cn ON cn.id = mc.company_id
   JOIN role_type rt ON rt.id = ci.role_id
   WHERE ci.note IN ('(voice)', '(voice: Japanese version)', '(voice) (uncredited)', '(voice: English version)')
     AND cn.country_code = '[us]'
     AND n.gender = 'f'
     AND n.name LIKE '%An%'
     AND rt.role = 'actress')
SELECT MIN(alt_name) AS alternative_name,
       MIN(voiced_name) AS voiced_character_name,
       MIN(actress_name) AS voicing_actress,
       MIN(movie_title) AS american_movie
FROM filtered_data;