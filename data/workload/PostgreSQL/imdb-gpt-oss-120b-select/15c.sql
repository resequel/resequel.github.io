
SELECT MIN(mi.info) AS release_date,
       MIN(t.title) AS modern_american_internet_movie
FROM aka_title AT,
               company_name cn,
               company_type ct,
               info_type it1,
               keyword k,
               movie_companies mc,
               movie_info mi,
               movie_keyword mk,
               title t
WHERE cn.country_code = '[us]'
  AND it1.info = 'release dates'
  AND mi.note LIKE '%internet%'
  AND mi.info IS NOT NULL
  AND (mi.info LIKE 'USA:% 199%'
       OR mi.info LIKE 'USA:% 200%')
  AND t.production_year > 1990
  AND t.id = at.movie_id
  AND t.id = mi.movie_id
  AND t.id = mk.movie_id
  AND t.id = mc.movie_id
  AND k.id = mk.keyword_id
  AND it1.id = mi.info_type_id
  AND cn.id = mc.company_id
  AND ct.id = mc.company_type_id;