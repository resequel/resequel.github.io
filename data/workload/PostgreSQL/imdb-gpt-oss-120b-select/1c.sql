WITH filtered_mc AS
  (SELECT id,
          movie_id,
          company_id,
          company_type_id,
          note
   FROM movie_companies
   WHERE note NOT LIKE '%(as Metro-Goldwyn-Mayer Pictures)%'
     AND note LIKE '%(co-production)%'),
     filtered_t AS
  (SELECT id,
          title,
          production_year
   FROM title
   WHERE production_year > 2010)
SELECT MIN(mc.note) AS production_note,
       MIN(t.title) AS movie_title,
       MIN(t.production_year) AS movie_year
FROM filtered_mc mc
JOIN filtered_t t ON t.id = mc.movie_id
JOIN company_type ct ON ct.id = mc.company_type_id
JOIN movie_info_idx mi_idx ON mi_idx.movie_id = mc.movie_id
JOIN info_type it ON it.id = mi_idx.info_type_id
WHERE ct.kind = 'production companies'
  AND it.info = 'top 250 rank';