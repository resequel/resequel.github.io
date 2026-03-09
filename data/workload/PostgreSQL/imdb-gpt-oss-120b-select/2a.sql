WITH movies_by_company AS
  (SELECT mc.movie_id
   FROM movie_companies mc
   JOIN company_name cn ON cn.id = mc.company_id
   WHERE cn.country_code = '[de]'),
     movies_by_keyword AS
  (SELECT mk.movie_id
   FROM movie_keyword mk
   JOIN keyword k ON k.id = mk.keyword_id
   WHERE k.keyword = 'character-name-in-title')
SELECT MIN(t.title) AS movie_title
FROM title t
WHERE t.id IN
    (SELECT movie_id
     FROM movies_by_company INTERSECT SELECT movie_id
     FROM movies_by_keyword);