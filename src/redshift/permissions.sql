-- Check for a user's schema permissions
SELECT
   u.usename,
   s.schemaname,
   has_schema_privilege(u.usename,s.schemaname,'create') AS user_has_select_permission,
   has_schema_privilege(u.usename,s.schemaname,'usage') AS user_has_usage_permission
FROM
   pg_user u
CROSS JOIN
   (SELECT DISTINCT schemaname FROM pg_tables) s
WHERE
   u.usename = 'username';


-- Check for a user's table permissions
SELECT
   u.usename,
   t.schemaname||'.'||t.tablename,
   has_table_privilege(u.usename,t.tablename,'select') AS user_has_select_permission,
   has_table_privilege(u.usename,t.tablename,'insert') AS user_has_insert_permission,
   has_table_privilege(u.usename,t.tablename,'update') AS user_has_update_permission,
   has_table_privilege(u.usename,t.tablename,'delete') AS user_has_delete_permission,
   has_table_privilege(u.usename,t.tablename,'references') AS user_has_references_permission
FROM
   pg_user u
CROSS JOIN
   pg_tables t
WHERE
   u.usename = 'username'
   AND t.tablename = 'tablename'
;


GRANT USAGE ON SCHEMA schemaname TO GROUP groupname;
GRANT USAGE ON SCHEMA schemaname TO username;
GRANT ALL ON SCHEMA schemaname TO username;
GRANT ALL ON SCHEMA schemaname TO GROUP groupname;
GRANT ALL ON TABLE tablename TO GROUP groupname;

GRANT SELECT ON ALL TABLES IN SCHEMA public TO GROUP groupname;
GRANT ALL ON ALL TABLES IN SCHEMA schemaname TO username;

ALTER DEFAULT PRIVILEGES IN SCHEMA schemaname GRANT SELECT ON TABLES TO GROUP groupname;
ALTER DEFAULT PRIVILEGES IN SCHEMA schemaname GRANT ALL ON TABLES TO GROUP groupname;
ALTER DEFAULT PRIVILEGES FOR USER username IN SCHEMA schemaname GRANT SELECT ON TABLES TO GROUP groupname;

REVOKE CREATE ON SCHEMA schemaname FROM GROUP groupname;
REVOKE ALL ON ALL tables IN SCHEMA schemaname FROM GROUP groupname;
REVOKE SELECT ON ALL TABLES IN SCHEMA schemaname FROM username;

SELECT has_schema_privilege('username', 'schemaname', 'create');
SELECT has_table_privilege('username', 'schemaname.tablename', 'select');