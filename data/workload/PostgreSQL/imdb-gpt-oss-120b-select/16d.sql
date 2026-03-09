
CREATE TEMP TABLE tmp_movies ON
COMMIT
DROP AS
SELECT id,
       title
FROM title
WHERE episode_nr >= 5
  AND episode_nr < 100;


SELECT MIN(an.name) AS cool_actor_pseudonym,
       MIN(tm.title) AS series_named_after_char
FROM tmp_movies tm
JOIN cast_info ci ON ci.movie_id = tm.id
JOIN name n ON n.id = ci.person_id
JOIN aka_name an ON an.person_id = n.id
WHERE EXISTS
    (SELECT 1
     FROM movie_companies mc
     JOIN company_name cn ON cn.id = mc.company_id
     WHERE mc.movie_id = tm.id
       AND cn.country_code = '[us]')
  AND EXISTS
    (SELECT 1
     FROM movie_keyword mk
     JOIN keyword k ON k.id = mk.keyword_id
     WHERE mk.movie_id = tm.id
       AND k.keyword = 'character-name-in-title');