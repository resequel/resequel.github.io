WITH kw AS
  (SELECT id
   FROM keyword
   WHERE keyword IN ('superhero', 'marvel-comics', 'based-on-comic', 'fight')),
     mi AS
  (SELECT movie_id,
          info
   FROM movie_info_idx
   WHERE info_type_id =
       (SELECT id
        FROM info_type
        WHERE info = 'rating')
     AND info > '8.0')
SELECT MIN(chn.name) AS character_name,
       MIN(mi.info) AS rating,
       MIN(t.title) AS complete_hero_movie
FROM title t
JOIN kind_type kt ON kt.id = t.kind_id
AND kt.kind = 'movie'
JOIN mi mi ON mi.movie_id = t.id
JOIN movie_keyword mk ON mk.movie_id = t.id
JOIN kw kw ON kw.id = mk.keyword_id
JOIN cast_info ci ON ci.movie_id = t.id
JOIN char_name chn ON chn.id = ci.person_role_id
JOIN name n ON n.id = ci.person_id
JOIN complete_cast cc ON cc.movie_id = t.id
JOIN comp_cast_type cct1 ON cct1.id = cc.subject_id
AND cct1.kind = 'cast'
JOIN comp_cast_type cct2 ON cct2.id = cc.status_id
AND cct2.kind LIKE '%complete%'
WHERE chn.name IS NOT NULL
  AND (chn.name LIKE '%man%'
       OR chn.name LIKE '%Man%')
  AND t.production_year > 2005;