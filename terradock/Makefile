VERSIONS_FILE_PATH := VERSIONS.txt

push:
	@while IFS=, read -r terraform terragrunt; do \
		if [[ $$terraform != "Terraform" ]]; then \
			docker build --build-arg terraform=$$terraform --build-arg terragrunt=$$terragrunt -t jimfawkes/terradock:tf_$$terraform-tg_$$terragrunt .; \
			docker push jimfawkes/terradock:tf_$$terraform-tg_$$terragrunt; \
		fi \
	done <"${VERSIONS_FILE_PATH}" \

