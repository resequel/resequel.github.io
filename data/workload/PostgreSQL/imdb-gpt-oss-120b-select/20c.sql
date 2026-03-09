
CREATE TEMP TABLE tmp_mk_kw ON
COMMIT
DROP AS
SELECT mk.movie_id
FROM movie_keyword mk
JOIN keyword k ON k.id = mk.keyword_id
WHERE k.keyword IN ('superhero', 'marvel-comics', 'based-on-comic', 'tv-special', 'fight', 'violence', 'magnet', 'web', 'claw', 'laser');


SELECT MIN(n.name) AS cast_member,
       MIN(t.title) AS complete_dynamic_hero_movie
FROM cast_info ci
JOIN complete_cast cc ON ci.movie_id = cc.movie_id
JOIN comp_cast_type cct1 ON cct1.id = cc.subject_id
JOIN comp_cast_type cct2 ON cct2.id = cc.status_id
JOIN char_name chn ON chn.id = ci.person_role_id
JOIN name n ON n.id = ci.person_id
JOIN title t ON t.id = ci.movie_id
JOIN tmp_mk_kw tm ON tm.movie_id = t.id
JOIN kind_type kt ON kt.id = t.kind_id
WHERE cct1.kind = 'cast'
  AND cct2.kind LIKE '%complete%'
  AND chn.name IS NOT NULL
  AND (chn.name LIKE '%man%'
       OR chn.name LIKE '%Man%')
  AND kt.kind = 'movie'
  AND t.production_year > 2000;