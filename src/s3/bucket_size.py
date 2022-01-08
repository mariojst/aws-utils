from boto3 import client
conn = client('s3')

top_level_folders = dict()


def get_size_str(size):
    if len(size) > 9:
        return str(int(size) * 10e-9) + " GB"
    if len(size) > 6:
        return str(int(size)*10e-6) + " MB"
    if len(size) > 3:
        return str(int(size) * 10e-6) + " KB"
    else:
        return size + " b"


def list_dirs(bucket_name):
    for key in conn.list_objects(Bucket=bucket_name)['Contents']:

        folder = key['Key'].split('/')[0]

        if folder in top_level_folders:
            top_level_folders[folder] += key['Size']
        else:
            top_level_folders[folder] = key['Size']

    for folder, size in top_level_folders.items():
        print("Folder: %s, size: %s" % (folder, get_size_str(str(size))))


if __name__ == "__main__":
    bucket_name = "YOUR_BUCKET_NAME"

    list_dirs(bucket_name)
