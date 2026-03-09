WITH filtered_mk AS
  (SELECT movie_id,
          keyword_id
   FROM movie_keyword
   WHERE keyword_id IN
       (SELECT id
        FROM keyword
        WHERE keyword IN ('sequel', 'revenge', 'based-on-novel'))),
     filtered_mc AS
  (SELECT movie_id,
          company_id,
          company_type_id,
          note
   FROM movie_companies
   WHERE note IS NOT NULL)
SELECT MIN(cn.name) AS from_company,
       MIN(fc.note) AS production_note,
       MIN(t.title) AS movie_based_on_book
FROM company_name cn
JOIN filtered_mc fc ON fc.company_id = cn.id
JOIN company_type ct ON fc.company_type_id = ct.id
JOIN title t ON t.id = fc.movie_id
JOIN filtered_mk fm ON fm.movie_id = t.id
JOIN keyword k ON k.id = fm.keyword_id
JOIN movie_link ml ON ml.movie_id = t.id
JOIN link_type lt ON lt.id = ml.link_type_id
WHERE cn.country_code <> '[pl]'
  AND (cn.name LIKE '20th Century Fox%'
       OR cn.name LIKE 'Twentieth Century Fox%')
  AND ct.kind <> 'production companies'
  AND ct.kind IS NOT NULL
  AND t.production_year > 1950;