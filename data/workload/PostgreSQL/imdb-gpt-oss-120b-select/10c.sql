
SELECT MIN(chn.name) AS CHARACTER,
       MIN(t.title) AS movie_with_american_producer
FROM title t
JOIN cast_info ci ON ci.movie_id = t.id
JOIN movie_companies mc ON mc.movie_id = t.id
JOIN company_name cn ON cn.id = mc.company_id
JOIN company_type ct ON ct.id = mc.company_type_id
JOIN char_name chn ON chn.id = ci.person_role_id
JOIN role_type rt ON rt.id = ci.role_id
WHERE t.production_year > 1990 
  AND ci.note LIKE '%(producer)%'
  AND cn.country_code = '[us]';