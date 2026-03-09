WITH filter_sets AS
  (SELECT k.id AS keyword_id,
          n.id AS name_id
   FROM keyword k
   JOIN name n ON n.name LIKE 'Z%'
   WHERE k.keyword = 'character-name-in-title')
SELECT MIN(n.name) AS member_in_charnamed_movie,
       MIN(n.name) AS a1
FROM filter_sets fs
JOIN cast_info ci ON fs.name_id = ci.person_id
JOIN title t ON ci.movie_id = t.id
JOIN movie_keyword mk ON t.id = mk.movie_id
AND mk.keyword_id = fs.keyword_id
JOIN movie_companies mc ON t.id = mc.movie_id
JOIN company_name cn ON mc.company_id = cn.id
JOIN name n ON n.id = fs.name_id;