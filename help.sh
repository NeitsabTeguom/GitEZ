#!/bin/bash

# Function to show main help
display_help() {
 echo "=== Git EZ Help ==="
 echo ""
 echo "This script provides information about available commands and scripts."
 echo "Usage:"
 echo " gez-h - Show this general help."
 echo " gez-h <command> - Show help for a specific command."
 echo ""
 echo "=== List of commands ==="
 echo "Alias:"
 echo " gez-fs - Start a new feature."
 echo " gez-ff - Finalize a feature."
 echo " gez-bs - Start a bugfix."
 echo " gez-bf - Finalize a bugfix."
 echo " gez-hs - Start a hotfix."
 echo " gez-hf - Finalize a hotfix."
 echo " gez-rs - Start a release."
 echo " gez-rf - Finalize a release."
 echo " gez-f  - Finish the current branch."
 echo " gez-s  - Quick save (add + commit + push)."
 echo " gez-gm - Get the master name branch."
 echo ""
 echo "For more details about a command, use: gez-h <command>"
}

# Function to show command help
display_command_help() {
 case "$1" in
  gez-init)
   echo "gez-init: Initialize Git Flow."
   echo "Run git flow init with default parameters."
   ;;
  gez-fs)
   echo "gez-fs: Start a new feature."
   echo "Usage: gez-fs <feature-name>"
   echo "Create a feature/<feature-name> branch from develop."
   ;;
  gez-ff)
   echo "gez-ff: Finalize a feature."
   echo "Merge the feature/<feature-name> branch into develop and delete it."
   ;;
  gez-bs)
   echo "gez-bs: Start a bugfix."
   echo "Usage: gez-bs <bugfix-name>"
   echo "Create a bugfix/<bugfix-name> branch from develop."
   ;;
  gez-bf)
   echo "gez-bf: Finalize a bugfix."
   echo "Merge the bugfix/<bugfix-name> branch into develop and main, then delete it."
   ;;
  gez-hs)
   echo "gez-hs: Start a hotfix."
   echo "Usage: gez-hs <hotfix-name>"
   echo "Create a hotfix/<hotfix-name> branch from main."
   ;;
  gez-hf)
   echo "gez-hf: Finalize a hotfix."
   echo "Merge the hotfix/<hotfix-name> branch into main and develop, then delete it."
   ;;
  gez-rs)
   echo "gez-rs: Start a release."
   echo "Usage: gez-rs <release-name>"
   echo "Create a release/<release-name> branch from develop."
   ;;
  gez-rf)
   echo "gez-rf: Finalize a release."
   echo "Merge the release/<release-name> branch into main and develop, then delete it."
   ;;
  gez-f)
   echo "gez-f: Finish the current branch."
   echo "Merge the <current type>/<name> branch into main / develop based on the branch type, then delete it."
   ;;
  gez-s)
   echo "gez-s: Quick save."
   echo "Add all files, commit with the message 'Save progress', and push the changes."
   ;;
  gez-gm)
   echo "gez-s: Get the master name branch."
   ;;
  *)
   echo "Unknown command: $1"
   echo "Use gez-h for a list of available commands."
   ;;
 esac
}

# Main script
if [ $# -eq 0 ]; then
 # General help if no argument is provided
 display_help
else
 # Specific help if a command is provided
 display_command_help "$1"
fi