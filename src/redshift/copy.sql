-- CSV Example
COPY schema."table" (column1, column2)
FROM 's3://bucket/prefix/'
CREDENTIALS 'aws_access_key_id=AWS_KEY;aws_secret_access_key=AWS_SECRET'
FORMAT AS CSV IGNOREHEADER 1 GZIP DELIMITER ',' COMPUPDATE OFF STATUPDATE OFF
ACCEPTINVCHARS TRUNCATECOLUMNS DATEFORMAT 'auto';

-- JSON Example
COPY schema."table" (column1, column2)
FROM 's3://bucket/prefix/'
CREDENTIALS 'aws_access_key_id=AWS_KEY;aws_secret_access_key=AWS_SECRET'
FORMAT AS JSON 'auto' GZIP COMPUPDATE OFF STATUPDATE OFF
ACCEPTINVCHARS TRUNCATECOLUMNS DATEFORMAT 'auto' TIMEFORMAT AS 'HH:MI:SS';