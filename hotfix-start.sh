#!/bin/bash

# Check that a hotfix name is passed as a parameter
if [ -z "$1" ]; then
  echo "Usage : $0 <hotfix-name>"
  exit 1
fi

HOTFIX_NAME=$1
HOTFIX_BRANCH="hotfix/$HOTFIX_NAME"

# Include the main branch detection file
source `dirname $0`/inc/detect-main-branch.sh

# Check if the main branch exists
if ! git show-ref --verify --quiet refs/heads/$MAIN_BRANCH; then
  echo "Error : Branch '$MAIN_BRANCH' does not exist."
  exit 1
fi

# Check if the hotfix branch already exists
if git show-ref --verify --quiet refs/heads/$HOTFIX_BRANCH; then
  echo "Error : Branch '$HOTFIX_BRANCH' already exists."
  exit 1
fi

echo "Start creating hotfix : $HOTFIX_BRANCH"

# Switch to main branch
git checkout $MAIN_BRANCH
if [ $? -ne 0 ]; then
  echo "Error : Could not switch to branch '$MAIN_BRANCH'."
  exit 1
fi

# Update main branch (optional but recommended)
git pull origin $MAIN_BRANCH
if [ $? -ne 0 ]; then
  echo "Error : Could not update branch '$MAIN_BRANCH'."
  exit 1
fi

# Create hotfix branch
git checkout -b $HOTFIX_BRANCH
if [ $? -ne 0 ]; then
  echo "Error : Unable to create branch '$HOTFIX_BRANCH'."
  exit 1
fi

# Push the branch to remote
git push -u origin $HOTFIX_BRANCH
if [ $? -ne 0 ]; then
  echo "Error : Unable to push branch '$HOTFIX_BRANCH' to remote repository."
  exit 1
fi

echo "Hotfix '$HOTFIX_BRANCH' created successfully!"
