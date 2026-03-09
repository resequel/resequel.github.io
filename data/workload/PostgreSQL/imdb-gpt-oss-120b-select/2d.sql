
SELECT MIN(t.title) AS movie_title
FROM title t
JOIN movie_companies mc ON mc.movie_id = t.id
JOIN company_name cn ON cn.id = mc.company_id
JOIN movie_keyword mk ON mk.movie_id = t.id
JOIN keyword k ON k.id = mk.keyword_id
WHERE cn.country_code = '[us]'
  AND k.keyword = 'character-name-in-title'
  AND t.production_year BETWEEN 1990 AND 2020; 