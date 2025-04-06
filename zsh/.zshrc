# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:~/bin/:$PATH

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="funky"

plugins=(
    git
    archlinux
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

export EDITOR='emacsclient'

# Check archlinux plugin commands here
# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/archlinux

# Display Pokemon-colorscripts
# Project page: https://gitlab.com/phoneybadger/pokemon-colorscripts#on-other-distros-and-macos
pokemon-colorscripts --no-title -s -r


# Set-up FZF key bindings (CTRL R for fuzzy history finder)
source <(fzf --zsh)

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# Set-up icons for files/folders in terminal
alias ls='eza -a --icons'
alias ll='eza -al --icons'
alias lt='eza -a --tree --level=1 --icons'
alias e='emacsclient -c -a "" -n'
