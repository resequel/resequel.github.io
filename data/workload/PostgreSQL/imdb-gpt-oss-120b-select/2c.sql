
CREATE TEMP TABLE tmp_movie_ids ON
COMMIT
DROP AS
SELECT mc.movie_id
FROM movie_companies mc
JOIN company_name cn ON cn.id = mc.company_id
WHERE cn.country_code = '[sm]';


SELECT MIN(t.title) AS movie_title
FROM tmp_movie_ids tm
JOIN title t ON t.id = tm.movie_id
JOIN movie_keyword mk ON mk.movie_id = t.id
JOIN keyword k ON k.id = mk.keyword_id
WHERE k.keyword = 'character-name-in-title';