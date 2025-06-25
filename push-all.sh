#!/bin/bash

# Check for a commit message
if [ -z "$1" ]; then
  echo "Usage : $0 <commit message>"
  exit 1
fi

COMMIT_MESSAGE="$1"

# Including the utils file
source `dirname $0`/inc/utils.sh

# Fetch the current branch
CURRENT_BRANCH=$(git symbolic-ref --short HEAD)
echo "Current branch : $CURRENT_BRANCH"

echo "Adding all changed files to tracker..."
git add .

# Check for anything to commit
if git diff --cached --quiet; then
  echo "No changes to commit."
  exit 0
fi

echo "Creating commit with message : '$COMMIT_MESSAGE'"
git commit -m "$COMMIT_MESSAGE"

if [ $? -ne 0 ]; then
  echo "Error: Could not create commit."
  exit 1
fi

# Vérifie si la branche a un suivi distant
if ! git rev-parse --abbrev-ref --symbolic-full-name @{u} > /dev/null 2>&1; then
    echo "Pushing changes with origin to remote repository..."
    git push --set-upstream origin "$CURRENT_BRANCH"
else
    echo "Pushing changes to remote repository..."
    git push
fi

if [ $? -ne 0 ]; then
  echo "Error: Unable to push changes."
  exit 1
fi

echo "Changes pushed successfully!"
