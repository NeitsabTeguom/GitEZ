#!/bin/bash

# Function to detect and commit the main branch
MAIN_BRANCH=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')

# Checks that the main branch is "main" or "master"
if [[ "$MAIN_BRANCH" != "main" && "$MAIN_BRANCH" != "master" ]]; then
 echo "Error: Detected main branch is '$MAIN_BRANCH', but it should be 'main' or 'master'."
 exit 1
fi

# At this point, MAIN_BRANCH is already defined and committed
echo "Detected and committed main branch : $MAIN_BRANCH"