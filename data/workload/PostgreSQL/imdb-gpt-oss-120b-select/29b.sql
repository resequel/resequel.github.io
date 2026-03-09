
CREATE TEMP TABLE tmp_ci_note (note text PRIMARY KEY) ON
COMMIT
DROP;


INSERT INTO tmp_ci_note (note)
SELECT unnest(ARRAY['(voice)', '(voice) (uncredited)', '(voice: English version)']);

WITH filtered_title AS
  (SELECT id,
          title,
          production_year
   FROM title
   WHERE production_year BETWEEN 2000 AND 2005
     AND title = 'Shrek 2')
SELECT MIN(chn.name) AS voiced_char,
       MIN(n.name) AS voicing_actress,
       MIN(t.title) AS voiced_animation
FROM filtered_title t
JOIN movie_info mi ON t.id = mi.movie_id
JOIN movie_companies mc ON t.id = mc.movie_id
JOIN company_name cn ON cn.id = mc.company_id
AND cn.country_code = '[us]'
JOIN cast_info ci ON t.id = ci.movie_id
JOIN tmp_ci_note tn ON tn.note = ci.note
JOIN movie_keyword mk ON t.id = mk.movie_id
JOIN keyword k ON k.id = mk.keyword_id
JOIN complete_cast cc ON t.id = cc.movie_id
JOIN comp_cast_type cct1 ON cct1.id = cc.subject_id
AND cct1.kind = 'cast'
JOIN comp_cast_type cct2 ON cct2.id = cc.status_id
AND cct2.kind = 'complete+verified'
JOIN char_name chn ON chn.id = ci.person_role_id
AND chn.name = 'Queen'
JOIN name n ON n.id = ci.person_id
JOIN aka_name an ON an.person_id = n.id
JOIN person_info pi ON pi.person_id = n.id
JOIN info_type it ON it.id = mi.info_type_id
AND it.info = 'release dates'
JOIN info_type it3 ON it3.id = pi.info_type_id
AND it3.info = 'height'
JOIN role_type rt ON rt.id = ci.role_id
AND rt.role = 'actress'
WHERE mi.info LIKE 'USA:%200%'
  AND n.gender = 'f'
  AND n.name LIKE '%An%';