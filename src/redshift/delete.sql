-- Delete using join example
DELETE
  FROM schema."tablename"
 USING (SELECT *
          FROM schema."tablename2"
         WHERE column1='filter') t
 WHERE t.key1=schema."tablename".key1
   AND t.key2=schema."tablename".key2;