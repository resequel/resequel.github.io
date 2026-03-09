
SELECT MIN(mi.info) AS movie_budget,
       MIN(mi_idx.info) AS movie_votes,
       MIN(n.name) AS male_writer,
       MIN(t.title) AS violent_movie_title
FROM title t
JOIN movie_info mi ON t.id = mi.movie_id
JOIN movie_info_idx mi_idx ON t.id = mi_idx.movie_id
JOIN cast_info ci ON t.id = ci.movie_id
JOIN movie_keyword mk ON t.id = mk.movie_id
JOIN name n ON n.id = ci.person_id
JOIN info_type it1 ON it1.id = mi.info_type_id
JOIN info_type it2 ON it2.id = mi_idx.info_type_id
JOIN keyword k ON k.id = mk.keyword_id
WHERE ci.note IN ('(writer)', '(head writer)', '(written by)', '(story)', '(story editor)')
  AND it1.info = 'genres'
  AND it2.info = 'votes'
  AND k.keyword IN ('murder', 'blood', 'gore', 'death', 'female-nudity')
  AND mi.info = 'Horror'
  AND n.gender = 'm'
  AND t.production_year > 2010
  AND t.title LIKE 'Vampire%';