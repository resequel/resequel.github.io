
SELECT MIN(l.title) AS american_vhs_movie
FROM
  (SELECT t.id,
          t.title
   FROM title t
   WHERE t.production_year > 2010) l
JOIN LATERAL
  (SELECT 1
   FROM movie_companies mc
   JOIN company_type ct ON ct.id = mc.company_type_id
   WHERE mc.movie_id = l.id
     AND ct.kind = 'production companies'
     AND mc.note LIKE '%(1994)%'
     AND mc.note LIKE '%(USA)%'
     AND mc.note LIKE '%(VHS)%') mc_filter ON TRUE
JOIN LATERAL
  (SELECT 1
   FROM movie_info mi
   JOIN info_type it ON it.id = mi.info_type_id
   WHERE mi.movie_id = l.id
     AND mi.info IN ('USA', 'America')) mi_filter ON TRUE;