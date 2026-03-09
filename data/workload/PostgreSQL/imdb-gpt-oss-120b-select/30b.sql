WITH recent_titles AS
  (SELECT id,
          title
   FROM title
   WHERE production_year > 2000 )
SELECT MIN(mi.info) AS movie_budget,
       MIN(mi_idx.info) AS movie_votes,
       MIN(n.name) AS writer,
       MIN(rt.title) AS complete_gore_movie
FROM recent_titles rt
JOIN movie_info mi ON mi.movie_id = rt.id
JOIN movie_info_idx mi_idx ON mi_idx.movie_id = rt.id
JOIN cast_info ci ON ci.movie_id = rt.id
JOIN movie_keyword mk ON mk.movie_id = rt.id
JOIN complete_cast cc ON cc.movie_id = rt.id
JOIN name n ON n.id = ci.person_id
JOIN comp_cast_type cct1 ON cct1.id = cc.subject_id
JOIN comp_cast_type cct2 ON cct2.id = cc.status_id
JOIN info_type it1 ON it1.id = mi.info_type_id
JOIN info_type it2 ON it2.id = mi_idx.info_type_id
JOIN keyword k ON k.id = mk.keyword_id
WHERE (rt.title LIKE 'Saw%'
       OR rt.title LIKE '%Freddy%'
       OR rt.title LIKE '%Jason%')
  AND cct1.kind IN ('cast', 'crew')
  AND cct2.kind = 'complete+verified'
  AND ci.note IN ('(writer)', '(head writer)', '(written by)', '(story)', '(story editor)')
  AND it1.info = 'genres'
  AND it2.info = 'votes'
  AND k.keyword IN ('murder', 'violence', 'blood', 'gore', 'death', 'female-nudity', 'hospital')
  AND mi.info IN ('Horror', 'Thriller')
  AND n.gender = 'm';