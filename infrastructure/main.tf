provider "aws" {
	profile = "default"
	region = "eu-west-2"
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}