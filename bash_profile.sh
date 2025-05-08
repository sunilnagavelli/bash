#!/bin/bash

#https://blog.martinfitzpatrick.com/add-git-branch-name-to-terminal-prompt-mac/ - Git Branch in Prompt

#export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\W\[\033[m\]\$ "
parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
parse_aws_acct() {
     if [ -z $AWSACCOUNT ]; then AWSACCOUNT="`aws sts get-caller-identity --output text --query 'Account' 2>/dev/null`"; fi
}

export PS1="[\u@\h \[\033[35m\]\W\[\033[33m\]\$(parse_git_branch)\[\033[00m\]]$ "
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
alias ls='ls -GFh'
#PATH VARIABLES
export HOME=/Users/nsunil
export APPS_HOME=/Users/nsunil/Applications
export PATH=$PATH:$APPS_HOME/Terraform:$APPS_HOME/Maven/apache-maven-3.5.3/bin

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/nsunil/.sdkman"
[[ -s "/Users/nsunil/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/nsunil/.sdkman/bin/sdkman-init.sh"

#AWS CLI CONFIGURATION
export PATH=$PATH

#ALIAS
#alias gitupdateall='for i in `ls /Users/nsunil/Work/Repos/|grep -E "myctb|aws"`; do cd /Users/nsunil/Work/Repos/$i; printf "\033[0;33mProject: $i\033[0m - "; git pull; git status | tail -n 1; cd ../; done'
#alias gitstatusall='for i in `ls /Users/nsunil/Work/Repos/|grep -E "myctb|aws"`; do cd /Users/nsunil/Work/Repos/$i; printf "\033[0;33mProject: $i\033[0m - "; git status | tail -n 1; cd ../; done'
#alias gitupdate='for repo in `ls`; do cd $repo; printf "\033[0;33mProject:\033[0m $repo - "; git pull; cd ../; done'
alias gitupdate='origindir=$(pwd); for repo in `find $(pwd) -type d -name ".git" | cut -d"." -f1`; do cd $repo; printf "Repo:\033[0;36m $repo\033[0m - "; git pull; cd $origindir; done'
alias gitstatus='origindir=$(pwd); for repo in `find $(pwd) -type d -name ".git" | cut -d"." -f1`; do cd $repo; printf "Repo:\033[0;36m $repo\033[0m - "; git status; cd $origindir; done'

alias bashcolors='for i in {30..37}; do printf "Color-Code: ${i} \033[0;${i}m hello \033[0m\n"; done'

# Setting PATH for Python 3.6
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.6/bin:${PATH}"
export PATH

export ORACLE_HOME=/Applications/oracle/product/instantclient_64/12.2.0.1
export PATH=$ORACLE_HOME/bin:$PATH
export DYLD_LIBRARY_PATH=$ORACLE_HOME/lib
