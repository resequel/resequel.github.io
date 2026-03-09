WITH filtered_part AS (
    SELECT p_partkey, p_retailprice, p_mfgr, p_brand, p_type, p_size, p_container, p_retailprice, p_comment
    FROM   part
    WHERE  p_name LIKE '%green%'
)
SELECT n.n_name AS nation,
       EXTRACT(YEAR FROM o.o_orderdate) AS o_year,
       SUM(l.l_extendedprice * (1 - l.l_discount) - ps.ps_supplycost * l.l_quantity) AS sum_profit
FROM   filtered_part fp
JOIN   lineitem l          ON l.l_partkey = fp.p_partkey
JOIN   partsupp ps        ON ps.ps_partkey = fp.p_partkey
JOIN   supplier s          ON s.s_suppkey = l.l_suppkey
JOIN   nation n            ON n.n_nationkey = s.s_nationkey
JOIN   orders o            ON o.o_orderkey = l.l_orderkey
GROUP  BY n.n_name, EXTRACT(YEAR FROM o.o_orderdate)
ORDER  BY n.n_name, o_year DESC;