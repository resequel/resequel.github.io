
SELECT MIN(chn.name) AS character_name,
       MIN(mi_idx.info) AS rating,
       MIN(t.title) AS complete_hero_movie
FROM cast_info ci
JOIN char_name chn ON chn.id = ci.person_role_id
JOIN name n ON n.id = ci.person_id
JOIN title t ON t.id = ci.movie_id
JOIN kind_type kt ON kt.id = t.kind_id
JOIN movie_info_idx mi_idx ON mi_idx.movie_id = t.id
JOIN info_type it2 ON it2.id = mi_idx.info_type_id
JOIN complete_cast cc ON cc.movie_id = t.id
JOIN comp_cast_type cct1 ON cct1.id = cc.subject_id
JOIN comp_cast_type cct2 ON cct2.id = cc.status_id
JOIN movie_keyword mk ON mk.movie_id = t.id
JOIN keyword k ON k.id = mk.keyword_id
WHERE cct1.kind = 'cast'
  AND cct2.kind LIKE '%complete%'
  AND kt.kind = 'movie'
  AND it2.info = 'rating'
  AND k.keyword IN ('superhero', 'marvel-comics', 'based-on-comic', 'tv-special', 'fight', 'violence', 'magnet', 'web', 'claw', 'laser')
  AND t.production_year > 2000
  AND chn.name IS NOT NULL
  AND (chn.name LIKE '%man%'
       OR chn.name LIKE '%Man%');