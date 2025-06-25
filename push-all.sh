#!/bin/bash

# Check for a commit message
if [ -z "$1" ]; then
  echo "Usage : $0 <commit message>"
  exit 1
fi

COMMIT_MESSAGE="$1"

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

# todo : push stream origin
echo "Pushing changes to remote repository..."
git push

if [ $? -ne 0 ]; then
  echo "Error: Unable to push changes."
  exit 1
fi

echo "Changes pushed successfully!"
