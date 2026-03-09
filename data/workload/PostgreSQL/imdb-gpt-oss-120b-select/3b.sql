
SELECT MIN(t.title) AS movie_title
FROM
  (SELECT mk.movie_id
   FROM movie_keyword mk
   JOIN keyword k ON k.id = mk.keyword_id
   WHERE k.keyword LIKE '%sequel%') AS km
JOIN title t ON t.id = km.movie_id
JOIN movie_info mi ON mi.movie_id = t.id
WHERE t.production_year > 2010
  AND mi.info IN ('Bulgaria');