# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Set up the prompt

autoload -Uz promptinit
promptinit
prompt adam1

setopt histignorealldups sharehistory

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Keep 100000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*' menu yes select
zstyle ':completion::complete:*' use-cache 1        #enables completion caching
zstyle ':completion::complete:*' cache-path ~/.zsh/cache
zstyle ':completion:*' users root $USER             #fix lag in google3
autoload -Uz compinit && compinit -i

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
autoload -U select-word-style
select-word-style normal

source ~/.zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

#to know the key binding for a key, run `od -c` and press the key
bindkey '^[[3~' delete-char           #enables DEL key proper behaviour
bindkey '^[[1;2C' forward-word
bindkey '^[[1;3C' forward-word        #[Ctrl-RightArrow] - move forward one word
bindkey '^[[1;2D' backward-word
bindkey '^[[1;3D' backward-word       #[Ctrl-LeftArrow] - move backward one word
bindkey  "^[[H"   beginning-of-line   #[Home] - goes at the begining of the line
bindkey  "^[[F"   end-of-line         #[End] - goes at the end of the line
bindkey "^[[3;3~" kill-word

#Enables history saving
setopt appendhistory
# setopt share_history        #share history between multiple instances of zsh

if [[ -f /etc/bash_completion.d/g4d ]]; then
  . /etc/bash_completion.d/p4
  . /etc/bash_completion.d/g4d
fi

alias history='history 0'

function prompt_gdir() {
  dir=$(pwd)
  if [[ "$dir" =~ ^\/google\/src\/cloud\/[^/]+\/[^/]+\/google3\/?(.*)$ ]]; then
    # CURRENT_DIRECTORY="//.../${match[3]}${match[4]}"
    CURRENT_DIRECTORY="//${match[1]}"
    CUSTOM_GLYPH=$'\uf1a0 '
  else
    CURRENT_DIRECTORY="$dir"
    CUSTOM_GLYPH=$'\uf07c '
  fi
  HOME_DIRECTORY_SYMBOL="~"
  TARGET_HOME_DIRECTORY="$HOME"
  FORMATTED_DIRECTORY="${CURRENT_DIRECTORY/$TARGET_HOME_DIRECTORY/$HOME_DIRECTORY_SYMBOL}"
  p10k segment -b blue -f '$POWERLEVEL9K_DIR_FOREGROUND' -t "$CUSTOM_GLYPH $FORMATTED_DIRECTORY"
}

function prompt_citc_client() {
  dir=$(pwd)

  if [[ "$dir" =~ ^(\/google\/src\/cloud\/([^\/]*)\/)([^\/]*)(\/*([^/]+\/)*)(.*)* ]]; then
    CITC_CLIENT_NAME="${match[3]}"
    # CUSTOM_GLYPH=$'\uf0c2 '
  else
    CITC_CLIENT_NAME=''
  fi

  p10k segment -b green -f '#000000' -c "$CITC_CLIENT_NAME" -t "$CITC_CLIENT_NAME"
}

source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

