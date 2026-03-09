
SELECT MIN(chn.name) AS CHARACTER,
       MIN(t.title) AS russian_mov_with_actor_producer
FROM cast_info ci
JOIN role_type rt ON rt.id = ci.role_id
JOIN char_name chn ON chn.id = ci.person_role_id
JOIN movie_companies mc ON mc.movie_id = ci.movie_id
JOIN company_name cn ON cn.id = mc.company_id
JOIN title t ON t.id = ci.movie_id
JOIN company_type ct ON ct.id = mc.company_type_id
WHERE ci.note LIKE '%(producer)%'
  AND cn.country_code = '[ru]'
  AND rt.role = 'actor'
  AND t.production_year > 2010;