SET enable_hashjoin = ON;


SET max_parallel_workers_per_gather = 4;


SELECT MIN(k.keyword) AS movie_keyword,
       MIN(n.name) AS actor_name,
       MIN(t.title) AS hero_movie
FROM keyword k
JOIN movie_keyword mk ON k.id = mk.keyword_id
JOIN title t ON t.id = mk.movie_id
JOIN cast_info ci ON ci.movie_id = t.id
JOIN name n ON n.id = ci.person_id
WHERE k.keyword IN ('superhero', 'sequel', 'second-part', 'marvel-comics', 'based-on-comic', 'tv-special', 'fight', 'violence')
  AND t.production_year > 2000;