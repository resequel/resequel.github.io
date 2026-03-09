WITH filtered AS
  (SELECT t.title
   FROM keyword k
   JOIN movie_keyword mk ON mk.keyword_id = k.id
   JOIN title t ON t.id = mk.movie_id
   JOIN movie_info mi ON mi.movie_id = t.id
   WHERE k.keyword LIKE '%sequel%'
     AND t.production_year > 2005
     AND mi.info IN ('Sweden', 'Norway', 'Germany', 'Denmark', 'Swedish', 'Denish', 'Norwegian', 'German'))
SELECT MIN(title) AS movie_title
FROM filtered;