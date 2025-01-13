#!/bin/bash

# Inclusion du fichier utils
source `dirname $0`/inc/utils.sh

# Récupère la branche en cours
CURRENT_BRANCH=$(git symbolic-ref --short HEAD)

# Vérifie si la branche actuelle est une branche release
if [[ $CURRENT_BRANCH != release/* ]]; then
  echo "Erreur : La branche actuelle ('$CURRENT_BRANCH') n'est pas une branche release."
  exit 1
fi

RELEASE_BRANCH=$CURRENT_BRANCH
DEVELOP_BRANCH="develop"

echo "Détection de la branche release : $RELEASE_BRANCH"

# Extraire la version de la branche
RELEASE_VERSION=${RELEASE_BRANCH#release/}

# Vérifier si RELEASE_VERSION est valide
if ! validate_version "$RELEASE_VERSION"; then
    echo "La version détectée ($RELEASE_VERSION) n'est pas valide."
    read -p "Veuillez entrer une version valide (format X.Y.Z) : " RELEASE_VERSION
    while ! validate_version "$RELEASE_VERSION"; do
        echo "Format de version invalide. Essayez à nouveau."
        read -p "Veuillez entrer une version valide (format X.Y.Z) : " RELEASE_VERSION
    done
fi

echo "Version valide détectée : $RELEASE_VERSION"

# Inclusion du fichier de détection de branche principale
source `dirname $0`/inc/detect-main-branch.sh

# Vérification de l'état du repository
if ! git diff-index --quiet HEAD --; then
  echo "Erreur : Vous avez des modifications non commit dans votre repository."
  exit 1
fi

# Vérifie si les branches main et develop existent
for branch in $MAIN_BRANCH $DEVELOP_BRANCH; do
  if ! git show-ref --verify --quiet refs/heads/$branch; then
    echo "Erreur : La branche '$branch' n'existe pas."
    exit 1
  fi
done

echo "Commence la finalisation de la release : $RELEASE_BRANCH"

# Basculer sur la branche main
git checkout $MAIN_BRANCH
if [ $? -ne 0 ]; then
  echo "Erreur : Impossible de basculer sur la branche '$MAIN_BRANCH'."
  exit 1
fi

# Merge de la branche release dans main
git merge --no-ff $RELEASE_BRANCH -m "Merge release '$RELEASE_BRANCH' into $MAIN_BRANCH"
if [ $? -ne 0 ]; then
  echo "Erreur : Le merge sur '$MAIN_BRANCH' a échoué."
  exit 1
fi

# Tag la version
git tag -a "$RELEASE_VERSION" -m "Release version $RELEASE_VERSION"
if [ $? -ne 0 ]; then
  echo "Erreur : Impossible de créer le tag."
  exit 1
fi

# Basculer sur la branche develop
git checkout $DEVELOP_BRANCH
if [ $? -ne 0 ]; then
  echo "Erreur : Impossible de basculer sur la branche '$DEVELOP_BRANCH'."
  exit 1
fi

# Merge de la branche release dans develop
git merge --no-ff $RELEASE_BRANCH -m "Merge release '$RELEASE_BRANCH' into $DEVELOP_BRANCH"
if [ $? -ne 0 ]; then
  echo "Erreur : Le merge sur '$DEVELOP_BRANCH' a échoué."
  exit 1
fi

# Supprimer la branche release
git branch -d $RELEASE_BRANCH
if [ $? -ne 0 ]; then
  echo "Erreur : Impossible de supprimer la branche '$RELEASE_BRANCH'."
  exit 1
fi

# Pousser les changements à distance
git push origin $MAIN_BRANCH $DEVELOP_BRANCH --tags
if [ $? -ne 0 ]; then
  echo "Erreur : Impossible de pousser les modifications sur le dépôt distant."
  exit 1
fi

echo "Release '$RELEASE_BRANCH' finalisée avec succès !"
