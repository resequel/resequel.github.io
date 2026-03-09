
SELECT /*+ Parallel(4) */ MIN(mi_idx.info) AS rating,
                          MIN(t.title) AS northern_dark_movie
FROM title t
JOIN kind_type kt ON kt.id = t.kind_id
AND kt.kind = 'movie'
JOIN movie_info mi ON mi.movie_id = t.id
JOIN info_type it1 ON it1.id = mi.info_type_id
AND it1.info = 'countries'
JOIN movie_info_idx mi_idx ON mi_idx.movie_id = t.id
JOIN info_type it2 ON it2.id = mi_idx.info_type_id
AND it2.info = 'rating'
JOIN movie_keyword mk ON mk.movie_id = t.id
JOIN keyword k ON k.id = mk.keyword_id
AND k.keyword IN ('murder', 'murder-in-title', 'blood', 'violence')
WHERE mi.info IN ('Sweden', 'Norway', 'Germany', 'Denmark', 'Swedish', 'Denish', 'Norwegian', 'German', 'USA', 'American')
  AND mi_idx.info < '8.5'
  AND t.production_year > 2010;