-- Get list of queries to revoke access on all tables on all schemas that the group has access to
SELECT distinct 'REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA '+schemaname+' FROM GROUP groupname;'
  FROM admin.v_get_obj_priv_by_user;

-- Get list of queries to revoke access on all schemas that the group has access to
SELECT distinct 'REVOKE ALL ON SCHEMA '+schemaname+' FROM GROUP groupname;'
  FROM admin.v_get_obj_priv_by_user;

-- Get list of queries to revoke access on all schemas that the group has access to
SELECT distinct 'REVOKE USAGE ON SCHEMA '+schemaname+' FROM GROUP groupname;'
  FROM admin.v_get_obj_priv_by_user;

-- Revoke default privileges
ALTER DEFAULT PRIVILEGES REVOKE ALL ON TABLES FROM GROUP groupname CASCADE ;

-- Finally, drop the group
DROP GROUP groupname;