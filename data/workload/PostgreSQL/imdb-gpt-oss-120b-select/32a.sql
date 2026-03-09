
SELECT MIN(lt.link) AS link_type,
       MIN(t1.title) AS first_movie,
       MIN(t2.title) AS second_movie
FROM keyword k
JOIN LATERAL
  (SELECT mk.movie_id,
          t.title
   FROM movie_keyword mk
   JOIN title t ON t.id = mk.movie_id
   WHERE mk.keyword_id = k.id
   LIMIT 1) AS t1(movie_id, title) ON TRUE
JOIN movie_link ml ON ml.movie_id = t1.movie_id
JOIN title t2 ON t2.id = ml.linked_movie_id
JOIN link_type lt ON lt.id = ml.link_type_id
WHERE k.keyword = '10,000-mile-club';