--####################
-- Get COPY errors
--####################
SELECT *
  FROM STL_LOAD_ERRORS
--WHERE filename NOT LIKE 's3://path%'
 ORDER BY starttime DESC
 LIMIT 20;

--####################
-- Get user by group
--####################
SELECT pg_group.groname,
       pg_user.usename,
       pg_user.usesysid,
       pg_user.usesuper
  FROM pg_user
  JOIN pg_group
    ON pg_user.usesysid = ANY (pg_group.grolist)
-- WHERE pg_group.groname='groupname'
 ORDER BY 1, 2;


SELECT nspname,
       defaclobjtype,
       array_to_string(defaclacl, ',')
  FROM pg_default_acl a
  JOIN pg_namespace b ON a.defaclnamespace=b.oid
 WHERE array_to_string(defaclacl, ',') LIKE '%groupname%';


--####################
-- Table information
--####################
SELECT *
  FROM pg_table_def
-- where schemaname='ua'
 LIMIT 5;

SELECT table_name
  FROM information_schema.columns
 WHERE table_schema = 'schemaname'
   AND table_name LIKE '%tablename%'
   -- AND column_name = 'columname'
LIMIT 5;


-------------
-------------
SELECT relacl ,
       'grant ' || substring(
                  CASE WHEN charindex('r',split_part(split_part(array_to_string(relacl, '|'),pu.groname,2 ) ,'/',1)) > 0 THEN ',SELECT ' ELSE '' END
                ||CASE WHEN charindex('w',split_part(split_part(array_to_string(relacl, '|'),pu.groname,2 ) ,'/',1)) > 0 THEN ',update ' ELSE '' END
                ||CASE WHEN charindex('a',split_part(split_part(array_to_string(relacl, '|'),pu.groname,2 ) ,'/',1)) > 0 THEN ',insert ' ELSE '' END
                ||CASE WHEN charindex('d',split_part(split_part(array_to_string(relacl, '|'),pu.groname,2 ) ,'/',1)) > 0 THEN ',delete ' ELSE '' END
                ||CASE WHEN charindex('R',split_part(split_part(array_to_string(relacl, '|'),pu.groname,2 ) ,'/',1)) > 0 THEN ',rule ' ELSE '' END
                ||CASE WHEN charindex('x',split_part(split_part(array_to_string(relacl, '|'),pu.groname,2 ) ,'/',1)) > 0 THEN ',references ' ELSE '' END
                ||CASE WHEN charindex('t',split_part(split_part(array_to_string(relacl, '|'),pu.groname,2 ) ,'/',1)) > 0 THEN ',trigger ' ELSE '' END
                ||CASE WHEN charindex('X',split_part(split_part(array_to_string(relacl, '|'),pu.groname,2 ) ,'/',1)) > 0 THEN ',execute ' ELSE '' END
                ||CASE WHEN charindex('U',split_part(split_part(array_to_string(relacl, '|'),pu.groname,2 ) ,'/',1)) > 0 THEN ',usage ' ELSE '' END
                ||CASE WHEN charindex('C',split_part(split_part(array_to_string(relacl, '|'),pu.groname,2 ) ,'/',1)) > 0 THEN ',create ' ELSE '' END
                ||CASE WHEN charindex('T',split_part(split_part(array_to_string(relacl, '|'),pu.groname,2 ) ,'/',1)) > 0 THEN ',temporary ' ELSE '' END
             , 2,10000)
       || ' on '||namespace||'.'||item ||' to "'||pu.groname||'";' as grantsql,
       pu.groname
  FROM
       (SELECT use.usename AS subject,
               nsp.nspname AS namespace,
               c.relname AS item,
               c.relkind AS type,
               use2.usename AS owner,
               c.relacl
          FROM pg_user use
         CROSS JOIN pg_class c
          LEFT JOIN pg_namespace nsp ON (c.relnamespace = nsp.oid)
          LEFT JOIN pg_user use2 ON (c.relowner = use2.usesysid)
         WHERE c.relowner = use.usesysid
           AND nsp.nspname NOT IN ('pg_catalog', 'pg_toast', 'information_schema')
       ORDER BY subject,   namespace,   item
       ) a
  JOIN pg_group pu ON array_to_string(relacl, '|') like '%'||pu.groname||'%'
 WHERE relacl IS NOT NULL
 --and pu.groname='groupname'
 --and a.owner = 'username'
 ORDER BY 2;


SELECT *
  FROM STL_CONNECTION_LOG
 WHERE username<>'cerebro'
ORDER BY recordtime DESC;


SELECT tablename,
       tableowner
  FROM pg_tables
 WHERE tablename LIKE 'tablename%'