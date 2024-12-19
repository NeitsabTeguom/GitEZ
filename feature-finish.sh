#!/bin/bash

# Récupère la branche en cours
CURRENT_BRANCH=$(git symbolic-ref --short HEAD)

# Vérifie si la branche actuelle est une branche feature
if [[ $CURRENT_BRANCH != feature/* ]]; then
  echo "Erreur : La branche actuelle ('$CURRENT_BRANCH') n'est pas une branche feature."
  exit 1
fi

FEATURE_BRANCH=$CURRENT_BRANCH
DEVELOP_BRANCH="develop"

echo "Détection de la branche feature : $FEATURE_BRANCH"

# Vérification de l'état du repository
if ! git diff-index --quiet HEAD --; then
  echo "Erreur : Vous avez des modifications non commit dans votre repository."
  exit 1
fi

# Vérifie si la branche develop existe
if ! git show-ref --verify --quiet refs/heads/$DEVELOP_BRANCH; then
  echo "Erreur : La branche '$DEVELOP_BRANCH' n'existe pas."
  exit 1
fi

echo "Commence la finalisation de la feature : $FEATURE_BRANCH"

# Basculer sur la branche develop
git checkout $DEVELOP_BRANCH
if [ $? -ne 0 ]; then
  echo "Erreur : Impossible de basculer sur la branche '$DEVELOP_BRANCH'."
  exit 1
fi

# Merge de la branche feature dans develop
git merge --no-ff $FEATURE_BRANCH -m "Merge feature '$FEATURE_BRANCH' into $DEVELOP_BRANCH"
if [ $? -ne 0 ]; then
  echo "Erreur : Le merge sur '$DEVELOP_BRANCH' a échoué."
  exit 1
fi

# Supprimer la branche feature
git branch -d $FEATURE_BRANCH
if [ $? -ne 0 ]; then
  echo "Erreur : Impossible de supprimer la branche '$FEATURE_BRANCH'."
  exit 1
fi

# Pousser les changements à distance
git push origin $DEVELOP_BRANCH
if [ $? -ne 0 ]; then
  echo "Erreur : Impossible de pousser les modifications sur le dépôt distant."
  exit 1
fi

echo "Feature '$FEATURE_BRANCH' finalisée avec succès !"
