-- Include new column on table
ALTER TABLE schemaname.tablename ADD column_new varchar(500) NULL;

-- Update original table
UPDATE tablename
   SET column_new = columname
 WHERE 1=1;

-- Remove old column
ALTER TABLE schemaname.tablename DROP COLUMN columname;

-- Rename new column
ALTER TABLE schemaname.tablename RENAME COLUMN column_new TO columname;