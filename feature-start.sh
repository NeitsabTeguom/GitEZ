#!/bin/bash

# Vérifie qu'un nom de feature est passé en paramètre
if [ -z "$1" ]; then
  echo "Usage: $0 <feature-name>"
  exit 1
fi

FEATURE_NAME=$1
DEVELOP_BRANCH="develop"
FEATURE_BRANCH="feature/$FEATURE_NAME"

# Vérifie si la branche develop existe
if ! git show-ref --verify --quiet refs/heads/$DEVELOP_BRANCH; then
  echo "Erreur : La branche '$DEVELOP_BRANCH' n'existe pas."
  exit 1
fi

# Vérifie si la branche feature existe déjà
if git show-ref --verify --quiet refs/heads/$FEATURE_BRANCH; then
  echo "Erreur : La branche '$FEATURE_BRANCH' existe déjà."
  exit 1
fi

echo "Commence la création de la feature : $FEATURE_BRANCH"

# Basculer sur la branche develop
git checkout $DEVELOP_BRANCH
if [ $? -ne 0 ]; then
  echo "Erreur : Impossible de basculer sur la branche '$DEVELOP_BRANCH'."
  exit 1
fi

# Met à jour la branche develop (optionnel, mais conseillé)
git pull origin $DEVELOP_BRANCH
if [ $? -ne 0 ]; then
  echo "Erreur : Impossible de mettre à jour la branche '$DEVELOP_BRANCH'."
  exit 1
fi

# Crée la branche feature
git checkout -b $FEATURE_BRANCH
if [ $? -ne 0 ]; then
  echo "Erreur : Impossible de créer la branche '$FEATURE_BRANCH'."
  exit 1
fi

# Pousse la branche à distance
git push -u origin $FEATURE_BRANCH
if [ $? -ne 0 ]; then
  echo "Erreur : Impossible de pousser la branche '$FEATURE_BRANCH' sur le dépôt distant."
  exit 1
fi

echo "Feature '$FEATURE_BRANCH' créée avec succès !"
