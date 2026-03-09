
SELECT MIN(n.name) AS member_in_charnamed_movie
FROM name n
JOIN cast_info ci ON ci.person_id = n.id
JOIN title t ON t.id = ci.movie_id
JOIN LATERAL
  (SELECT 1
   FROM movie_keyword mk
   JOIN keyword k ON k.id = mk.keyword_id
   WHERE mk.movie_id = t.id
     AND k.keyword = 'character-name-in-title'
   LIMIT 1) kw ON TRUE
JOIN LATERAL
  (SELECT 1
   FROM movie_companies mc
   JOIN company_name cn ON cn.id = mc.company_id
   WHERE mc.movie_id = t.id
   LIMIT 1) co ON TRUE
WHERE n.name LIKE '%Bert%';