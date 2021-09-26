# Serverlessly stream to Facebook

This is a simple application to demonstrate how to stream videos from AWS S3, to Facebook Live Video.

I created it as a proof of concept, that I could utilise AWS services, whilst still being cheaper than a digital ocean
VPS for a full month.

Based on this project, if you were to stream 8 hour-long videos per month (assuming they're around 2.5GB each), you'd
end up with the following costs:

* VPC Data Transfer: `(8 * 2.5 = 20GB) $1.71 `
* AWS Lambda: `$0.00 (included in free tier)`
* S3: `20GB of standard storage, per month: $0.48`
* S3 Glacier: `20GB of data transitioned from S3 Standard: $0.09`
* AWS Fargate: `60 minutes * 8 per month: $0.39`

Monthly total: `$2.67`, or `$0.33` per hour.

The only cost that would change over time, is that of S3 Glacier - as I would not be removing videos from here, for at
least 12 months.

After 12 months, the S3 Glacier cost would get to `$1.08` per month, for 240GB of storage.

If I compare this to the cheapest Digital Ocean Droplet and their cheapest Block Storage Space, I end up with the following:

| Service      | AWS | Digital Ocean |
| ----------- | ----------- | ----------- |
| Data Transfer      | $1.71       | $0.00 |
| Compute   | $0.39        | $0.06 |
| Storage   | $1.08        | $5.00 |
| Total | $3.18 | $5.06 |

## Infrastructure

The following components are created, and their locations in the Terraform code are as follows:

* VPC - `infrastructure/network.tf`
* Elastic Container Repository - `infrastructure/ecr.tf`
* Elastic Container Service Cluster - `infrastructure/ecs.tf`
* Elastic Container Service Task Definition - `infrastructure/ecs.tf`
* IAM Roles for ECS - `infrastructure/iam.tf`

## Services

### ffmpeg-streamer-image

This service is a Docker image based on Alpine 3.14, which executes a Python 3.9 script, `stream.py`

This script reads 3 input variables (S3 bucket name, Path to file within the bucket and Facebook Streaming Token), and
will download the video from S3 to the container instance, and then automatically stream it to the RTMP endpoint
provided by Facebook, utilising the Facebook Streaming Token provided to it.

### stream-starter

This service is a Lambda function, written in Python, using the Serverless Framework for it's deployment and management.

The lambda function takes 3 arguments as JSON:

```json
{
  "bucket": "my-streaming-bucket",
  "path": "/videos/2021/09/my-first-video.mp4",
  "token": "FB-145652124440674-0-Abx48VAJXUXY"
}
```

The lambda function first tests that the Facebook Streaming Token is valid, by attempting to connect to the RTMP server.

It then persists the request to DynamoDB, along with the requested date/time

Finally, it runs an ECS Task, which execute the `ffmpeg-streamer-image` service on AWS Fargate.

