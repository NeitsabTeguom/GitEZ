# Custom GitEZ Aliases

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Help
alias gez-h="$DIR/help.sh"

# Feature
alias gez-fs="$DIR/feature-start.sh"
alias gez-ff="$DIR/feature-finish.sh"

# Bugfix
alias gez-bs="$DIR/bugfix-start.sh"
alias gez-bf="$DIR/bugfix-finish.sh"

# Hotfix
alias gez-hs="$DIR/hotfix-start.sh"
alias gez-hf="$DIR/hotfix-finish.sh"

# Release
alias gez-rs="$DIR/release-start.sh"
alias gez-rf="$DIR/release-finish.sh"

# Finish the current branch
alias gez-f="$DIR/finish.sh"

# Automation of local changes and sending
alias gez-s="$DIR/push-all.sh"

# Get the master name branch
alias gez-gm="$DIR/inc/detect-main-branch.sh && echo \$MAIN_BRANCH"

# Common commands
alias gadd="git add ."
alias gcom="git commit -m"
alias gcoma="git commit -am"
alias gpush="git push"
alias gpull="git pull"
alias gstatus="git status"
alias gcheckout="git checkout"
