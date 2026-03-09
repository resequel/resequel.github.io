WITH filtered_title AS
  (SELECT id,
          title
   FROM title
   WHERE production_year > 2010)
SELECT MIN(mi_idx.info) AS rating,
       MIN(t.title) AS movie_title
FROM
  (SELECT id,
          info_type_id,
          info,
          movie_id
   FROM movie_info_idx
   WHERE info > '9.0') mi_idx
JOIN info_type it ON it.id = mi_idx.info_type_id
JOIN filtered_title t ON t.id = mi_idx.movie_id
JOIN
  (SELECT movie_id,
          keyword_id
   FROM movie_keyword) mk ON mk.movie_id = mi_idx.movie_id
JOIN
  (SELECT id
   FROM keyword
   WHERE keyword LIKE '%sequel%') k ON k.id = mk.keyword_id
WHERE it.info = 'rating';