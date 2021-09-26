# ffmpeg-s3-facebook
Docker container for streaming videos from S3 to Facebook

## Build

`docker build . -t ffmpeg-s3-facebook`

## Usage

### AWS Credentials
Copy .env.example to .env, and add your AWS Credentials 


### Facebook Stream Key
Within Facebook, click Live Video, select Go Live, then choose Streaming Software

Expand the Advanced Settings, and ensure that Persistent stream key is toggled to the "on" position.

Copy the stream key that you are presented with.

### Stream

`docker run --rm --env-file=.env -it ffmpeg-s3-facebook -b {bucket} -k {filename} -t {facebook_key}`
