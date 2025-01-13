#!/bin/bash

# Fetch the current branch
current_branch=$(git symbolic-ref --short HEAD)

# Function to detect branch type
detect_branch_type() {
    case "$current_branch" in
        hotfix/*)
            echo "hotfix"
            ;;
        bugfix/*)
            echo "bugfix"
            ;;
        feature/*)
            echo "feature"
            ;;
        release/*)
            echo "release"
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

# Detect branch type
branch_type=$(detect_branch_type)

# Check if branch type is valid
if [ "$branch_type" == "unknown" ]; then
    echo "Error : Branch '$current_branch' does not match a known type (hotfix, bugfix, feature, release)."
    exit 1
fi

# Call the corresponding script
echo "Branch detected : $current_branch ($branch_type)"
case "$branch_type" in
    hotfix)
        echo "Running hotfix-finish.sh..."
        `dirname $0`/hotfix-finish.sh
        ;;
    bugfix)
        echo "Running bugfix-finish.sh..."
        `dirname $0`/bugfix-finish.sh
        ;;
    feature)
        echo "Running feature-finish.sh..."
        `dirname $0`/feature-finish.sh
        ;;
    release)
        echo "Running release-finish.sh..."
        `dirname $0`/release-finish.sh
        ;;
    *)
        echo "Unexpected error."
        exit 1
        ;;
esac