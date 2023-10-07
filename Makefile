.PHONY: build deploy-infra list-output deploy-site sync-bucket teardown all empty-bucket kill-stack

init:
	terraform init

validate:
	terraform validate

plan:
	terraform plan

apply:
	terraform apply --auto-approve

import:
	terraform import module.terrahouse_aws.aws_s3_bucket.website_bucket tf-ohary-bucket-f360341c-994e-4bc0-bb9e-822df87902dc
	terraform import module.terrahouse_aws.aws_cloudfront_distribution.s3_distribution E13LPCVCVYWOE3
	terraform import module.terrahouse_aws.aws_cloudfront_origin_access_control.default E26TXKXYE54LJ9

list-output:
	terraform output --output json > ./src/frontend/output.json

sync-bucket:
	aws s3 sync ./src/frontend s3://cv.ohary37.com

deploy-site: list-output sync-bucket

invoke-local:
	sam build && sam local invoke countFunction

invoke-remote:
	sam build && sam remote invoke countFunction

empty-bucket:
	aws s3 rm s3://cv.ohary37.com --recursive

kill-stack:
	terraform delete --auto-approve

teardown: empty-bucket kill-stack

all: build deploy-infra deploy-site

redo-allover: teardown all