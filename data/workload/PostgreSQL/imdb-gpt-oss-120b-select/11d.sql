
SELECT MIN(cn.name) AS from_company,
       MIN(mc.note) AS production_note,
       MIN(t.title) AS movie_based_on_book
FROM company_name cn,
     company_type ct,
     keyword k,
     link_type lt,
     movie_companies mc,
     movie_keyword mk,
     movie_link ml,
     title t
WHERE cn.country_code <> '[pl]'
  AND ct.kind <> 'production companies'
  AND ct.kind IS NOT NULL
  AND k.keyword IN ('sequel', 'revenge', 'based-on-novel')
  AND mc.note IS NOT NULL
  AND t.production_year > 1950
  AND lt.id = ml.link_type_id
  AND ml.movie_id = t.id
  AND t.id = mk.movie_id
  AND mk.keyword_id = k.id
  AND t.id = mc.movie_id
  AND mc.company_type_id = ct.id
  AND mc.company_id = cn.id;