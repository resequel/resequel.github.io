WITH filtered_mi AS
  (SELECT *
   FROM movie_info
   WHERE info IN ('Sweden', 'Norway', 'Germany', 'Denmark', 'Swedish', 'Danish', 'Norwegian', 'German', 'USA', 'American'))
SELECT MIN(mi_idx.info) AS rating,
       MIN(t.title) AS north_european_dark_production
FROM info_type it1
JOIN filtered_mi mi ON it1.id = mi.info_type_id
JOIN title t ON t.id = mi.movie_id
JOIN kind_type kt ON kt.id = t.kind_id
JOIN movie_info_idx mi_idx ON mi_idx.movie_id = t.id
JOIN movie_keyword mk ON mk.movie_id = t.id
JOIN keyword k ON k.id = mk.keyword_id
JOIN info_type it2 ON it2.id = mi_idx.info_type_id
WHERE it1.info = 'countries'
  AND it2.info = 'rating'
  AND k.keyword IS NOT NULL
  AND k.keyword IN ('murder', 'murder-in-title', 'blood', 'violence')
  AND kt.kind IN ('movie', 'episode')
  AND mi_idx.info < '8.5'
  AND t.production_year > 2005;