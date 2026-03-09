WITH filtered_title AS
  (SELECT id,
          title
   FROM title
   WHERE production_year > 1990),
     filtered_companies AS
  (SELECT *
   FROM movie_companies
   WHERE company_type_id IN
       (SELECT id
        FROM company_type))
SELECT MIN(at.title) AS aka_title,
       MIN(t.title) AS internet_movie_title
FROM filtered_title t
JOIN aka_title AT ON t.id = at.movie_id
JOIN movie_info mi ON t.id = mi.movie_id
JOIN movie_keyword mk ON t.id = mk.movie_id
JOIN filtered_companies mc ON t.id = mc.movie_id
JOIN keyword k ON k.id = mk.keyword_id
JOIN info_type it1 ON it1.id = mi.info_type_id
JOIN company_name cn ON cn.id = mc.company_id
JOIN company_type ct ON ct.id = mc.company_type_id
WHERE cn.country_code = '[us]'
  AND it1.info = 'release dates'
  AND mi.note LIKE '%internet%';

