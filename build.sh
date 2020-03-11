#!/bin/bash
set -e

if [[ $VER == "SNAPSHOT" ]]; then
  echo "Version can't contain SNAPSHOT: $VER"
  exit 1
fi

echo "Building cder..."
go build
echo "Logging in to dockerhub"
set
echo ${DOCKER_USERNAME}, ${DOCKER_PASSWORD}, ${VER}
docker login --username "${DOCKER_USERNAME}" --password "${DOCKER_PASSWORD}"
echo "Creating docker images..."
docker build -t "${DOCKER_USERNAME}"/cdernode:v"${VER}" -f ./node/Dockerfile .
docker build -t "${DOCKER_USERNAME}"/cder:v"${VER}" -f ./go/Dockerfile .
echo "Pushing images..."
#docker push "${DOCKER_USERNAME}"/cdernode:v"$VER"
#docker push "${DOCKER_USERNAME}"/cder:v"$VER"
#echo 'Changing ver in compose file'
#sed -i "s/\(cdernode:\)\(.*\)/\$VER/" ./node/docker-compose.yml



