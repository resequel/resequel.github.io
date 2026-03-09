WITH cn_filtered AS
  (SELECT id
   FROM company_name
   WHERE country_code = '[jp]')
SELECT MIN(an.name) AS acress_pseudonym,
       MIN(t.title) AS japanese_anime_movie
FROM aka_name AS an
JOIN name AS n ON an.person_id = n.id
JOIN cast_info AS ci ON n.id = ci.person_id
JOIN title AS t ON ci.movie_id = t.id
JOIN movie_companies AS mc ON t.id = mc.movie_id
JOIN cn_filtered AS cn ON mc.company_id = cn.id
JOIN role_type AS rt ON ci.role_id = rt.id
WHERE ci.note = '(voice: English version)'
  AND mc.note LIKE '%(Japan)%'
  AND mc.note NOT LIKE '%(USA)%'
  AND (mc.note LIKE '%(2006)%'
       OR mc.note LIKE '%(2007)%')
  AND n.name LIKE '%Yo%'
  AND n.name NOT LIKE '%Yu%'
  AND rt.role = 'actress'
  AND t.production_year BETWEEN 2006 AND 2007
  AND (t.title LIKE 'One Piece%'
       OR t.title LIKE 'Dragon Ball Z%')
  AND ci.role_id = rt.id
  AND an.person_id = ci.person_id
  AND ci.movie_id = mc.movie_id;