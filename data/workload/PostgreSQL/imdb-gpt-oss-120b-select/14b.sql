WITH title_match AS
  (SELECT id
   FROM title
   WHERE title LIKE '%Mord%'
   UNION ALL SELECT id
   FROM title
   WHERE title LIKE '%murder%'
   UNION ALL SELECT id
   FROM title
   WHERE title LIKE '%Murder%')
SELECT MIN(mi_idx.info) AS rating,
       MIN(t.title) AS western_dark_production
FROM title_match tm
JOIN title t ON t.id = tm.id
JOIN kind_type kt ON kt.id = t.kind_id
JOIN movie_info mi ON mi.movie_id = t.id
JOIN movie_info_idx mi_idx ON mi_idx.movie_id = t.id
JOIN movie_keyword mk ON mk.movie_id = t.id
JOIN keyword k ON k.id = mk.keyword_id
JOIN info_type it1 ON it1.id = mi.info_type_id
JOIN info_type it2 ON it2.id = mi_idx.info_type_id
WHERE it1.info = 'countries'
  AND it2.info = 'rating'
  AND k.keyword IN ('murder', 'murder-in-title')
  AND kt.kind = 'movie'
  AND mi.info IN ('Sweden', 'Norway', 'Germany', 'Denmark', 'Swedish', 'Denish', 'Norwegian', 'German', 'USA', 'American')
  AND mi_idx.info > '6.0'
  AND t.production_year > 2010;