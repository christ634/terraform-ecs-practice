#!/usr/bin/env bash
set -euo pipefail

REGION="${AWS_REGION:-us-east-1}"
ECR_REPO_URL="${1:?Uso: $0 <ECR_REPOSITORY_URL> [TAG]}"
TAG="${2:-latest}"

REGISTRY="${ECR_REPO_URL%%/*}"

echo ">> Login a ECR ($REGION)"
aws ecr get-login-password --region "$REGION" \
  | docker login --username AWS --password-stdin "$REGISTRY"

echo ">> Build de la imagen"
docker build -t "$ECR_REPO_URL:$TAG" ./app

echo ">> Push de la imagen"
docker push "$ECR_REPO_URL:$TAG"

echo ">> Listo: $ECR_REPO_URL:$TAG"