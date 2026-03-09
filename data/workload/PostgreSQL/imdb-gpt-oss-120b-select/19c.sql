WITH LOOKUP AS
  (SELECT it.id AS it_id,
          rt.id AS rt_id,
          cn.id AS cn_id
   FROM info_type it
   JOIN role_type rt ON rt.role = 'actress'
   JOIN company_name cn ON cn.country_code = '[us]'
   WHERE it.info = 'release dates')
SELECT MIN(n.name) AS voicing_actress,
       MIN(t.title) AS jap_engl_voiced_movie
FROM cast_info ci
JOIN name n ON n.id = ci.person_id
JOIN title t ON t.id = ci.movie_id
JOIN movie_info mi ON mi.movie_id = t.id
JOIN movie_companies mc ON mc.movie_id = t.id
JOIN LOOKUP l ON l.it_id = mi.info_type_id
AND l.rt_id = ci.role_id
AND l.cn_id = mc.company_id
JOIN aka_name an ON an.person_id = n.id
JOIN char_name chn ON chn.id = ci.person_role_id
WHERE ci.note IN ('(voice)', '(voice: Japanese version)', '(voice) (uncredited)', '(voice: English version)')
  AND mi.info IS NOT NULL
  AND (mi.info LIKE 'Japan:%200%'
       OR mi.info LIKE 'USA:%200%')
  AND n.gender = 'f'
  AND n.name LIKE '%An%'
  AND t.production_year > 2000;