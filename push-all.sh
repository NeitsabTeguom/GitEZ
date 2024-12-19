#!/bin/bash

# Vérifie qu'un message de commit est passé en paramètre
if [ -z "$1" ]; then
  echo "Usage: $0 <message de commit>"
  exit 1
fi

COMMIT_MESSAGE="$1"

echo "Ajout de tous les fichiers modifiés au suivi..."
git add .

# Vérifie s'il y a quelque chose à commit
if git diff --cached --quiet; then
  echo "Aucune modification à committer."
  exit 0
fi

echo "Création du commit avec le message : '$COMMIT_MESSAGE'"
git commit -m "$COMMIT_MESSAGE"

if [ $? -ne 0 ]; then
  echo "Erreur : Impossible de créer le commit."
  exit 1
fi

echo "Poussée des modifications vers le dépôt distant..."
git push

if [ $? -ne 0 ]; then
  echo "Erreur : Impossible de pousser les modifications."
  exit 1
fi

echo "Modifications poussées avec succès !"
