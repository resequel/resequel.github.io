
SELECT MIN(cn.name) AS movie_company,
       MIN(mi_idx.info) AS rating,
       MIN(t.title) AS western_violent_movie
FROM company_name cn
JOIN movie_companies mc ON cn.id = mc.company_id
JOIN company_type ct ON ct.id = mc.company_type_id
JOIN title t ON t.id = mc.movie_id
JOIN kind_type kt ON kt.id = t.kind_id
JOIN movie_info mi ON mi.movie_id = t.id
JOIN info_type it1 ON it1.id = mi.info_type_id
JOIN movie_info_idx mi_idx ON mi_idx.movie_id = t.id
JOIN info_type it2 ON it2.id = mi_idx.info_type_id
JOIN movie_keyword mk ON mk.movie_id = t.id
JOIN keyword k ON k.id = mk.keyword_id
WHERE cn.country_code <> '[us]'
  AND it1.info = 'countries'
  AND it2.info = 'rating'
  AND k.keyword IN ('murder', 'murder-in-title', 'blood', 'violence')
  AND kt.kind IN ('movie', 'episode')
  AND mc.note NOT LIKE '%(USA)%'
  AND mc.note LIKE '%(200%)%'
  AND mi.info IN ('Sweden', 'Norway', 'Germany', 'Denmark', 'Swedish', 'Danish', 'Norwegian', 'German', 'USA', 'American')
  AND mi_idx.info < '8.5'
  AND t.production_year > 2005;