# Global colors - mostly used by fish_prompt.fish
set -g foreground		'#F8F8F2'
set -g black					'#3D4C5F'
set -g red						'#EE4F84'
set -g green					'#53E2AE'
set -g yellow				'#F1FF52'
set -g blue					'#6498EF'
set -g magenta			'#985EFF'
set -g cyan					'#24D1E7'
set -g white					'#E5E5E5'

# Some config
set -g fish_greeting
set -g theme_nerd_fonts yes
set -g theme display_user yes

# Git config
set -g __fish_git_prompt_show_informative_status 1
set -g __fish_git_prompt_color_branch $magenta
set -g __fish_git_prompt_showupstream "informative"
set -g __fish_git_prompt_showdirtystate "yes"
set -g __fish_git_prompt_char_stateseparator ' '
set -g __fish_git_prompt_color_stagedstate $yellow
set -g __fish_git_prompt_color_invalidstate $red
set -g __fish_git_prompt_char_cleanstate '✔'
set -g __fish_git_prompt_color_cleanstate $green
set -g __fish_git_prompt_color_branch $white
set -g __fish_git_prompt_color_prefix $white
set -g __fish_git_prompt_color_suffix $white

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

export GREP_OPTIONS="--color=auto"; # make grep colorful
export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD; # make ls more colorful as well
export HISTSIZE=32768; # Larger bash history (allow 32³ entries; default is 500)
export HISTFILESIZE=$HISTSIZE;
export HISTCONTROL=ignoredups; # Remove duplicates from history. I use `git status` a lot.
export HISTIGNORE="ls:cd:cd -:pwd:exit:date:* --help"; # Make some commands not show up in history
export LANG="en_US.UTF-8"; # Language formatting is still important
export LC_ALL="en_US.UTF-8"; # byte-wise sorting and force language for those pesky apps
export MANPAGER="less -X"; # Less is more
export GPG_TTY=(tty); # for gpg key management
