COLOR_RED="\033[31m"
COLOR_GREEN="\033[32m"
COLOR_YELLOW="\033[33m"
COLOR_BLUE="\033[34m"
COLOR_OCHRE="\033[38;5;95m"
COLOR_CYAN="\033[36m"
COLOR_RESET="\033[0m"

function git_color {
    local git_status="$(git status 2> /dev/null)"

    if [[ $git_status =~ "nothing to commit" ]]; then
        echo -e $COLOR_GREEN
    else
        echo -e $COLOR_RED
    fi
}

function git_branch {
    local git_status="$(git status 2> /dev/null)"
    local on_branch="On branch ([^${IFS}]*)"
    local on_commit="HEAD detached at ([^${IFS}]*)"

    if [[ $git_status =~ $on_branch ]]; then
        local branch=${BASH_REMATCH[1]}
        echo "($branch)"
    elif [[ $git_status =~ $on_commit ]]; then
        local branch=${BASH_REMATCH[1]}
        echo "($commit)"
    fi
}

#PS1="\[$COLOR_GREEN\]\u@\h "
PS1="\[$COLOR_YELLOW\]\w "
PS1+="\[\$(git_color)\]\$(git_branch)"
PS1+="\[$COLOR_CYAN\][\!]"
PS1+="\[$COLOR_RESET\]$ "
export PS1

alias ll="ls -lAh"
# git aliases
alias ga="git add"
alias gb="git blame"
alias gc="git commit"
alias gd="git diff"
alias gl="git log"
alias gpu="git pull"
alias gp="git push"
alias gs="git status"

################ GIT BASH ONLY ################
### auto-add ssh key
env=~/.ssh/agent.env

agent_load_env () { test -f "$env" && . "$env" >| /dev/null ; }

agent_start () {
    (umask7; ssh-agent >| "$env")
    . "$env" >| /dev/null ; }

agent_load_env

# agent_run_state: 0=agent running w/ key; 1=agent w/o key; 2= agent not running
agent_run_state=$(ssh-add -l >| /dev/null 2>&1; echo $?)

if [ ! "$SSH_AUTH_SOCK" ] || [ $agent_run_state = 2 ]; then
    agent_start
    ssh-add
elif [ "$SSH_AUTH_SOCK" ] && [ $agent_run_state = 1 ]; then
    ssh-add
fi

unset env
