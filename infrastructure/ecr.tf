resource "aws_ecr_repository" "ffmpeg-s3-facebook" {
  name = "ffmpeg-s3-facebook"
  image_tag_mutability = "MUTABLE"
  tags = {
    terraform = "true"
    repository = "https://github.com/agjmills/ffmpeg-s3-facebook"
  }
}