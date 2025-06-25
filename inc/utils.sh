#!/bin/bash

# Function to validate a version format
validate_version() {
    local version=$1
    if [[ $version =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        return 0 # The version is valid
    else
        return 1 # The version is invalid
    fi
}