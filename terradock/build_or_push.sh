#!/bin/bash

VERSIONS_FILE_PATH=VERSIONS.txt
VERSIONS=$(awk 'NR>1' $VERSIONS_FILE_PATH)
IMAGE_NAME=jimfawkes/terradock

build () {
	echo "Build images for every version tuple in $VERSIONS_FILE_PATH"
	image_tags=()
    while IFS=, read -r terraform terragrunt; do
    	tag=tf_$terraform-tg_$terragrunt
        docker build --build-arg terraform=$terraform --build-arg terragrunt=$terragrunt -t $IMAGE_NAME:$tag .
		image_tags+=( "$tag" )
    done <<<"$VERSIONS"
    export IMAGE_TAGS=${image_tags[@]}
}

push () {
	echo "Push images for IMAGE_TAGS=$IMAGE_TAGS"
	for tag in ${IMAGE_TAGS}; do
    	docker push $IMAGE_NAME:${tag}
	done
}


if [[ "$1" == "build" ]]; then
	echo "Build images"
	build
elif [[ "$1" == "push" ]]; then
	echo "Push images"
	push
elif [[ "$1" == "build-and-push" ]]; then
	echo "Build and Push terradock images"
	build
	push
fi
