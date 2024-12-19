#!/bin/bash

# Vérifie qu'un nom de release est passé en paramètre
if [ -z "$1" ]; then
  echo "Usage: $0 <release-name>"
  exit 1
fi

RELEASE_NAME=$1
DEVELOP_BRANCH="develop"
RELEASE_BRANCH="release/$RELEASE_NAME"

# Vérifie si la branche develop existe
if ! git show-ref --verify --quiet refs/heads/$DEVELOP_BRANCH; then
  echo "Erreur : La branche '$DEVELOP_BRANCH' n'existe pas."
  exit 1
fi

# Vérifie si la branche release existe déjà
if git show-ref --verify --quiet refs/heads/$RELEASE_BRANCH; then
  echo "Erreur : La branche '$RELEASE_BRANCH' existe déjà."
  exit 1
fi

echo "Commence la création de la release : $RELEASE_BRANCH"

# Basculer sur la branche develop
git checkout $DEVELOP_BRANCH
if [ $? -ne 0 ]; then
  echo "Erreur : Impossible de basculer sur la branche '$DEVELOP_BRANCH'."
  exit 1
fi

# Met à jour la branche develop (optionnel mais conseillé)
git pull origin $DEVELOP_BRANCH
if [ $? -ne 0 ]; then
  echo "Erreur : Impossible de mettre à jour la branche '$DEVELOP_BRANCH'."
  exit 1
fi

# Crée la branche release
git checkout -b $RELEASE_BRANCH
if [ $? -ne 0 ]; then
  echo "Erreur : Impossible de créer la branche '$RELEASE_BRANCH'."
  exit 1
fi

# Pousse la branche à distance
git push -u origin $RELEASE_BRANCH
if [ $? -ne 0 ]; then
  echo "Erreur : Impossible de pousser la branche '$RELEASE_BRANCH' sur le dépôt distant."
  exit 1
fi

echo "Release '$RELEASE_BRANCH' créée avec succès !"
