WITH needed AS
  (SELECT t.id,
          t.title,
          mi.info AS budget,
          mi_idx.info AS votes,
          n.name AS writer
   FROM title t
   JOIN movie_info mi ON t.id = mi.movie_id
   JOIN movie_info_idx mi_idx ON t.id = mi_idx.movie_id
   JOIN cast_info ci ON t.id = ci.movie_id
   JOIN name n ON n.id = ci.person_id
   WHERE t.production_year > 2000
     AND ci.note IN ('(writer)', '(head writer)', '(written by)', '(story)', '(story editor)')
     AND n.gender = 'm'
     AND mi.info IN ('Horror', 'Thriller')
     AND EXISTS
       (SELECT 1
        FROM info_type it1
        WHERE it1.id = mi.info_type_id
          AND it1.info = 'genres')
     AND EXISTS
       (SELECT 1
        FROM info_type it2
        WHERE it2.id = mi_idx.info_type_id
          AND it2.info = 'votes'))
SELECT MIN(budget) AS movie_budget,
       MIN(votes) AS movie_votes,
       MIN(writer) AS writer,
       MIN(title) AS complete_violent_movie
FROM needed
JOIN movie_keyword mk ON needed.id = mk.movie_id
JOIN complete_cast cc ON needed.id = cc.movie_id
JOIN comp_cast_type cct1 ON cct1.id = cc.subject_id
AND cct1.kind IN ('cast', 'crew')
JOIN comp_cast_type cct2 ON cct2.id = cc.status_id
AND cct2.kind = 'complete+verified'
WHERE mk.keyword_id IN
    (SELECT id
     FROM keyword
     WHERE keyword IN ('murder', 'violence', 'blood', 'gore', 'death', 'female-nudity', 'hospital'));

