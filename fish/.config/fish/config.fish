set -g fish_greeting
fish_vi_key_bindings

fish_add_path ~/.cargo/bin
fish_add_path ~/.local/bin
export GPG_TTY=$(tty)
ssh-add --apple-load-keychain -q

for brew_bin in /opt/homebrew/bin/brew /home/linuxbrew/.linuxbrew/bin/brew /usr/local/bin/brew
    if test -x $brew_bin
        $brew_bin shellenv | source
        break
    end
end
starship init fish | source
zoxide init fish | source
fzf --fish | source
jj util completion fish | source

alias python python3.14
alias ls "eza --git --group-directories-first"
alias g git
alias cat bat
alias catt "cat -pp"
alias ptpy "ptpython --vi"
alias cd z
alias hex "od -A n -t x1"
alias zed zed-preview

fastfetch
