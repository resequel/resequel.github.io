
SELECT MIN(an.name) AS actress_pseudonym,
       MIN(t.title) AS japanese_movie_dubbed
FROM aka_name AS an
JOIN name AS n ON an.person_id = n.id
JOIN cast_info AS ci ON n.id = ci.person_id
JOIN title AS t ON ci.movie_id = t.id
JOIN movie_companies mc ON t.id = mc.movie_id
JOIN company_name cn ON mc.company_id = cn.id
JOIN role_type rt ON ci.role_id = rt.id
WHERE ci.note = '(voice: English version)' 
  AND cn.country_code = '[jp]' 
  AND mc.note LIKE '%(Japan)%' 
  AND mc.note NOT LIKE '%(USA)%'
  AND n.name LIKE '%Yo%' 
  AND n.name NOT LIKE '%Yu%'
  AND rt.role = 'actress'; 