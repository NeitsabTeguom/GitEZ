#!/bin/bash

# Vérifie qu'un nom de hotfix est passé en paramètre
if [ -z "$1" ]; then
  echo "Usage: $0 <hotfix-name>"
  exit 1
fi

HOTFIX_NAME=$1
HOTFIX_BRANCH="hotfix/$HOTFIX_NAME"

# Inclusion du fichier de détection de branche principale
source `dirname $0`/inc/detect-main-branch.sh

# Vérifie si la branche main existe
if ! git show-ref --verify --quiet refs/heads/$MAIN_BRANCH; then
  echo "Erreur : La branche '$MAIN_BRANCH' n'existe pas."
  exit 1
fi

# Vérifie si la branche hotfix existe déjà
if git show-ref --verify --quiet refs/heads/$HOTFIX_BRANCH; then
  echo "Erreur : La branche '$HOTFIX_BRANCH' existe déjà."
  exit 1
fi

echo "Commence la création du hotfix : $HOTFIX_BRANCH"

# Basculer sur la branche main
git checkout $MAIN_BRANCH
if [ $? -ne 0 ]; then
  echo "Erreur : Impossible de basculer sur la branche '$MAIN_BRANCH'."
  exit 1
fi

# Met à jour la branche main (optionnel mais recommandé)
git pull origin $MAIN_BRANCH
if [ $? -ne 0 ]; then
  echo "Erreur : Impossible de mettre à jour la branche '$MAIN_BRANCH'."
  exit 1
fi

# Crée la branche hotfix
git checkout -b $HOTFIX_BRANCH
if [ $? -ne 0 ]; then
  echo "Erreur : Impossible de créer la branche '$HOTFIX_BRANCH'."
  exit 1
fi

# Pousse la branche à distance
git push -u origin $HOTFIX_BRANCH
if [ $? -ne 0 ]; then
  echo "Erreur : Impossible de pousser la branche '$HOTFIX_BRANCH' sur le dépôt distant."
  exit 1
fi

echo "Hotfix '$HOTFIX_BRANCH' créé avec succès !"
