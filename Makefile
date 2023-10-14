.PHONY: init deploy apply list-output deploy-site sync-bucket teardown all empty-bucket delete

Bucket_Name = terraform-20231013232020640000000001

init:
	terraform init

validate:
	terraform validate

plan:
	terraform plan

apply:
	terraform apply --auto-approve

deploy: init apply

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

delete:
	terraform destroy --auto-approve

destroy: empty-bucket delete

all: build deploy-infra deploy-site

redo-allover: teardown all