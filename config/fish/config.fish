# Remove greeting
set fish_greeting
set -g theme_nerd_fonts yes
set -g theme display_user yes
set -g default_user dumbass

# Remove pastfish greeting
function fish_greeting
end

# Get terminal emulator
set TERM_EMULATOR (basename "/"(ps -f -p (cat /proc/(echo %self)/stat | cut -d \  -f 4) | tail -1 | sed 's/^.* //'))

# Neofetch
switch "$TERM_EMULATOR"
case '*kitty*'
	neofetch --backend 'kitty'
case '*tmux*'
	neofetch --backend 'w3m' --ascii_distro 'arch_small' 
case '*login*'
	neofetch --backend 'w3m' --ascii_distro 'arch_small' 
case '*'
	neofetch --backend 'w3m' --xoffset 40 --yoffset 40 --gap 0
end

# Directory aliases
alias la='ls -a'
alias ll='ls -l'
alias lal='ls -al'
alias d='dirs -v'

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
