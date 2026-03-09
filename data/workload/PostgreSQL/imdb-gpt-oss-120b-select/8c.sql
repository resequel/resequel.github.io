SET enable_hashjoin = ON;


SELECT MIN(a1.name) AS writer_pseudo_name,
       MIN(t.title) AS movie_title
FROM role_type rt
JOIN cast_info ci ON ci.role_id = rt.id
JOIN name n1 ON n1.id = ci.person_id
JOIN aka_name a1 ON a1.person_id = n1.id
JOIN movie_companies mc ON mc.movie_id = ci.movie_id
JOIN company_name cn ON cn.id = mc.company_id
JOIN title t ON t.id = mc.movie_id
WHERE rt.role = 'writer'
  AND cn.country_code = '[us]'
GROUP BY rt.role;