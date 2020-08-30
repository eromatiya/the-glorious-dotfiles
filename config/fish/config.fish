# Fish colors
set -g fish_color_command --bold green
set -g fish_color_error red
set -g fish_color_quote yellow
set -g fish_color_param white
set -g fish_pager_color_selected_completion blue

# Some config
set -g fish_greeting

# Git config
set -g __fish_git_prompt_show_informative_status 1
set -g __fish_git_prompt_showupstream "informative"
set -g __fish_git_prompt_showdirtystate "yes"
set -g __fish_git_prompt_char_stateseparator ' '
set -g __fish_git_prompt_char_cleanstate '✔'

# Get terminal emulator
set TERM_EMULATOR (ps -aux | grep (ps -p $fish_pid -o ppid=) | awk 'NR==1{print $11}')

# Neofetch
switch "$TERM_EMULATOR"
case '*kitty*'
	neofetch --backend 'kitty'
case '*tmux*' '*login*' '*sshd*'
	neofetch --backend 'ascii' --ascii_distro 'arch_small' 
case '*'
	neofetch --backend 'w3m' --xoffset 34 --yoffset 34 --gap 0
end

# Directory aliases
alias l='ls'
alias la='ls -a'
alias ll='ls -l'
alias lal='ls -al'
alias d='dirs'
alias h='cd $HOME'

# Locale
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# Exports
export VISUAL="vim"
export EDITOR="$VISUAL"

# Term
switch "$TERM_EMULATOR"
case '*kitty*'
	export TERM='xterm-kitty'
case '*'
	export TERM='xterm-256color'
end

# User aliases
alias ytmp3='youtube-dl --extract-audio --audio-format mp3'
alias cls='clear'
alias h='history'
alias upd='yay'
alias please='sudo'
alias shinei='kill -9'
alias sayonara='shutdown now'
alias ar='awesome-client "awesome.restart()"'
alias kv='kill -9 (pgrep vlc)'
alias priv='fish --private'

# Source plugins
if test -d "$HOME/.local/share/omf/pkg/colorman/"
	source ~/.local/share/omf/pkg/colorman/init.fish
end
