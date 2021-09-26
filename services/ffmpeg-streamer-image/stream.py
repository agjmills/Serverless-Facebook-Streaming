import getopt, sys, os
import boto3
import botocore

def stream(filename, token):
    url = f"rtmps://live-api-s.facebook.com:443/rtmp/{token}"
    command = f'ffmpeg -re -i "{filename}" -c copy -f flv "{url}"'
    os.system(command)

def download(bucket, key):
    s3 = boto3.resource('s3')
    try:
        s3.Bucket(bucket).download_file(key, "/app/" + key)
    except botocore.exceptions.ClientError as exception:
        pass

def main():
    try:
        opts, args = getopt.getopt(sys.argv[1:], "b:k:t:", ["file=", "bucket=", "token="])
    except getopt.GetoptError as err:
        print(err)
        exit(1)

    filename = None
    for o, a in opts:
        if o in ('-b', '--bucket'):
            bucket = a
        if o in ('-k', '--key'):
            key = a
        if o in ('-t', '--token'):
            token = a
    if bucket is not None and key is not None and token is not None:
        download(bucket, key)
        stream(key, token)
    else:
        print('You must provide a filename')

if __name__ == '__main__':
    main()

