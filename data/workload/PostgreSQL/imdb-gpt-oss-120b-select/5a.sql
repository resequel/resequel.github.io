
SELECT MIN(dt.title) AS typical_european_movie
FROM
  (SELECT t.title,
          t.id
   FROM title t
   JOIN movie_companies mc ON t.id = mc.movie_id
   JOIN company_type ct ON ct.id = mc.company_type_id
   JOIN movie_info mi ON t.id = mi.movie_id
   JOIN info_type it ON it.id = mi.info_type_id
   WHERE ct.kind = 'production companies'
     AND mc.note LIKE '%(France)%'
     AND mc.note LIKE '%(theatrical)%'
     AND mi.info IN ('Sweden', 'Norway', 'Germany', 'Denmark', 'Swedish', 'Denish', 'Norwegian', 'German')
     AND t.production_year > 2005) dt;