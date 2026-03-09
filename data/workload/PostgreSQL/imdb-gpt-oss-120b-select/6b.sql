
SELECT MIN(k.keyword) AS movie_keyword,
       MIN(n.name) AS actor_name,
       MIN(t.title) AS hero_movie
FROM title t
JOIN LATERAL
  (SELECT k.keyword,
          mk.movie_id
   FROM movie_keyword mk
   JOIN keyword k ON k.id = mk.keyword_id
   WHERE mk.movie_id = t.id
     AND k.keyword IN ('superhero', 'sequel', 'second-part', 'marvel-comics', 'based-on-comic', 'tv-special', 'fight', 'violence')
   ORDER BY k.keyword
   LIMIT 1) k ON TRUE
JOIN cast_info ci ON ci.movie_id = t.id
JOIN name n ON n.id = ci.person_id
AND n.name LIKE '%Downey%Robert%'
WHERE t.production_year > 2014;