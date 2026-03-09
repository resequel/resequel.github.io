SET enable_mergejoin = ON;


SELECT MIN(an1.name) AS costume_designer_pseudo,
       MIN(t.title) AS movie_with_costumes
FROM aka_name an1
JOIN name n1 ON an1.person_id = n1.id
JOIN cast_info ci ON n1.id = ci.person_id
JOIN role_type rt ON ci.role_id = rt.id
AND rt.role = 'costume designer'
JOIN title t ON ci.movie_id = t.id
JOIN movie_companies mc ON t.id = mc.movie_id
JOIN company_name cn ON mc.company_id = cn.id
AND cn.country_code = '[us]';