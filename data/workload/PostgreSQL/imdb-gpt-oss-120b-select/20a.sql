
SELECT MIN(t.title) AS complete_downey_ironman_movie
FROM title t
JOIN kind_type kt ON kt.id = t.kind_id
JOIN movie_keyword mk ON mk.movie_id = t.id
JOIN keyword k ON k.id = mk.keyword_id
JOIN complete_cast cc ON cc.movie_id = t.id
JOIN comp_cast_type cct1 ON cct1.id = cc.subject_id
JOIN comp_cast_type cct2 ON cct2.id = cc.status_id
JOIN cast_info ci ON ci.movie_id = t.id
JOIN char_name chn ON chn.id = ci.person_role_id
JOIN name n ON n.id = ci.person_id
WHERE cct1.kind = 'cast'
  AND cct2.kind LIKE '%complete%'
  AND chn.name NOT LIKE '%Sherlock%'
  AND (chn.name LIKE '%Tony%Stark%'
       OR chn.name LIKE '%Iron%Man%')
  AND k.keyword IN ('superhero', 'sequel', 'second-part', 'marvel-comics', 'based-on-comic', 'tv-special', 'fight', 'violence')
  AND kt.kind = 'movie'
  AND t.production_year > 1950;