SET enable_bitmapscan = ON;


SELECT MIN(cn.name) AS movie_company,
       MIN(mi_idx.info) AS rating,
       MIN(t.title) AS complete_euro_dark_movie
FROM title t
JOIN movie_companies mc ON mc.movie_id = t.id
JOIN company_name cn ON cn.id = mc.company_id
JOIN company_type ct ON ct.id = mc.company_type_id
JOIN complete_cast cc ON cc.movie_id = t.id
JOIN comp_cast_type cct1 ON cct1.id = cc.subject_id
JOIN comp_cast_type cct2 ON cct2.id = cc.status_id
JOIN movie_info_idx mi_idx ON mi_idx.movie_id = t.id
JOIN movie_info mi ON mi.movie_id = t.id
JOIN movie_keyword mk ON mk.movie_id = t.id
JOIN keyword k ON k.id = mk.keyword_id
JOIN info_type it1 ON it1.id = mi.info_type_id
JOIN info_type it2 ON it2.id = mi_idx.info_type_id
JOIN kind_type kt ON kt.id = t.kind_id
WHERE cct1.kind = 'crew'
  AND cct2.kind <> 'complete+verified'
  AND cn.country_code <> '[us]'
  AND it1.info = 'countries'
  AND it2.info = 'rating'
  AND k.keyword IN ('murder', 'murder-in-title', 'blood', 'violence')
  AND kt.kind IN ('movie', 'episode')
  AND mc.note NOT LIKE '%(USA)%'
  AND mc.note LIKE '%(200%)%'
  AND mi.info IN ('Sweden', 'Germany', 'Swedish', 'German')
  AND mi_idx.info > '6.5'
  AND t.production_year > 2005;