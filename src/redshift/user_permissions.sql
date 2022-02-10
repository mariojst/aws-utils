--####################
-- Create a new user
--####################

  CREATE USER user_x
      IN GROUP group_a
PASSWORD MD5('username' || 'my_private_text');

--########################################
-- Get all objects owned by user by type
--########################################
SELECT nsp.nspname AS object_schema,
       cls.relname AS object_name,
       cls.relowner AS owner,
       CASE cls.relkind
         WHEN 'r' THEN 'TABLE'
         WHEN 'm' THEN 'MATERIALIZED_VIEW'
         WHEN 'i' THEN 'INDEX'
         WHEN 'S' THEN 'SEQUENCE'
         WHEN 'v' THEN 'VIEW'
         WHEN 'c' THEN 'TYPE'
         ELSE cls.relkind::text
       END AS object_type
  FROM pg_class cls
  JOIN pg_namespace nsp ON nsp.oid = cls.relnamespace
 WHERE nsp.nspname NOT IN ('information_schema', 'pg_catalog')
   AND nsp.nspname NOT LIKE 'pg_toast%'
 -- and rol.rolname = current_user  --- remove this if you want to see all objects
 ORDER BY nsp.nspname, cls.relname;

