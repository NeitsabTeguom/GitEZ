#!/bin/bash

# Including the utils file
source `dirname $0`/inc/utils.sh

# Fetch the current branch
CURRENT_BRANCH=$(git symbolic-ref --short HEAD)

# Checks if the current branch is a release branch
if [[ $CURRENT_BRANCH != release/* ]]; then
  echo "Error : The current branch ('$CURRENT_BRANCH') is not a release branch."
  exit 1
fi

RELEASE_BRANCH=$CURRENT_BRANCH
DEVELOP_BRANCH="develop"

echo "Release branch detection : $RELEASE_BRANCH"

# Pull the version from the branch
RELEASE_VERSION=${RELEASE_BRANCH#release/}

# Check if RELEASE_VERSION is valid
if ! validate_version "$RELEASE_VERSION"; then
    echo "The detected version ($RELEASE_VERSION) is not valid."
    read -p "Please enter a valid version (X.Y.Z format) : " RELEASE_VERSION
    while ! validate_version "$RELEASE_VERSION"; do
        echo "Format de version invalide. Essayez à nouveau."
        read -p "Please enter a valid version (X.Y.Z format) : " RELEASE_VERSION
    done
fi

echo "Valid version detected : $RELEASE_VERSION"

# Including the main branch detection file
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

echo "Begin finalizing release : $RELEASE_BRANCH"

# Switch to main branch
git checkout $MAIN_BRANCH
if [ $? -ne 0 ]; then
  echo "Error : Unable to switch to branch '$MAIN_BRANCH'."
  exit 1
fi

# Merge release branch into main
git merge --no-ff $RELEASE_BRANCH -m "Merge release '$RELEASE_BRANCH' into $MAIN_BRANCH"
if [ $? -ne 0 ]; then
  echo "Error : Merge on '$MAIN_BRANCH' failed."
  exit 1
fi

# Check if tag exists
if git rev-parse "$RELEASE_VERSION" >/dev/null 2>&1; then
  echo "Tag $RELEASE_VERSION exists, deleting..."
  git tag -d "$RELEASE_VERSION"
  git push origin --delete "$RELEASE_VERSION"
fi

# Tag the version
git tag -a "$RELEASE_VERSION" -m "Release version $RELEASE_VERSION"
if [ $? -ne 0 ]; then
  echo "Error : Unable to create tag."
  exit 1
fi

# Switch to develop branch
git checkout $DEVELOP_BRANCH
if [ $? -ne 0 ]; then
  echo "Error : Unable to switch to branch '$DEVELOP_BRANCH'."
  exit 1
fi

# Merge release branch into develop
git merge --no-ff $RELEASE_BRANCH -m "Merge release '$RELEASE_BRANCH' into $DEVELOP_BRANCH"
if [ $? -ne 0 ]; then
  echo "Error : Merge on '$DEVELOP_BRANCH' failed."
  exit 1
fi

# Delete release branch
git branch -d $RELEASE_BRANCH
if [ $? -ne 0 ]; then
  echo "Error : Could not delete branch '$RELEASE_BRANCH'."
  exit 1
fi

# Push changes to remote
git push origin $MAIN_BRANCH $DEVELOP_BRANCH --tags
if [ $? -ne 0 ]; then
  echo "Error : Could not push changes to remote repository."
  exit 1
fi

echo "Release '$RELEASE_BRANCH' completed successfully!"
