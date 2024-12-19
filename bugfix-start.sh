#!/bin/bash

# Vérifie qu'un nom de bugfix est passé en paramètre
if [ -z "$1" ]; then
  echo "Usage: $0 <bugfix-name>"
  exit 1
fi

BUGFIX_NAME=$1
DEVELOP_BRANCH="develop"
BUGFIX_BRANCH="bugfix/$BUGFIX_NAME"

# Vérifie si la branche develop existe
if ! git show-ref --verify --quiet refs/heads/$DEVELOP_BRANCH; then
  echo "Erreur : La branche '$DEVELOP_BRANCH' n'existe pas."
  exit 1
fi

# Vérifie si la branche bugfix existe déjà
if git show-ref --verify --quiet refs/heads/$BUGFIX_BRANCH; then
  echo "Erreur : La branche '$BUGFIX_BRANCH' existe déjà."
  exit 1
fi

echo "Commence la création du bugfix : $BUGFIX_BRANCH"

# Basculer sur la branche develop
git checkout $DEVELOP_BRANCH
if [ $? -ne 0 ]; then
  echo "Erreur : Impossible de basculer sur la branche '$DEVELOP_BRANCH'."
  exit 1
fi

# Met à jour la branche develop
git pull origin $DEVELOP_BRANCH
if [ $? -ne 0 ]; then
  echo "Erreur : Impossible de mettre à jour la branche '$DEVELOP_BRANCH'."
  exit 1
fi

# Crée la branche bugfix
git checkout -b $BUGFIX_BRANCH
if [ $? -ne 0 ]; then
  echo "Erreur : Impossible de créer la branche '$BUGFIX_BRANCH'."
  exit 1
fi

# Pousse la branche à distance
git push -u origin $BUGFIX_BRANCH
if [ $? -ne 0 ]; then
  echo "Erreur : Impossible de pousser la branche '$BUGFIX_BRANCH' sur le dépôt distant."
  exit 1
fi

echo "Bugfix '$BUGFIX_BRANCH' créée avec succès !"
