#!/bin/bash

# Get the current branch
CURRENT_BRANCH=$(git symbolic-ref --short HEAD)

# Check if you are on a `bugfix` branch
if [[ ! "$CURRENT_BRANCH" =~ ^bugfix/ ]]; then
  echo "Error : Current branch '$CURRENT_BRANCH' is not a branch of type 'bugfix/'."
  exit 1
fi

DEVELOP_BRANCH="develop"

# Check if the develop branch exists
if ! git show-ref --verify --quiet refs/heads/$DEVELOP_BRANCH; then
  echo "Error : Branch '$DEVELOP_BRANCH' does not exist."
  exit 1
fi

# Include main branch detection file
source `dirname $0`/inc/detect-main-branch.sh

echo "Preparing to finalize bugfix: $CURRENT_BRANCH"

# Switch to develop to merge
git checkout $DEVELOP_BRANCH
if [ $? -ne 0 ]; then
  echo "Error : Unable to switch to branch '$DEVELOP_BRANCH'."
  exit 1
fi

# Update develop with latest remote changes
git pull origin $DEVELOP_BRANCH
if [ $? -ne 0 ]; then
  echo "Error : Unable to update branch '$DEVELOP_BRANCH'."
  exit 1
fi

# Merge bugfix branch into develop
git merge --no-ff $CURRENT_BRANCH -m "Merge bugfix: $CURRENT_BRANCH into $DEVELOP_BRANCH"
if [ $? -ne 0 ]; then
  echo "Error : Could not merge branch '$CURRENT_BRANCH' into '$DEVELOP_BRANCH'."
  exit 1
fi

# Push changes from develop
git push origin $DEVELOP_BRANCH
if [ $? -ne 0 ]; then
  echo "Error : Could not push changes from '$DEVELOP_BRANCH' to remote repository."
  exit 1
fi

# Switch to main/master
git checkout $MAIN_BRANCH
if [ $? -ne 0 ]; then
  echo "Error : Unable to switch to branch '$MAIN_BRANCH'."
  exit 1
fi

# Update the main branch with the latest remote changes
git pull origin $MAIN_BRANCH
if [ $? -ne 0 ]; then
  echo "Error : Unable to update branch '$MAIN_BRANCH'."
  exit 1
fi

# Merge the bugfix branch into the main branch
git merge --no-ff $CURRENT_BRANCH -m "Merge bugfix: $CURRENT_BRANCH into $MAIN_BRANCH"
if [ $? -ne 0 ]; then
  echo "Error : Unable to merge branch '$CURRENT_BRANCH' into '$MAIN_BRANCH'."
  exit 1
fi

# Push the changes to the main branch
git push origin $MAIN_BRANCH
if [ $? -ne 0 ]; then
  echo "Error : Unable to push changes from '$MAIN_BRANCH' to remote repository."
  exit 1
fi

# Delete local branch bugfix
git branch -d $CURRENT_BRANCH
if [ $? -ne 0 ]; then
  echo "Error : Unable to delete local branch '$CURRENT_BRANCH'."
  exit 1
fi

# Delete remote branch bugfix
git push origin --delete $CURRENT_BRANCH
if [ $? -ne 0 ]; then
  echo "Error : Unable to delete remote branch '$CURRENT_BRANCH'."
  exit 1
fi

echo "Bugfix '$CURRENT_BRANCH' successfully finalized, integrated into '$DEVELOP_BRANCH' and '$MAIN_BRANCH'."