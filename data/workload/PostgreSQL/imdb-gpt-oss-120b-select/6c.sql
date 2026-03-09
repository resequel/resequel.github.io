WITH name_filtered AS
  (SELECT id,
          name
   FROM name
   WHERE name LIKE '%Downey%Robert%')
SELECT MIN(k.keyword) AS movie_keyword,
       MIN(n.name) AS actor_name,
       MIN(t.title) AS marvel_movie
FROM movie_keyword mk
JOIN keyword k ON k.id = mk.keyword_id
AND k.keyword = 'marvel-cinematic-universe'
JOIN title t ON t.id = mk.movie_id
AND t.production_year > 2014
JOIN cast_info ci ON ci.movie_id = t.id
JOIN name_filtered n ON n.id = ci.person_id
GROUP BY k.id;