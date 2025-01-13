#!/bin/bash

# Fonction pour valider un format de version
validate_version() {
    local version=$1
    if [[ $version =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        return 0 # La version est valide
    else
        return 1 # La version est invalide
    fi
}