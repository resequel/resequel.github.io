WITH kw_hist AS
  (SELECT id
   FROM keyword
   WHERE keyword LIKE '%sequel%' )
SELECT MIN(t.title) AS movie_title
FROM kw_hist k
JOIN movie_keyword mk ON mk.keyword_id = k.id
JOIN title t ON t.id = mk.movie_id
JOIN movie_info mi ON mi.movie_id = t.id
WHERE t.production_year > 1990
  AND mi.info IN ('Sweden', 'Norway', 'Germany', 'Denmark', 'Swedish', 'Denish', 'Norwegian', 'German', 'USA', 'American');