#!/bin/bash

# Récupère la branche en cours
CURRENT_BRANCH=$(git symbolic-ref --short HEAD)

# Vérifie si la branche actuelle est une branche hotfix
if [[ $CURRENT_BRANCH != hotfix/* ]]; then
  echo "Erreur : La branche actuelle ('$CURRENT_BRANCH') n'est pas une branche hotfix."
  exit 1
fi

HOTFIX_BRANCH=$CURRENT_BRANCH
DEVELOP_BRANCH="develop"

echo "Détection de la branche hotfix : $HOTFIX_BRANCH"

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

echo "Commence la finalisation du hotfix : $HOTFIX_BRANCH"

# Basculer sur la branche main
git checkout $MAIN_BRANCH
if [ $? -ne 0 ]; then
  echo "Erreur : Impossible de basculer sur la branche '$MAIN_BRANCH'."
  exit 1
fi

# Merge de la branche hotfix dans main
git merge --no-ff $HOTFIX_BRANCH -m "Merge hotfix '$HOTFIX_BRANCH' into $MAIN_BRANCH"
if [ $? -ne 0 ]; then
  echo "Erreur : Le merge sur '$MAIN_BRANCH' a échoué."
  exit 1
fi

# Tag la version
HOTFIX_VERSION=${HOTFIX_BRANCH#hotfix/}
git tag -a "$HOTFIX_VERSION" -m "Version $HOTFIX_VERSION"
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

# Merge de la branche hotfix dans develop
git merge --no-ff $HOTFIX_BRANCH -m "Merge hotfix '$HOTFIX_BRANCH' into $DEVELOP_BRANCH"
if [ $? -ne 0 ]; then
  echo "Erreur : Le merge sur '$DEVELOP_BRANCH' a échoué."
  exit 1
fi

# Supprimer la branche hotfix
git branch -d $HOTFIX_BRANCH
if [ $? -ne 0 ]; then
  echo "Erreur : Impossible de supprimer la branche '$HOTFIX_BRANCH'."
  exit 1
fi

# Pousser les changements à distance
git push origin $MAIN_BRANCH $DEVELOP_BRANCH --tags
if [ $? -ne 0 ]; then
  echo "Erreur : Impossible de pousser les modifications sur le dépôt distant."
  exit 1
fi

echo "Hotfix '$HOTFIX_BRANCH' finalisé avec succès !"
