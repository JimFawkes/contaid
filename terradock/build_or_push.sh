#!/bin/bash

VERSIONS_FILE_PATH=VERSIONS.txt
VERSIONS=$(awk 'NR>1' $VERSIONS_FILE_PATH)
IMAGE_NAME=jimfawkes/terradock

build () {
	image_tags=()
    while IFS=, read -r terraform terragrunt; do
    	tag=tf_$terraform-tg_$terragrunt
        docker build --build-arg terraform=$terraform --build-arg terragrunt=$terragrunt -t $IMAGE_NAME:$tag .
		image_tags+=( "$tag" )
    done <<<"$VERSIONS"
    export IMAGE_TAGS=${image_tags[@]}
}

push () {
	for tag in ${IMAGE_TAGS}; do
    	docker push $IMAGE_NAME:${tag}
	done
}

echo "Build and Push terradock images"

if [[ "$1" == "build" ]]; then
	build
elif [[ "$1" == "push" ]]; then
	push
fi
