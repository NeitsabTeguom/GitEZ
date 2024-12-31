#!/bin/bash

# Récupérer la branche actuelle
current_branch=$(git symbolic-ref --short HEAD)

# Fonction pour détecter le type de branche
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

# Détection du type de branche
branch_type=$(detect_branch_type)

# Vérification si le type de branche est valide
if [ "$branch_type" == "unknown" ]; then
    echo "Erreur : La branche '$current_branch' ne correspond pas à un type connu (hotfix, bugfix, feature, release)."
    exit 1
fi

# Appel du script correspondant
echo "Branche détectée : $current_branch ($branch_type)"
case "$branch_type" in
    hotfix)
        echo "Lancement de hotfix-finish.sh..."
        `dirname $0`/hotfix-finish.sh
        ;;
    bugfix)
        echo "Lancement de bugfix-finish.sh..."
        `dirname $0`/bugfix-finish.sh
        ;;
    feature)
        echo "Lancement de feature-finish.sh..."
        `dirname $0`/feature-finish.sh
        ;;
    release)
        echo "Lancement de release-finish.sh..."
        `dirname $0`/release-finish.sh
        ;;
    *)
        echo "Erreur inattendue."
        exit 1
        ;;
esac
