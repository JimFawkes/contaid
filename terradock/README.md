[![dockerhub](https://img.shields.io/badge/dockerhub-jimfawkes%2Fterradock-blue)](https://hub.docker.com/r/jimfawkes/terradock)
[![dockerhub-pulls](https://img.shields.io/docker/pulls/jimfawkes/terradock)](https://hub.docker.com/r/jimfawkes/terradock)

# Terradock
Terragrunt containerized to easily switch between versions

This is influenced by: [alpine-docker/terragrunt](https://github.com/alpine-docker/terragrunt)

## Versions
There are multiple version combinations pushed to DockerHub.
The different combinations can be found [here](./Versions.txt).
The tags follow this pattern: `tf_<terraform_version>-tg_<terragrunt_version>`

***Note:** If you need a different combination of versions, open a PR or Issue.*


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
	docker run -v $(pwd):/apps -it --env-file <(aws-vault exec $aws_profile -- env | grep ^AWS_) jimfawkes/terradock:tf_$terraform-tg_$terragrunt ${@:2}
}
```
This uses [aws-vault](https://github.com/99designs/aws-vault) to authenticate with aws.
