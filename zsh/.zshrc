export GPG_TTY=$(tty)
ssh-add --apple-load-keychain -q

if [[ "${widgets[zle-keymap-select]#user:}" == "starship_zle-keymap-select" || \
      "${widgets[zle-keymap-select]#user:}" == "starship_zle-keymap-select-wrapped" ]]; then
    zle -N zle-keymap-select "";
fi
eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)
# bun completions
[ -s "/Users/arhan/.bun/_bun" ] && source "/Users/arhan/.bun/_bun"

# Changing directories
setopt AUTO_CD           # Change directories by just typing the name of the directory as if it's a command.
setopt AUTO_PUSHD        # Automatically push directories onto the directory stack.
setopt CHASE_LINKS       # Follow symlinks when changing directories.
setopt PUSHD_TO_HOME     # `pushd` with no arguments acts like `pushd $HOME`.
setopt PUSHD_IGNORE_DUPS # Don't push duplicates onto the directory stack.

# Command history
setopt APPEND_HISTORY         # Append history entries rather than replacing. Allows multiple concurrent ZSH instances to all save shell history.
setopt EXTENDED_HISTORY       # Save timestamp and duration of command in history.
setopt HIST_IGNORE_DUPS       # Collapse contiguous duplicate history entries.
setopt HIST_REDUCE_BLANKS     # Remove extra whitespace from history entries.
setopt HIST_IGNORE_SPACE      # Don't save commands that start with a space in history.
HISTFILE="$HOME/.zsh_history" # Where to save history.
HISTSIZE=10000                # Number of history entries to store in memory.

# Globbing/expansion
setopt EXTENDED_GLOB # Treat #, ~, and ^ as part of patterns for filename generation.
setopt NOMATCH       # Error if a pattern doesn't match any files instead of treating the pattern as an argument.

# Input/Output
setopt NO_CLOBBER           # Don't overwrite files using '>'. Requires '>|' or '>!' to force overwriting.
setopt CLOBBER_EMPTY  # Allow overwriting empty files using '>'.
setopt CORRECT              # Try to correct misspelled commands.
setopt INTERACTIVE_COMMENTS # Allow comments in interactive mode. Useful for copy/pasting scripts.
setopt RM_STAR_SILENT       # Don't prompt when running `rm *`. Should be used in conjunction with rm's `-I` flag.

# Job control
setopt AUTO_CONTINUE # Automatically continue stopped jobs when disowning.
setopt CHECK_JOBS    # Check background jobs before exiting.

# Completion
setopt MENU_COMPLETE  # If no unambiguous completion exists, go straight to menu.
setopt LIST_AMBIGUOUS # Show completion list if there are multiple completions.

alias python=python3.14
alias ls="eza --git --group-directories-first"
alias g=git
alias cat=bat
alias catt="cat -pp"
alias ptpy="ptpython --vi"
alias cd=z
alias hex="od -A n -t x1"
alias zed=zed-preview

# Added by LM Studio CLI
export PATH="$PATH:/Users/arhan/.lmstudio/bin"

# Added by Antigravity
export PATH="/Users/arhan/.antigravity/antigravity/bin:$PATH"

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi
# conflicts with zoxide
declare -A ZINIT=([NO_ALIASES]=1)
source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust
### End of Zinit's installer chunk

zinit ice depth=1
zinit light jeffreytse/zsh-vi-mode
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit ice lucid wait"0a" from"gh-r" as"program" atload'eval "$(mcfly init zsh)"'
export MCFLY_KEY_SCHEME=vim
export MCFLY_FUZZY=2
if [[ "$(defaults read -g AppleInterfaceStyle 2&>/dev/null)" != "Dark" ]]; then
    export MCFLY_LIGHT=TRUE
fi
zinit light cantino/mcfly

declare -U PATH path
source <(COMPLETE=zsh jj)

fastfetch
