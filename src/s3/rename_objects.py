from boto3 import client, resource

conn = client('s3')


def rename_files_in_directory(bucket, prefix, replace_from, replace_to):
    """
    Rename files containing replacing 'replace_from' to 'replace_to'
    """
    s3 = resource('s3')
    for key in conn.list_objects(Bucket=bucket,
                                 Prefix=prefix)['Contents']:
        if replace_from in key['Key']:
            print(key['Key'])
            new_key_name = key['Key'].replace(replace_from, replace_to)
            s3.Object(bucket, new_key_name) \
              .copy_from(CopySource=bucket + "/" + key['Key'])
            s3.Object(bucket, key['Key']).delete()


if __name__ == "__main__":
    str_bucket_name = "YOUR_BUCKET_NAME"
    str_prefix = "OBJECTS_PREFIX"
    str_replace_from = ".gzip"
    str_replace_to = ".gz"
    rename_files_in_directory(str_bucket_name, str_prefix, str_replace_from, str_replace_to)

