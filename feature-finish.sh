#!/bin/bash

# Get the current branch
CURRENT_BRANCH=$(git symbolic-ref --short HEAD)

# Check if the current branch is a feature branch
if [[ $CURRENT_BRANCH != feature/* ]]; then
  echo "Error : The current branch ('$CURRENT_BRANCH') is not a feature branch."
  exit 1
fi

FEATURE_BRANCH=$CURRENT_BRANCH
DEVELOP_BRANCH="develop"

echo "Feature branch detected : $FEATURE_BRANCH"

# Check the repository status
if ! git diff-index --quiet HEAD --; then
  echo "Error : You have uncommitted changes in your repository."
  exit 1
fi

# Check if the develop branch exists
if ! git show-ref --verify --quiet refs/heads/$DEVELOP_BRANCH; then
  echo "Error : Branch '$DEVELOP_BRANCH' does not exist."
  exit 1
fi

echo "Starting finalization of feature : $FEATURE_BRANCH"

# Switch to develop branch
git checkout $DEVELOP_BRANCH
if [ $? -ne 0 ]; then
  echo "Error : Failed to switch to branch '$DEVELOP_BRANCH'."
  exit 1
fi

# Merge feature branch into develop
git merge --no-ff $FEATURE_BRANCH -m "Merge feature '$FEATURE_BRANCH' into $DEVELOP_BRANCH"
if [ $? -ne 0 ]; then
  echo "Error : Merge on '$DEVELOP_BRANCH' failed."
  exit 1
fi

# Delete feature branch
git branch -d $FEATURE_BRANCH
if [ $? -ne 0 ]; then
  echo "Error : Could not delete branch '$FEATURE_BRANCH'."
  exit 1
fi

# Push changes to remote
git push origin $DEVELOP_BRANCH
if [ $? -ne 0 ]; then
  echo "Error : Could not push changes to remote repository."
  exit 1
fi

echo "Feature '$FEATURE_BRANCH' completed successfully!"
