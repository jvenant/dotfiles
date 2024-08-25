export EDITOR=nvim
export VISUAL=nvim
export GOPATH="$HOME/.local/go"

export PATH=$(echo $PATH | sed -e 's#:\?/mnt/[^:]*##g')
export PATH=$HOME/.local/bin/:$PATH


#Zinit initialization
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"


#Plugin setup
zinit snippet PZTM::fasd # Fasd shortcuts like ,, need to be loaded before fzf-tab
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab # Use fzf for args on Tab

#zinit ice wait"1" lucid
#zinit light wookayin/fzf-fasd

zinit snippet OMZP::git
zinit snippet OMZP::kubectl

autoload -U compinit && compinit

zinit cdreplay -q # recommended by zinit

# Init fzf
eval "$(fzf --zsh)"
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"
export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200"
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -a1 --icons --color=always --group-directories-first --git $realpath'
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}
_fzf_comprun() {
  local command=$1
  shift
  case "$command" in
    cd) fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo \$' {}" "$@" ;;
    ssh) fzf --preview 'dig {}' "$@" ;;
    *) fzf --preview "--preview 'bat -n --color=always --line-range :500 {}'" "$@" ;;
  esac
}

FZF_GIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/fzf-git.sh.git"
if [ ! -d "$FZF_GIT_HOME" ]; then
  mkdir -p "$(dirname $FZF_GIT_HOME)"
  git clone https://github.com/junegunn/fzf-git.sh.git "$FZF_GIT_HOME"
fi
source "${FZF_GIT_HOME}/fzf-git.sh"

# Misc setup
setopt autocd
autoload edit-command-line; zle -N edit-command-line
bindkey -v
bindkey -M vicmd v edit-command-line # Vim mode and edit

# History config
bindkey '^ ' forward-word # Move forward one word with Ctrl + space
# Make zsh autocomplete with up arrow
#autoload -Uz history-search-end
#zle -N history-beginning-search-backward-end history-search-end
#zle -N history-beginning-search-forward-end history-search-end
# bindkey "$terminfo[kcuu1]" history-beginning-search-backward-end
# bindkey "$terminfo[kcud1]" history-beginning-search-forward-end
bindkey "$terminfo[kcuu1]" history-beginning-search-backward
bindkey "$terminfo[kcud1]" history-beginning-search-forward

HISTSIZE=5000
HISTFILE=$HOME/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

#Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' # case unsensitive completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}" # use color for list completion
zstyle ':completion:*' menu no # Disable completion menu as we use fzf-tab instead

# Prompt initialization (there is issue when initilized prior to zsh plugins: arrow search and transient prompt don't work anymore)
eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/config.toml)"

#Aliases
TREE_IGNORE="cache|log|logs|node_modules|vendor|target"

alias ..='cd ..'
alias vim=nvim
alias baty='bat -lyaml'

alias ls=' eza --group-directories-first'
alias l='ls -l --git --icons=always --no-permissions --no-time --no-user'
alias ll='ls -l --git --icons=always'
alias la='ll -a'

alias lt='ls --tree -D -L 2 -I ${TREE_IGNORE}'
alias ltt='ls --tree -D -L 3 -I ${TREE_IGNORE}'
alias lttt='ls --tree -D -L 4 -I ${TREE_IGNORE}'
alias ltttt='ls --tree -D -L 5 -I ${TREE_IGNORE}'

alias kg='kubectl get'
alias kn='f() { [ "$1" ] && k config set-context --current --namespace $1; } ; f'

alias cat='bat'

source <(kubectl completion zsh)
source "$HOME/.cargo/env"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

