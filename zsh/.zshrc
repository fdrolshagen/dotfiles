# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Load ENV Variables that may contain secrets
source ~/.env

eval "$(ssh-agent -s)"

export PATH=~/bin:$PATH
export PATH="/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH"

alias ll='ls -la'

alias pps='podman ps --format "{{.Names}} {{.ID}}  {{.Image}} {{.Ports}}" | column -t'
alias pcl='podman container ls --all --format "{{.Names}} {{.ID}}  {{.Image}} {{.Ports}} {{.Status}}" | column -t'

parse_git_branch() {
    git branch 2> /dev/null | sed -n -e 's/^\* \(.*\)/[\1]/p'
}

alias podman-compose='docker-compose'
alias docker='podman'
alias vim='nvim'


COLOR_DEF='%f'
COLOR_USR='%F{243}'
COLOR_DIR='%F{197}'
COLOR_GIT='%F{39}'
NEWLINE=$'\n'
setopt PROMPT_SUBST
#export PROMPT='${COLOR_USR}%n ${COLOR_DIR}%d ${COLOR_GIT}$(parse_git_branch)${COLOR_DEF}${NEWLINE}%% '
export PROMPT='${COLOR_DIR}%d ${COLOR_GIT}$(parse_git_branch)${COLOR_DEF}${NEWLINE}%% '
source ~/.virtualenv/pppy311/bin/activate
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
export POWERLEVEL9K_INSTANT_PROMPT=quiet

export _JAVA_OPTIONS=-Djavax.net.ssl.trustStoreType=KeychainStore
