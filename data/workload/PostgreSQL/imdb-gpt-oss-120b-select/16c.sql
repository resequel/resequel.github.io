WITH actor_ids AS
  (SELECT DISTINCT an.person_id,
                   an.name
   FROM aka_name an
   JOIN name n ON an.person_id = n.id)
SELECT MIN(ai.name) AS cool_actor_pseudonym,
       MIN(t.title) AS series_named_after_char
FROM actor_ids AS ai
JOIN cast_info ci ON ai.person_id = ci.person_id
JOIN title t ON ci.movie_id = t.id
WHERE t.episode_nr < 100
  AND EXISTS
    (SELECT 1
     FROM movie_keyword mk
     JOIN keyword k ON mk.keyword_id = k.id
     WHERE mk.movie_id = t.id
       AND k.keyword = 'character-name-in-title')
  AND EXISTS
    (SELECT 1
     FROM movie_companies mc
     JOIN company_name cn ON mc.company_id = cn.id
     WHERE mc.movie_id = t.id
       AND cn.country_code = '[us]');