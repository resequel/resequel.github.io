WITH nation_pairs AS (
    SELECT n1.n_nationkey AS supp_key, n2.n_nationkey AS cust_key,
           n1.n_name AS supp_nation, n2.n_name AS cust_nation
    FROM   nation n1
    JOIN   nation n2 ON TRUE
    WHERE  ((n1.n_name = 'FRANCE' and n2.n_name = 'GERMANY')
                                or (n1.n_name = 'GERMANY' and n2.n_name = 'FRANCE'))
)
SELECT np.supp_nation,
       np.cust_nation,
       EXTRACT(YEAR FROM l.l_shipdate) AS l_year,
       SUM(l.l_extendedprice * (1 - l.l_discount)) AS revenue
FROM   nation_pairs np
JOIN   supplier s   ON s.s_nationkey = np.supp_key
JOIN   lineitem l   ON l.l_suppkey = s.s_suppkey
JOIN   orders o     ON o.o_orderkey = l.l_orderkey
JOIN   customer c   ON c.c_custkey = o.o_custkey
               AND c.c_nationkey = np.cust_key
WHERE  l.l_shipdate BETWEEN date '1995-01-01' and date '1996-12-31'
GROUP BY np.supp_nation, np.cust_nation, EXTRACT(YEAR FROM l.l_shipdate)
ORDER BY np.supp_nation, np.cust_nation, EXTRACT(YEAR FROM l.l_shipdate);