#!/bin/bash

# Check that a feature name is passed as a parameter
if [ -z "$1" ]; then
  echo "Usage : $0 <feature-name>"
  exit 1
fi

FEATURE_NAME=$1
DEVELOP_BRANCH="develop"
FEATURE_BRANCH="feature/$FEATURE_NAME"

# Check if the develop branch exists
if ! git show-ref --verify --quiet refs/heads/$DEVELOP_BRANCH; then
  echo "Error : Branch '$DEVELOP_BRANCH' does not exist."
  exit 1
fi

# Check if the feature branch already exists
if git show-ref --verify --quiet refs/heads/$FEATURE_BRANCH; then
  echo "Error : Branch '$FEATURE_BRANCH' already exists."
  exit 1
fi

echo "Start creating feature: $FEATURE_BRANCH"

# Switch to develop branch
git checkout $DEVELOP_BRANCH
if [ $? -ne 0 ]; then
  echo "Error : Could not switch to branch '$DEVELOP_BRANCH'."
  exit 1
fi

# Update develop branch (optional, but recommended)
git pull origin $DEVELOP_BRANCH
if [ $? -ne 0 ]; then
  echo "Error : Could not update branch '$DEVELOP_BRANCH'."
  exit 1
fi

# Create feature branch
git checkout -b $FEATURE_BRANCH
if [ $? -ne 0 ]; then
  echo "Error: Could not create branch '$FEATURE_BRANCH'."
  exit 1
fi

# Push the branch to remote
git push -u origin $FEATURE_BRANCH
if [ $? -ne 0 ]; then
  echo "Error: Could not push branch '$FEATURE_BRANCH' to remote repository."
  exit 1
fi

echo "Feature '$FEATURE_BRANCH' created successfully!"