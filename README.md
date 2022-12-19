# IaC - Phone Validator
Infrastructure as Code for an application with Front and Backend architecture

## Description

Following the Infrastructure as Code [IaC](https://en.wikipedia.org/wiki/Infrastructure_as_code) principles
This repositority contains [Terraform](https://learn.hashicorp.com/terraform?utm_source=terraform_io&utm_content=terraform_io_hero) code to create and manage:
* [EKS Cluster](https://docs.aws.amazon.com/eks/latest/userguide/what-is-eks.html)
* Jenkins pipeline do build and deploy app resources

## Prerequisites  and recommendations :heavy_check_mark:
1. Dedicated IAM Role to be used by Terraform with sufficient permissions to create and manage resources on AWS. :cop:
2. Create a [S3](https://aws.amazon.com/s3/) bucket for Terraform remote backend. See more information about Terraform's [backend](https://www.terraform.io/docs/language/settings/backends/index.html) and [Security Best Practices for Amazon S3](https://docs.aws.amazon.com/AmazonS3/latest/userguide/security-best-practices.html) :floppy_disk:
3. Take note about all the cloud *resources and costs* this project will create and increase into your AWS billing. :moneybag:
 
