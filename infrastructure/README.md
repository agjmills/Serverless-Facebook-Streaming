# ffmpeg-s3-facebook
Infrastructure for serverless deployment of a streaming engine from S3 to Facebook

## Usage
### Initialise Terraform

`docker run -i -v ${PWD}:/app -w /app -t hashicorp/terraform:latest init`

### AWS Credentials
Copy .env.example to .env, and add your AWS Credentials

### Check what infrastructure will be created
`docker run -i --env-file=.env -v ${PWD}:/app -w /app -t hashicorp/terraform:latest plan`

### Create the infrastructure
`docker run -i --env-file=.env -v ${PWD}:/app -w /app -t hashicorp/terraform:latest apply`

### Destroy the infrastructure
`docker run -i --env-file=.env -v ${PWD}:/app -w /app -t hashicorp/terraform:latest destroy`
