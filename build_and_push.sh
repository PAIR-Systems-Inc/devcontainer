#!/bin/bash

set -e

# === CONFIG ===
IMAGE_NAME="ghcr.io/mariamahmad8/goodmem-container"
TEMPLATE_PATH="src/goodmem-dev"
DOCKERFILE_PATH="build/Dockerfile"

# === INPUT ===
if [ -z "$1" ]; then
  echo "Usage: ./build_and_push.sh <image_version>"
  exit 1
fi

VERSION="$1"
TEMPLATE_VERSION="$VERSION"

echo "Building image: $IMAGE_NAME:$VERSION"

# === STEP 1: Build image ===
docker build -t "$IMAGE_NAME:$VERSION" -f "$DOCKERFILE_PATH" .

# === STEP 2: Tag and push ===
docker push "$IMAGE_NAME:$VERSION"

read -p "Also tag and push as 'latest'? [y/N]: " confirm
if [[ "$confirm" =~ ^[Yy]$ ]]; then
  docker tag "$IMAGE_NAME:$VERSION" "$IMAGE_NAME:latest"
  docker push "$IMAGE_NAME:latest"
fi

# === STEP 3: Update devcontainer-template.json version ===
TEMPLATE_FILE="$TEMPLATE_PATH/devcontainer-template.json"

echo " Updating template version in $TEMPLATE_FILE"
jq ".version = \"$TEMPLATE_VERSION\"" "$TEMPLATE_FILE" > tmp.json && mv tmp.json "$TEMPLATE_FILE"

# === STEP 4: Publish template ===
echo "Publishing DevContainer template..."
devcontainer templates publish "$TEMPLATE_PATH" \
  --namespace mariamahmad8/templates \
  --registry ghcr.io

echo "Done: published image $IMAGE_NAME:$VERSION and template version $TEMPLATE_VERSION"
