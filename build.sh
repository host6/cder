#!/bin/bash
set -e

if [[ ${VER} == *"SNAPSHOT"* ]]; then
  echo "Version can't contain SNAPSHOT: ${VER}"
  exit 1
fi

function docker_tag_exists() {
    curl --silent -f -lSL https://index.docker.io/v1/repositories/$1/tags/$2 > /dev/null
}

echo "Building cder..."
go build
echo "Logging in to dockerhub"
docker login --username "${DOCKER_USERNAME}" --password "${DOCKER_PASSWORD}"
echo "Checking dockerhub images existance"
if docker_tag_exists "${DOCKER_USERNAME}"/cdernode v"${VER}"; then
    echo "${DOCKER_USERNAME}"/cdernode v"${VER}" already exists on dockerhub. Version is not bumped?
    exit 1
fi
if docker_tag_exists "${DOCKER_USERNAME}"/cder v"${VER}"; then
    echo "${DOCKER_USERNAME}"/cder v"${VER}" already exists on dockerhub. Version is not bumped?
    exit 1
fi    
echo "Creating docker images..."
docker build -t "${DOCKER_USERNAME}"/cdernode:v"${VER}" -f ./node/Dockerfile .
docker build -t "${DOCKER_USERNAME}"/cder:v"${VER}" -f ./go/Dockerfile .
echo "Pushing images..."
#docker push "${DOCKER_USERNAME}"/cdernode:v"${VER}"
#docker push "${DOCKER_USERNAME}"/cder:v"${VER}"
#echo 'Changing ver in compose file'
#sed -i "s/\(cdernode:\)\(.*\)/\${VER}/" ./node/docker-compose.yml
