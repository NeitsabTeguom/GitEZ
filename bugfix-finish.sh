#!/bin/bash

# Récupère la branche actuelle
CURRENT_BRANCH=$(git symbolic-ref --short HEAD)

# Vérifie que l'on est sur une branche `bugfix`
if [[ ! "$CURRENT_BRANCH" =~ ^bugfix/ ]]; then
  echo "Erreur : La branche actuelle '$CURRENT_BRANCH' n'est pas une branche de type 'bugfix/'."
  exit 1
fi

DEVELOP_BRANCH="develop"

# Vérifie si la branche develop existe
if ! git show-ref --verify --quiet refs/heads/$DEVELOP_BRANCH; then
  echo "Erreur : La branche '$DEVELOP_BRANCH' n'existe pas."
  exit 1
fi

# Inclusion du fichier de détection de branche principale
source `dirname $0`/inc/detect-main-branch.sh

echo "Préparation à la finalisation du bugfix : $CURRENT_BRANCH"

# Basculer sur develop pour effectuer la fusion
git checkout $DEVELOP_BRANCH
if [ $? -ne 0 ]; then
  echo "Erreur : Impossible de basculer sur la branche '$DEVELOP_BRANCH'."
  exit 1
fi

# Met à jour develop avec les dernières modifications distantes
git pull origin $DEVELOP_BRANCH
if [ $? -ne 0 ]; then
  echo "Erreur : Impossible de mettre à jour la branche '$DEVELOP_BRANCH'."
  exit 1
fi

# Fusionne la branche bugfix dans develop
git merge --no-ff $CURRENT_BRANCH -m "Merge bugfix: $CURRENT_BRANCH into $DEVELOP_BRANCH"
if [ $? -ne 0 ]; then
  echo "Erreur : Impossible de fusionner la branche '$CURRENT_BRANCH' dans '$DEVELOP_BRANCH'."
  exit 1
fi

# Pousse les modifications de develop
git push origin $DEVELOP_BRANCH
if [ $? -ne 0 ]; then
  echo "Erreur : Impossible de pousser les modifications de '$DEVELOP_BRANCH' sur le dépôt distant."
  exit 1
fi

# Basculer sur la branche principale (main/master)
git checkout $MAIN_BRANCH
if [ $? -ne 0 ]; then
  echo "Erreur : Impossible de basculer sur la branche '$MAIN_BRANCH'."
  exit 1
fi

# Met à jour la branche principale avec les dernières modifications distantes
git pull origin $MAIN_BRANCH
if [ $? -ne 0 ]; then
  echo "Erreur : Impossible de mettre à jour la branche '$MAIN_BRANCH'."
  exit 1
fi

# Fusionne la branche bugfix dans la branche principale
git merge --no-ff $CURRENT_BRANCH -m "Merge bugfix: $CURRENT_BRANCH into $MAIN_BRANCH"
if [ $? -ne 0 ]; then
  echo "Erreur : Impossible de fusionner la branche '$CURRENT_BRANCH' dans '$MAIN_BRANCH'."
  exit 1
fi

# Pousse les modifications de la branche principale
git push origin $MAIN_BRANCH
if [ $? -ne 0 ]; then
  echo "Erreur : Impossible de pousser les modifications de '$MAIN_BRANCH' sur le dépôt distant."
  exit 1
fi

# Supprime la branche locale bugfix
git branch -d $CURRENT_BRANCH
if [ $? -ne 0 ]; then
  echo "Erreur : Impossible de supprimer la branche locale '$CURRENT_BRANCH'."
  exit 1
fi

# Supprime la branche distante bugfix
git push origin --delete $CURRENT_BRANCH
if [ $? -ne 0 ]; then
  echo "Erreur : Impossible de supprimer la branche distante '$CURRENT_BRANCH'."
  exit 1
fi

echo "Bugfix '$CURRENT_BRANCH' finalisé avec succès, intégré dans '$DEVELOP_BRANCH' et '$MAIN_BRANCH'."
