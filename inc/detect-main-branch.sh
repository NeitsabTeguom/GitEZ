#!/bin/bash

# Fonction pour détecter et valider la branche principale
MAIN_BRANCH=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')

# Vérifie que la branche principale est "main" ou "master"
if [[ "$MAIN_BRANCH" != "main" && "$MAIN_BRANCH" != "master" ]]; then
  echo "Erreur : La branche principale détectée est '$MAIN_BRANCH', mais elle doit être 'main' ou 'master'."
  exit 1
fi

# À ce stade, MAIN_BRANCH est déjà défini et validé
echo "Branche principale détectée et validée : $MAIN_BRANCH"