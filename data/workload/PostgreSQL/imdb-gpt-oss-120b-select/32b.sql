WITH first_part AS
  (SELECT mk.movie_id,
          t1.title AS title1
   FROM keyword k
   JOIN movie_keyword mk ON mk.keyword_id = k.id
   JOIN title t1 ON t1.id = mk.movie_id
   WHERE k.keyword = 'character-name-in-title')
SELECT MIN(lt.link) AS link_type,
       MIN(fp.title1) AS first_movie,
       MIN(t2.title) AS second_movie
FROM first_part fp
JOIN movie_link ml ON ml.movie_id = fp.movie_id
JOIN title t2 ON t2.id = ml.linked_movie_id
JOIN link_type lt ON lt.id = ml.link_type_id;