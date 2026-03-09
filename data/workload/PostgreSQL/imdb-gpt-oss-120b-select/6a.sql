WITH mk_filtered AS
  (SELECT mk.movie_id,
          mk.keyword_id
   FROM movie_keyword mk
   JOIN keyword k ON k.id = mk.keyword_id
   WHERE k.keyword = 'marvel-cinematic-universe')
SELECT MIN(k.keyword) AS movie_keyword,
       MIN(n.name) AS actor_name,
       MIN(t.title) AS marvel_movie
FROM mk_filtered mk
JOIN title t ON t.id = mk.movie_id
AND t.production_year > 2010
JOIN cast_info ci ON ci.movie_id = t.id
JOIN name n ON n.id = ci.person_id
JOIN keyword k ON k.id = mk.keyword_id
WHERE n.name LIKE '%Downey%Robert%'
GROUP BY mk.keyword_id;