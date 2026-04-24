#!/bin/bash

# Define the base directory for Kubernetes manifests
BASE_DIR="k8s-manifests"

# Function to apply manifests with validation
apply_manifests() {
  local dir=$1
  echo "Applying manifests in $dir"
  for file in $(find $dir -type f -name "*.yaml" -o -name "*.yml"); do
    echo "Validating $file"
    kubectl apply --dry-run=client -f $file
    if [ $? -eq 0 ]; then
      echo "Applying $file"
      kubectl apply -f $file
    else
      echo "Validation failed for $file"
      exit 1
    fi
  done
}

# Apply all manifests in the base directory and its subdirectories
for dir in $(find $BASE_DIR -type d); do
  if [ "$dir" != "$BASE_DIR" ]; then
    apply_manifests $dir
  fi
done
