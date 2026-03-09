
SELECT MIN(mi.info) AS movie_budget,
       MIN(mi_idx.info) AS movie_votes,
       MIN(t.title) AS movie_title
FROM cast_info ci
JOIN name n ON n.id = ci.person_id
JOIN title t ON t.id = ci.movie_id
JOIN movie_info mi ON mi.movie_id = t.id
JOIN movie_info_idx mi_idx ON mi_idx.movie_id = t.id
JOIN info_type it1 ON it1.id = mi.info_type_id
JOIN info_type it2 ON it2.id = mi_idx.info_type_id
WHERE ci.note IN ('(producer)', '(executive producer)')
  AND it1.info = 'budget'
  AND it2.info = 'votes'
  AND n.gender = 'm'
  AND n.name LIKE '%Tim%';

