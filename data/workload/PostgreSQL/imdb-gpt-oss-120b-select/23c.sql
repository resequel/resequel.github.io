WITH filtered_title AS
  (SELECT id,
          title,
          kind_id
   FROM title
   WHERE production_year > 1990)
SELECT MIN(kt.kind) AS movie_kind,
       MIN(t.title) AS complete_us_internet_movie
FROM filtered_title t
JOIN movie_info mi ON t.id = mi.movie_id
JOIN movie_keyword mk ON t.id = mk.movie_id
JOIN movie_companies mc ON t.id = mc.movie_id
JOIN complete_cast cc ON t.id = cc.movie_id
JOIN comp_cast_type cct1 ON cct1.id = cc.status_id
JOIN company_name cn ON cn.id = mc.company_id
JOIN company_type ct ON ct.id = mc.company_type_id
JOIN info_type it1 ON it1.id = mi.info_type_id
JOIN kind_type kt ON kt.id = t.kind_id
JOIN keyword k ON k.id = mk.keyword_id
WHERE cct1.kind = 'complete+verified'
  AND cn.country_code = '[us]'
  AND it1.info = 'release dates'
  AND kt.kind IN ('movie', 'tv movie', 'video movie', 'video game')
  AND mi.note LIKE '%internet%'
  AND mi.info IS NOT NULL
  AND (mi.info LIKE 'USA:% 199%'
       OR mi.info LIKE 'USA:% 200%') ;