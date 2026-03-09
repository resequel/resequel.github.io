
SELECT MIN(an.name) AS cool_actor_pseudonym,
       MIN(t.title) AS series_named_after_char
FROM aka_name an
JOIN name n ON n.id = an.person_id
JOIN cast_info ci ON ci.person_id = n.id
JOIN title t ON t.id = ci.movie_id
JOIN movie_companies mc ON mc.movie_id = t.id
JOIN company_name cn ON cn.id = mc.company_id
AND cn.country_code = '[us]'
JOIN movie_keyword mk ON mk.movie_id = t.id
JOIN keyword k ON k.id = mk.keyword_id
AND k.keyword = 'character-name-in-title';