# Custom GitEZ Aliases

# Feature
alias gez-fs="./feature-start.sh"
alias gez-ff="./feature-finish.sh"

# Bugfix
alias gez-bs="./bugfix-start.sh"
alias gez-bf="./bugfix-finish.sh"

# Hotfix
alias gez-hs="./hotfix-start.sh"
alias gez-hf="./hotfix-finish.sh"

# Release
alias gez-rs="./release-start.sh"
alias gez-rf="./release-finish.sh"

# Automation of local changes and sending
alias gsave="./push-all.sh"

# To check out the master branch automatically
alias gez-main="./inc/detect-main-branch.sh && echo \$MAIN_BRANCH"

# Common commands
alias gadd="git add ."
alias gcom="git commit -m"
alias gcoma="git commit -am"
alias gpush="git push"
alias gpull="git pull"
alias gstatus="git status"
alias gcheckout="git checkout"
