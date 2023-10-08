.PHONY: build deploy-infra list-output deploy-site sync-bucket teardown all empty-bucket destroy

Bucket_Name = tf-ohary-bucket-f360341c-994e-4bc0-bb9e-822df87902dc

init:
	terraform init

validate:
	terraform validate

plan:
	terraform plan

apply:
	terraform apply --auto-approve

import:
	terraform import module.terrahouse_aws.aws_s3_bucket.website_bucket $(Bucket_Name)
	terraform import module.terrahouse_aws.aws_cloudfront_distribution.s3_distribution E13LPCVCVYWOE3
	terraform import module.terrahouse_aws.aws_cloudfront_origin_access_control.default E26TXKXYE54LJ9

list-output:
	terraform output --output json > ./src/frontend/output.json

sync-bucket:
	aws s3 sync ./public s3://$(Bucket_Name)

deploy-site: list-output sync-bucket

empty-bucket:
	aws s3 rm s3://$(Bucket_Name) --recursive

destroy:
	terraform destroy --auto-approve

teardown: empty-bucket destroy

all: build deploy-infra deploy-site

redo-allover: teardown all