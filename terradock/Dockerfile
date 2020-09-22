ARG terraform
FROM hashicorp/terraform:$terraform

ARG terraform
ARG terragrunt
ENV TERRAFORM=$terraform
ENV TERRAGRUNT=$terragrunt

RUN apk add --update --no-cache bash git openssh

ADD https://github.com/gruntwork-io/terragrunt/releases/download/${TERRAGRUNT}/terragrunt_linux_amd64 /usr/local/bin/terragrunt
RUN chmod +x /usr/local/bin/terragrunt

RUN echo "terraform: ${TERRAFORM}"
RUN echo "terragrunt: ${TERRAGRUNT}"

WORKDIR /apps

ENTRYPOINT ["terragrunt"]
CMD ["plan"]
