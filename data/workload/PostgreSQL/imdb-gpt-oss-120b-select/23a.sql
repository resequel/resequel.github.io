
SELECT MIN(kt.kind) AS movie_kind,
       MIN(t.title) AS complete_us_internet_movie
FROM title t
JOIN kind_type kt ON kt.id = t.kind_id
WHERE t.production_year > 2000
  AND kt.kind IN ('movie')
  AND EXISTS
    (SELECT 1
     FROM movie_info mi
     JOIN info_type it1 ON it1.id = mi.info_type_id
     WHERE mi.movie_id = t.id
       AND mi.info IS NOT NULL
       AND mi.note LIKE '%internet%'
       AND (mi.info LIKE 'USA:% 199%'
            OR mi.info LIKE 'USA:% 200%')
       AND it1.info = 'release dates')
  AND EXISTS
    (SELECT 1
     FROM complete_cast cc
     JOIN comp_cast_type cct1 ON cct1.id = cc.status_id
     WHERE cc.movie_id = t.id
       AND cct1.kind = 'complete+verified')
  AND EXISTS
    (SELECT 1
     FROM movie_companies mc
     JOIN company_name cn ON cn.id = mc.company_id
     JOIN company_type ct ON ct.id = mc.company_type_id
     WHERE mc.movie_id = t.id
       AND cn.country_code = '[us]')
  AND EXISTS
    (SELECT 1
     FROM movie_keyword mk
     JOIN keyword k ON k.id = mk.keyword_id
     WHERE mk.movie_id = t.id);