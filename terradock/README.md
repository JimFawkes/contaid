[![dockerhub](https://img.shields.io/badge/dockerhub-jimfawkes%2Fterradock-blue)](https://hub.docker.com/r/jimfawkes/terradock)
[![dockerhub-pulls](https://img.shields.io/docker/pulls/jimfawkes/terradock)](https://hub.docker.com/r/jimfawkes/terradock)

# Terradock
Terragrunt containerized to easily switch between versions

This is influenced by: [alpine-docker/terragrunt](https://github.com/alpine-docker/terragrunt)

## Versions
There are multiple version combinations pushed to DockerHub.
The different combinations can be found [here](./VERSIONS.txt).
The tags follow this pattern: `tf_<terraform_version>-tg_<terragrunt_version>`

***Note:** If you need a different combination of versions, open a PR or an Issue.*

## Usage
Terragrunt needs read & write access to your local terragrunt directory. To achieve this,
we need to mount the local dir as a volume on the containers `/apps` dir.
```bash
docker run -v /your/local/path:/apps -it terradock:<relevant_tag> --help
```

I usually run this from within my local terragrunt dir and therefore do the following:
```bash
docker run -v $(pwd):/apps -it terradock:tf_0.13.1-tg_v0.21.13 plan --terragrunt-working-dir some/relative/path
```

I aliased the following function I wrote:
```bash
# In ~/.aliases or where you define your aliases
alias tg='terradock $@'

function terradock () {
	terraform=${TERRAFORM_VERSION:-<default_version>}
	terragrunt=${TERRAGRUNT_VERSION:-<default_version>}
	aws_profile=${1:-<default_profile>}
	echo "terraform: $terraform, terragrunt: $terragrunt, aws-profile=$aws_profile"
	docker run -v $(pwd):/apps -it --env-file <(aws-vault exec $aws_profile -- env | grep ^AWS_) jimfawkes/terradock:tf_$terraform-tg_$terragrunt ${@:2}
}

# Use as follows
tg some-aws-profile plan --terragrunt-working-dir some/path/to/hcl
```
**Notes:**
 - This uses [aws-vault](https://github.com/99designs/aws-vault) to authenticate with aws.
 - In the current form it always requires a profile due to `${@:2}`
 - This assumes the current working dir to be your terraform dir (IAC Repo)
 - If you are working on multiple IAC repos that require different versions, you could use [direnv](https://github.com/direnv/direnv) to always use the correct versions per repo.
