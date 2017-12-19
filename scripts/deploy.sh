#!/usr/bin/env sh

CURRENCY=$1
GITHUB_CLIENT_ID=$2
GITHUB_CLIENT_SECRET=$3
CONTAINER_NAME="$CURRENCY-universal-pool-list"
VIRTUAL_HOST="$CURRENCY-pools.morin.io,$CURRENCY-pools.containers"
VIRTUAL_PORT=8888
LETSENCRYPT_HOST="$CURRENCY-pools.morin.io"
LETSENCRYPT_EMAIL="$CURRENCY-pools@morin.io"
BASE_URL="https://$LETSENCRYPT_HOST"

echo "deploying $CONTAINER_NAME"
echo "CURRENCY: $CURRENCY"
echo "GITHUB_CLIENT_ID: $GITHUB_CLIENT_ID"
echo "VIRTUAL_HOST: $VIRTUAL_HOST"
echo "VIRTUAL_PORT: $VIRTUAL_PORT"
echo "LETSENCRYPT_HOST: $LETSENCRYPT_HOST"
echo "LETSENCRYPT_EMAIL: $LETSENCRYPT_EMAIL"
echo "CONTAINER_NAME: $CONTAINER_NAME"

docker build --rm -t ${CONTAINER_NAME} .
docker rm -f ${CONTAINER_NAME}
docker run -d --network=containers --restart always --name ${CONTAINER_NAME} \
    -e CURRENCY=${CURRENCY} \
    -e ENV_NAME=${CONTAINER_NAME} \
    -e VIRTUAL_HOST=${VIRTUAL_HOST} \
    -e VIRTUAL_PORT=8888 \
    -e LETSENCRYPT_HOST=${LETSENCRYPT_HOST} \
    -e LETSENCRYPT_EMAIL=${LETSENCRYPT_EMAIL} \
    -e GITHUB_CLIENT_ID=${GITHUB_CLIENT_ID} \
    -e GITHUB_CLIENT_SECRET=${GITHUB_CLIENT_SECRET} \
    -e BASE_URL=${BASE_URL} \
    ${CONTAINER_NAME}
