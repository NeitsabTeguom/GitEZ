#!/bin/bash

# Checks that a release name is passed as a parameter
if [ -z "$1" ]; then
  echo "Usage : $0 <release-name>"
  exit 1
fi

RELEASE_NAME=$1
DEVELOP_BRANCH="develop"
RELEASE_BRANCH="release/$RELEASE_NAME"

# Check if the develop branch exists
if ! git show-ref --verify --quiet refs/heads/$DEVELOP_BRANCH; then
  echo "Error : Branch '$DEVELOP_BRANCH' does not exist."
  exit 1
fi

# Check if the release branch already exists
if git show-ref --verify --quiet refs/heads/$RELEASE_BRANCH; then
  echo "Error : Branch '$RELEASE_BRANCH' already exists."
  exit 1
fi

echo "Start creating the release : $RELEASE_BRANCH"

# Switch to the develop branch
git checkout $DEVELOP_BRANCH
if [ $? -ne 0 ]; then
  echo "Error : Unable to switch to branch '$DEVELOP_BRANCH'."
  exit 1
fi

#Update the develop branch (optional but recommended)
git pull origin $DEVELOP_BRANCH
if [ $? -ne 0 ]; then
  echo "Error : Unable to update branch '$DEVELOP_BRANCH'."
  exit 1
fi

# Create the release branch
git checkout -b $RELEASE_BRANCH
if [ $? -ne 0 ]; then
  echo "Error : Unable to create branch '$RELEASE_BRANCH'."
  exit 1
fi

# Push the branch away
git push -u origin $RELEASE_BRANCH
if [ $? -ne 0 ]; then
  echo "Error : Unable to push branch '$RELEASE_BRANCH' to remote repository."
  exit 1
fi

echo "Release '$RELEASE_BRANCH' created successfully!"
