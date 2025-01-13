#!/bin/bash

# Including the utils file
source `dirname $0`/inc/utils.sh

# Fetch the current branch
CURRENT_BRANCH=$(git symbolic-ref --short HEAD)

# Check if the current branch is a hotfix branch
if [[ $CURRENT_BRANCH != hotfix/* ]]; then
  echo "Error : Current branch ('$CURRENT_BRANCH') is not a hotfix branch."
  exit 1
fi

HOTFIX_BRANCH=$CURRENT_BRANCH
DEVELOP_BRANCH="develop"

echo "Hotfix branch detected: $HOTFIX_BRANCH"

# Fetch the branch version
HOTFIX_VERSION=${HOTFIX_BRANCH#hotfix/}

# Check if HOTFIX_VERSION is valid
if ! validate_version "$HOTFIX_VERSION"; then
    echo "The detected version ($HOTFIX_VERSION) is not valid."
    read -p "Please enter a valid version (X.Y.Z format) : " HOTFIX_VERSION
    while ! validate_version "$HOTFIX_VERSION"; do
        echo "Invalid version format. Try again."
        read -p "Please enter a valid version (X.Y.Z format) : " HOTFIX_VERSION
    done
fi

echo "Valid version detected: $HOTFIX_VERSION"

# Include main branch detection file
source `dirname $0`/inc/detect-main-branch.sh

# Check repository status
if ! git diff-index --quiet HEAD --; then
  echo "Error : You have uncommitted changes in your repository."
  exit 1
fi

# Check if main and develop branches exist
for branch in $MAIN_BRANCH $DEVELOP_BRANCH; do
  if ! git show-ref --verify --quiet refs/heads/$branch; then
    echo "Error : Branch '$branch' does not exist."
    exit 1
  fi
done

echo "Starting finalization of hotfix: $HOTFIX_BRANCH"

# Switch to main branch
git checkout $MAIN_BRANCH
if [ $? -ne 0 ]; then
  echo "Error : Could not switch to branch '$MAIN_BRANCH'."
  exit 1
fi

# Merge hotfix branch into main
git merge --no-ff $HOTFIX_BRANCH -m "Merge hotfix '$HOTFIX_BRANCH' into $MAIN_BRANCH"
if [ $? -ne 0 ]; then
  echo "Error : Merge on '$MAIN_BRANCH' failed."
  exit 1
fi

# Tag the version
git tag -a "$HOTFIX_VERSION" -m "Version $HOTFIX_VERSION"
if [ $? -ne 0 ]; then
  echo "Error : Failed to create tag."
  exit 1
fi

# Switch to develop branch
git checkout $DEVELOP_BRANCH
if [ $? -ne 0 ]; then
  echo "Error : Failed to switch to branch '$DEVELOP_BRANCH'."
  exit 1
fi

# Merge hotfix branch into develop
git merge --no-ff $HOTFIX_BRANCH -m "Merge hotfix '$HOTFIX_BRANCH' into $DEVELOP_BRANCH"
if [ $? -ne 0 ]; then
  echo "Error : Merge on '$DEVELOP_BRANCH' failed."
  exit 1
fi

# Delete hotfix branch
git branch -d $HOTFIX_BRANCH
if [ $? -ne 0 ]; then
  echo "Error : Could not delete branch '$HOTFIX_BRANCH'."
  exit 1
fi

# Push changes to remote
git push origin $MAIN_BRANCH $DEVELOP_BRANCH --tags
if [ $? -ne 0 ]; then
  echo "Error : Could not push changes to remote repository."
  exit 1
fi

echo "Hotfix '$HOTFIX_BRANCH' completed successfully!"