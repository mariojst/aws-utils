SELECT userid, pid, starttime, endtime, text
  FROM STL_DDLTEXT
 WHERE userid = 000
 -- AND text ILIKE '%tablename%'
 ORDER BY 3 DESC;

SELECT userid, query, querytxt, starttime, endtime, aborted
  FROM STL_QUERY
 WHERE userid = 000
 --- AND query ILIKE '%tablename%'
 ORDER BY 4 desc;


SELECT userid, status, starttime, duration, user_name, query, pid
  FROM stv_recents
 WHERE userid = 000
 -- AND query ILIKE '%tablename%'
 ;

SELECT *
  FROM STL_QUERYTEXT
 WHERE text LIKE '%tablename%';
