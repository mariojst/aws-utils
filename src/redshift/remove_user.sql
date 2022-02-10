--####################
-- Remove a user
--####################

-- Get list of queries to change ownership of tables owned by user to be deleted
SELECT 'alter table '+schemaname+'."'+tablename+'" owner to other_username;'
  FROM pg_tables
 WHERE tableowner LIKE 'user_to_remove';

-- Get list of queries to revoke access on all schemAS that the user hAS access to
SELECT distinct 'revoke all on schema '+schemaname+' FROM user_to_remove;'
  FROM admin.v_get_obj_priv_by_user
 WHERE usename LIKE 'user_to_remove';

-- Get list of queries to revoke access on all tables that the user hAS access to
SELECT distinct 'revoke all on all tables in schema '+schemaname+' FROM user_to_remove;'
  FROM admin.v_get_obj_priv_by_user
 WHERE usename LIKE 'user_to_remove';

-- Remove the ownership of user schemAS
-- If issues arise, re-construct the view
SELECT ddl||'other_username' AS ddl
  FROM admin.v_find_dropuser_objs
 WHERE objowner = 'user_to_remove';

-- Some users will have default permissions set
-- if so, ALTER DEFAULT PRIVILEGES FOR USER x IN SCHEMA y REVOKE ALL ON TABLES FROM GROUP z
SELECT pg_get_userbyid(d.defacluser) AS user,
       n.nspname AS schema,
       CASE d.defaclobjtype 
        WHEN 'r' THEN 'tables'
        WHEN 'f' THEN 'functions'
       END AS object_type,
       array_to_string(d.defaclacl, ' + ')  AS default_privileges
  FROM pg_catalog.pg_default_acl d
  LEFT JOIN pg_catalog.pg_namespace n on n.oid = d.defaclnamespace;

-- Finally, drop the user
DROP USER user_to_remove;
