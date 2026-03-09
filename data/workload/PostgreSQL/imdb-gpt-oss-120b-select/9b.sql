WITH mc_filt AS
  (SELECT *
   FROM movie_companies
   WHERE note LIKE '%(200%)%'
     OR note LIKE '%(USA)%'
     OR note LIKE '%(worldwide)%'),
     ci_filt AS
  (SELECT *
   FROM cast_info
   WHERE note = '(voice)')
SELECT MIN(an.name) AS alternative_name,
       MIN(chn.name) AS voiced_character,
       MIN(n.name) AS voicing_actress,
       MIN(t.title) AS american_movie
FROM ci_filt ci
JOIN title t ON ci.movie_id = t.id
JOIN mc_filt mc ON mc.movie_id = t.id
JOIN company_name cn ON cn.id = mc.company_id
JOIN role_type rt ON rt.id = ci.role_id
JOIN name n ON n.id = ci.person_id
JOIN char_name chn ON chn.id = ci.person_role_id
JOIN aka_name an ON an.person_id = n.id
WHERE cn.country_code = '[us]'
  AND n.gender = 'f'
  AND n.name LIKE '%Angel%'
  AND rt.role = 'actress'
  AND t.production_year BETWEEN 2007 AND 2010;