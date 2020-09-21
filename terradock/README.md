# Terradock
Terragrunt containerized to easily switch between versions

This is influenced by: [alpine-docker/terragrunt](https://github.com/alpine-docker/terragrunt)

## Usage
```bash
docker run -v $(pwd):/apps -it terradock:<relevant_tag> $@
```

I aliased the following function I wrote as terragrunt:
```bash
function terradock () {
	terraform=${TERRAFORM_VERSION:-<default_version>}
	terragrunt=${TERRAGRUNT_VERSION:-<default_version>}
	aws_profile=${1:-<default_profile>}
	echo "terraform: $terraform, terragrunt: $terragrunt, aws-profile=$aws_profile"
	docker run -v $(pwd):/apps -it --env-file <(aws-vault exec $aws_profile -- env | grep ^AWS_) terradock:tf_$terraform-tg_$terragrunt ${@:2}
}
```
This uses [aws-vault](https://github.com/99designs/aws-vault) to authenticate with aws.
