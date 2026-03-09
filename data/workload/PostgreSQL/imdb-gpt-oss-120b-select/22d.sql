WITH filtered_title AS
  (SELECT id,
          title,
          kind_id
   FROM title
   WHERE production_year > 2005)
SELECT MIN(cn.name) AS movie_company,
       MIN(mi_idx.info) AS rating,
       MIN(t.title) AS western_violent_movie
FROM filtered_title t
JOIN LATERAL
  (SELECT *
   FROM movie_companies mc
   WHERE mc.movie_id = t.id) mc ON TRUE
JOIN LATERAL
  (SELECT *
   FROM company_name cn
   WHERE cn.id = mc.company_id
     AND cn.country_code <> '[us]') cn ON TRUE
JOIN LATERAL
  (SELECT *
   FROM company_type ct
   WHERE ct.id = mc.company_type_id) ct ON TRUE
JOIN LATERAL
  (SELECT *
   FROM movie_info mi
   WHERE mi.movie_id = t.id
     AND mi.info IN ('Sweden', 'Norway', 'Germany', 'Denmark', 'Swedish', 'Danish', 'Norwegian', 'German', 'USA', 'American')) mi ON TRUE
JOIN LATERAL
  (SELECT *
   FROM movie_info_idx mi_idx
   WHERE mi_idx.movie_id = t.id
     AND mi_idx.info < '8.5') mi_idx ON TRUE
JOIN LATERAL
  (SELECT *
   FROM movie_keyword mk
   WHERE mk.movie_id = t.id) mk ON TRUE
JOIN LATERAL
  (SELECT *
   FROM keyword k
   WHERE k.id = mk.keyword_id
     AND k.keyword IN ('murder', 'murder-in-title', 'blood', 'violence')) k ON TRUE
JOIN LATERAL
  (SELECT *
   FROM kind_type kt
   WHERE kt.id = t.kind_id
     AND kt.kind IN ('movie', 'episode')) kt ON TRUE
JOIN LATERAL
  (SELECT *
   FROM info_type it1
   WHERE it1.id = mi.info_type_id
     AND it1.info = 'countries') it1 ON TRUE
JOIN LATERAL
  (SELECT *
   FROM info_type it2
   WHERE it2.id = mi_idx.info_type_id
     AND it2.info = 'rating') it2 ON TRUE;