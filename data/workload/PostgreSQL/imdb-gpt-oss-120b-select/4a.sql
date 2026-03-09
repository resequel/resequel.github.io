/*+ HashJoin(k) */ WITH filtered_title AS
  (SELECT id,
          title
   FROM title
   WHERE production_year > 2005)
SELECT MIN(mi_idx.info) AS rating,
       MIN(t.title) AS movie_title
FROM info_type AS it
JOIN movie_info_idx AS mi_idx ON it.id = mi_idx.info_type_id
JOIN filtered_title AS t ON t.id = mi_idx.movie_id
JOIN movie_keyword AS mk ON mk.movie_id = mi_idx.movie_id
JOIN keyword AS k ON k.id = mk.keyword_id
WHERE it.info = 'rating'
  AND k.keyword LIKE '%sequel%'
  AND mi_idx.info > '5.0';