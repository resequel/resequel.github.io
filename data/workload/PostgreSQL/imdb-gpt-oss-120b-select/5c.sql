WITH bf_mc AS
  (SELECT movie_id,
          company_type_id
   FROM movie_companies
   WHERE note LIKE '%(USA)%' 
     AND note NOT LIKE '%(TV)%')
SELECT MIN(t.title) AS american_movie
FROM title t
JOIN movie_info mi ON t.id = mi.movie_id
JOIN bf_mc mc ON t.id = mc.movie_id
JOIN company_type ct ON ct.id = mc.company_type_id
JOIN info_type it ON it.id = mi.info_type_id
WHERE ct.kind = 'production companies'
  AND mi.info IN ('Sweden', 'Norway', 'Germany', 'Denmark', 'Swedish', 'Denish', 'Norwegian', 'German', 'USA', 'American')
  AND t.production_year > 1990;