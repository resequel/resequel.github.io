
SELECT MIN(mi.info) AS rating,
       MIN(t.title) AS movie_title
FROM
  (SELECT id,
          title,
          production_year
   FROM title
   WHERE production_year > 1990) t
JOIN
  (SELECT movie_id,
          info,
          info_type_id
   FROM movie_info_idx
   WHERE info > '2.0') mi ON t.id = mi.movie_id
JOIN info_type it ON it.id = mi.info_type_id
AND it.info = 'rating'
JOIN movie_keyword mk ON mk.movie_id = t.id
JOIN keyword k ON k.id = mk.keyword_id
AND k.keyword LIKE '%sequel%';