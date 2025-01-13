#!/bin/bash

# Check that a bugfix name is passed as a parameter
if [ -z "$1" ]; then
  echo "Usage : $0 <bugfix-name>"
  exit 1
fi

BUGFIX_NAME=$1
DEVELOP_BRANCH="develop"
BUGFIX_BRANCH="bugfix/$BUGFIX_NAME"

# Check if the develop branch exists
if ! git show-ref --verify --quiet refs/heads/$DEVELOP_BRANCH; then
  echo "Error : Branch '$DEVELOP_BRANCH' does not exist."
  exit 1
fi

# Check if the bugfix branch already exists
if git show-ref --verify --quiet refs/heads/$BUGFIX_BRANCH; then
  echo "Error : Branch '$BUGFIX_BRANCH' already exists."
  exit 1
fi

echo "Start creating bugfix: $BUGFIX_BRANCH"

# Switch to develop branch
git checkout $DEVELOP_BRANCH
if [ $? -ne 0 ]; then
  echo "Error : Could not switch to branch '$DEVELOP_BRANCH'."
  exit 1
fi

# Update develop branch
git pull origin $DEVELOP_BRANCH
if [ $? -ne 0 ]; then
  echo "Error : Could not update branch '$DEVELOP_BRANCH'."
  exit 1
fi

# Create bugfix branch
git checkout -b $BUGFIX_BRANCH
if [ $? -ne 0 ]; then
  echo "Error : Could not create branch '$BUGFIX_BRANCH'."
  exit 1
fi

# Push the branch to remote
git push -u origin $BUGFIX_BRANCH
if [ $? -ne 0 ]; then
  echo "Error : Could not push branch '$BUGFIX_BRANCH' to remote repository."
  exit 1
fi

echo "Bugfix '$BUGFIX_BRANCH' created successfully!"
