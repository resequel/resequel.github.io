
SELECT MIN(chn.name) AS uncredited_voiced_character,
       MIN(t.title) AS russian_movie
FROM cast_info ci /*+ IndexScan(ci idx_cast_info_note) */
JOIN title t ON t.id = ci.movie_id /*+ IndexScan(t idx_title_production_year) */
JOIN char_name chn ON chn.id = ci.person_role_id
JOIN role_type rt ON rt.id = ci.role_id /*+ IndexScan(rt idx_role_type_role) */
JOIN movie_companies mc ON mc.movie_id = t.id
JOIN company_name cn ON cn.id = mc.company_id /*+ IndexScan(cn idx_company_name_country_code) */
JOIN company_type ct ON ct.id = mc.company_type_id
WHERE ci.note LIKE '%(voice)%'
  AND ci.note LIKE '%(uncredited)%'
  AND cn.country_code = '[ru]'
  AND rt.role = 'actor'
  AND t.production_year > 2005;