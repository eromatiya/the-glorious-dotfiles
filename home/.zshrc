# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# ░▀█▀░█▀▀░█▀▄░█▄█░▀█▀░█▀█░█▀█░█░░░░░█▀▀░█▄█░█░█░█░░░█▀█░▀█▀░█▀█░█▀▄
# ░░█░░█▀▀░█▀▄░█░█░░█░░█░█░█▀█░█░░░░░█▀▀░█░█░█░█░█░░░█▀█░░█░░█░█░█▀▄
# ░░▀░░▀▀▀░▀░▀░▀░▀░▀▀▀░▀░▀░▀░▀░▀▀▀░░░▀▀▀░▀░▀░▀▀▀░▀▀▀░▀░▀░░▀░░▀▀▀░▀░▀

# Get Terminal Emulator
TERM_EMULATOR=$(ps -h -o comm -p $PPID)

# ░█▀█░█▀▀░█▀█░█▀▀░█▀▀░▀█▀░█▀▀░█░█
# ░█░█░█▀▀░█░█░█▀▀░█▀▀░░█░░█░░░█▀█
# ░▀░▀░▀▀▀░▀▀▀░▀░░░▀▀▀░░▀░░▀▀▀░▀░▀

if [[ "$TERM_EMULATOR" == *"kitty"* ]];
then
	# kitty
	neofetch --backend 'kitty'
elif [[  "$TERM_EMULATOR" == *"tmux"*  ]] || [[ "$TERM_EMULATOR" == "login" ]];
	then
	# tmux
	neofetch --backend 'w3m' --ascii_distro 'arch_small' 
else
	# xterm and rxvt
	neofetch --backend 'w3m' --xoffset 40 --yoffset 40 --gap 0
fi


# ░█░░░█▀█░█▀▀░█▀█░█░░░█▀▀
# ░█░░░█░█░█░░░█▀█░█░░░█▀▀
# ░▀▀▀░▀▀▀░▀▀▀░▀░▀░▀▀▀░▀▀▀

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"


# ░▀▀█░█▀▀░█░█░░░█▀▀░█▀█░█▀█░█▀▀░▀█▀░█▀▀
# ░▄▀░░▀▀█░█▀█░░░█░░░█░█░█░█░█▀▀░░█░░█░█
# ░▀▀▀░▀▀▀░▀░▀░░░▀▀▀░▀▀▀░▀░▀░▀░░░▀▀▀░▀▀▀

# Improved less option
export LESS="--tabs=4 --no-init --LONG-PROMPT --ignore-case --quit-if-one-screen --RAW-CONTROL-CHARS"

# Watching other users
# WATCHFMT="%n %a %l from %m at %t."
watch=(notme)				# Report login/logout events for everybody except ourself.
# watch=(all)					# Report login/logout events for everybody except ourself.
LOGCHECK=60				# Time (seconds) between checks for login/logout activity.
REPORTTIME=5				# Display usage statistics for commands running > 5 sec.
# WORDCHARS="\"*?_-.[]~=/&;!#$%^(){}<>\""
# WORDCHARS="\"*?_-[]~&;!#$%^(){}<>\""
WORDCHARS='`~!@#$%^&*()-_=+[{]}\|;:",<.>/?'"'"

# History
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

setopt autocd							# Allow changing directories without `cd`
setopt append_history				# Dont overwrite history
setopt extended_history			# Also record time and duration of commands.
setopt share_history				# Share history between multiple shells
setopt hist_expire_dups_first	# Clear duplicates when trimming internal hist.
setopt hist_find_no_dups			# Dont display duplicates during searches.
setopt hist_ignore_dups			# Ignore consecutive duplicates.
setopt hist_ignore_all_dups		# Remember only one unique copy of the command.
setopt hist_reduce_blanks		# Remove superfluous blanks.
setopt hist_save_no_dups		# Omit older commands in favor of newer ones.

# Changing directories
#setopt auto_pushd					# Make cd push the old directory onto the directory stack. 
setopt pushd_ignore_dups		# Dont push copies of the same dir on stack.
setopt pushd_minus				# Reference stack entries with "-".

setopt extended_glob				# Treat the ‘#’, ‘~’ and ‘^’ characters as part of patterns for filename generation, etc. (An initial unquoted ‘~’ always produces named directory expansion.) 

# ░█▀█░█░░░▀█▀░█▀█░█▀▀
# ░█▀█░█░░░░█░░█▀█░▀▀█
# ░▀░▀░▀▀▀░▀▀▀░▀░▀░▀▀▀

# Generic command adaptations
alias grep='() { $(whence -p grep) --color=auto $@ }'
alias egrep='() { $(whence -p egrep) --color=auto $@ }'

# Custom helper aliases
alias ccat='highlight -O ansi'
alias rm='rm -v'

# Directory management
alias la='ls -a'
alias ll='ls -l'
alias lal='ls -al'
alias d='dirs -v'
alias 1='pu'
alias 2='pu -2'
alias 3='pu -3'
alias 4='pu -4'
alias 5='pu -5'
alias 6='pu -6'
alias 7='pu -7'
alias 8='pu -8'
alias 9='pu -9'
alias pu='() { pushd $1 &> /dev/null; dirs -v; }'
alias po='() { popd &> /dev/null; dirs -v; }'

zshaddhistory() { whence ${${(z)1}[1]} >| /dev/null || return 1 }

# ░█░█░█▀▀░█░█░█▀▄░▀█▀░█▀█░█▀▄░█▀▀
# ░█▀▄░█▀▀░░█░░█▀▄░░█░░█░█░█░█░▀▀█
# ░▀░▀░▀▀▀░░▀░░▀▀░░▀▀▀░▀░▀░▀▀░░▀▀▀

# Common CTRL bindings.
bindkey "^a" beginning-of-line
bindkey "^e" end-of-line
bindkey "^f" forward-word
bindkey "^b" backward-word
bindkey "^k" kill-line
bindkey "^d" delete-char
bindkey "^y" accept-and-hold
bindkey "^w" backward-kill-word
bindkey "^u" backward-kill-line
bindkey "^R" history-incremental-pattern-search-backward
bindkey "^F" history-incremental-pattern-search-forward

# Do not require a space when attempting to tab-complete.
bindkey "^i" expand-or-complete-prefix

# Fixes for alt-backspace and arrows keys
bindkey '^[^?' backward-kill-word
bindkey "^[[1;5C" forward-word
# bindkey "^[[C" forward-word
# bindkey "^[[D" backward-word

# ░█▀█░█░░░█░█░█▀▀░▀█▀░█▀█░█▀▀
# ░█▀▀░█░░░█░█░█░█░░█░░█░█░▀▀█
# ░▀░░░▀▀▀░▀▀▀░▀▀▀░▀▀▀░▀░▀░▀▀▀

# Check if zplug is installed
[ ! -d ~/.zplug ] && git clone https://github.com/zplug/zplug ~/.zplug
source ~/.zplug/init.zsh

# zplug
zplug 'zplug/zplug', hook-build:'zplug --self-manage'

# zsh-users
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "plugins/archlinux", from:oh-my-zsh, if:"which pacman"

zplug "plugins/adb", from:oh-my-zsh
zplug "plugins/common-aliases", from:oh-my-zsh
zplug "plugins/colored-man-pages", from:oh-my-zsh
zplug "plugins/colorize", from:oh-my-zsh
zplug "plugins/command-not-found", from:oh-my-zsh
zplug "plugins/copydir", from:oh-my-zsh
zplug "plugins/copyfile", from:oh-my-zsh
zplug "plugins/cp", from:oh-my-zsh
zplug "plugins/dircycle", from:oh-my-zsh
zplug "plugins/extract", from:oh-my-zsh
zplug "plugins/history", from:oh-my-zsh
zplug "plugins/nmap",   from:oh-my-zsh
zplug "plugins/tmux", from:oh-my-zsh
zplug "plugins/tmuxinator", from:oh-my-zsh
zplug "plugins/urltools", from:oh-my-zsh
zplug "plugins/web-search", from:oh-my-zsh
zplug "plugins/z", from:oh-my-zsh
zplug "plugins/git", from:oh-my-zsh
zplug "plugins/pip", from:oh-my-zsh
zplug "plugins/sudo", from:oh-my-zsh

# Enhanced cd
zplug "b4b4r07/enhancd", use:enhancd.sh

# Enhanced dir list with git features
zplug "supercrabtree/k"

zplug "hlissner/zsh-autopair", defer:2

# Jump back to parent directory
zplug "tarrasch/zsh-bd"

# Simple zsh calculator
zplug "arzzen/calc.plugin.zsh"

# Directory colors
zplug "seebi/dircolors-solarized", ignore:"*", as:plugin

# ░█▀▀░█▀█░█▄█░█▀█░█░░░█▀▀░▀█▀░▀█▀░█▀█░█▀█░█▀▀
# ░█░░░█░█░█░█░█▀▀░█░░░█▀▀░░█░░░█░░█░█░█░█░▀▀█
# ░▀▀▀░▀▀▀░▀░▀░▀░░░▀▀▀░▀▀▀░░▀░░▀▀▀░▀▀▀░▀░▀░▀▀▀

zstyle ':completion:*' rehash true
# zstyle ':completion:*' verbose yes
# zstyle ':completion:*:descriptions' format '%B%d%b'
# zstyle ':completion:*:messages' format '%d'
# zstyle ':completion:*:warnings' format 'No matches for: %d'
# zstyle ':completion:*' group-name ''

# Case-insensitive (all), partial-word and then substring completion
zstyle ":completion:*" matcher-list \
  "m:{a-zA-Z}={A-Za-z}" \
  "r:|[._-]=* r:|=*" \
  "l:|=* r:|=*"

zstyle ":completion:*:default" list-colors ${(s.:.)LS_COLORS}

# Load SSH and GPG agents via keychain.
setup_agents() {
	[[ $UID -eq 0 ]] && return

	if which keychain &> /dev/null; then
		local -a ssh_keys gpg_keys
		for i in ~/.ssh/**/*pub; do test -f "$i(.N:r)" && ssh_keys+=("$i(.N:r)"); done
			gpg_keys=$(gpg -K --with-colons 2>/dev/null | awk -F : '$1 == "sec" { print $5 }')
			if (( $#ssh_keys > 0 )) || (( $#gpg_keys > 0 )); then
				alias run_agents='() { $(whence -p keychain) --quiet --eval --inherit any-once --agents ssh,gpg $ssh_keys ${(f)gpg_keys} }'
				# [[ -t ${fd:-0} || -p /dev/stdin ]] && eval `run_agents`
			unalias run_agents
		fi
	fi
}

setup_agents
unfunction setup_agents

# Install plugins if there are plugins that have not been installed
if ! zplug check; then
	printf "Install plugins? [y/N]: "
	if read -q; then
		echo; zplug install
	fi
fi

# Then, source plugins and add commands to $PATH
zplug load

# dircolors
if zplug check "seebi/dircolors-solarized"; then
	if which gdircolors &> /dev/null; then
		alias dircolors='() { $(whence -p gdircolors) }'
	fi
	if which dircolors &> /dev/null;
	then
		scheme="dircolors.ansi-universal"
		eval $(dircolors ~/.zplug/repos/seebi/dircolors-solarized/$scheme)
	fi
fi

# history
if zplug check "zsh-users/zsh-history-substring-search";
then
	zmodload zsh/terminfo
	bindkey "$terminfo[kcuu1]" history-substring-search-up
	bindkey "$terminfo[kcud1]" history-substring-search-down
	bindkey "^[[1;5A" history-substring-search-up
	bindkey "^[[1;5B" history-substring-search-down
fi

# Source local zsh customizations.
[[ -f ~/.zsh_rclocal ]] && source ~/.zsh_rclocal

# Source functions and aliases.
[[ -f ~/.zsh_functions ]] && source ~/.zsh_functions
[[ -f ~/.zsh_aliases ]] && source ~/.zsh_aliases

# ░█░█░█▀▀░█▀▀░█▀▄░░░█▀▀░█░█░█▀█░█▀█░█▀▄░▀█▀░█▀▀
# ░█░█░▀▀█░█▀▀░█▀▄░░░█▀▀░▄▀▄░█▀▀░█░█░█▀▄░░█░░▀▀█
# ░▀▀▀░▀▀▀░▀▀▀░▀░▀░░░▀▀▀░▀░▀░▀░░░▀▀▀░▀░▀░░▀░░▀▀▀

export VISUAL="vim"
export EDITOR="$VISUAL"

if [[ "$TERM_EMULATOR" == *"kitty"* ]];
then
	export TERM="xterm-kitty"
else
	export TERM="xterm-256color"
fi

# ░█░█░█▀▀░█▀▀░█▀▄░░░█▀█░█░░░▀█▀░█▀█░█▀▀░█▀▀░█▀▀
# ░█░█░▀▀█░█▀▀░█▀▄░░░█▀█░█░░░░█░░█▀█░▀▀█░█▀▀░▀▀█
# ░▀▀▀░▀▀▀░▀▀▀░▀░▀░░░▀░▀░▀▀▀░▀▀▀░▀░▀░▀▀▀░▀▀▀░▀▀▀

alias ytmp3="youtube-dl --extract-audio --audio-format mp3"
alias cls="clear"

if [[ $term_emulator == *"kitty"* ]]; then
	alias clear="kitty icat --clear && clear"
fi

# ░█▀▀░█░█░▀█▀░█▀▄░█▀█░█▀▀
# ░█▀▀░▄▀▄░░█░░█▀▄░█▀█░▀▀█
# ░▀▀▀░▀░▀░░▀░░▀░▀░▀░▀░▀▀▀

# Tetris game
autoload -Uz tetriscurses

# ░█▀█░█▀█░█░█░█▀▀░█▀▄░█░░░█▀▀░█░█░█▀▀░█░░░▀█░░▄▀▄░█░█
# ░█▀▀░█░█░█▄█░█▀▀░█▀▄░█░░░█▀▀░▀▄▀░█▀▀░█░░░░█░░█//█░█▀▄
# ░▀░░░▀▀▀░▀░▀░▀▀▀░▀░▀░▀▀▀░▀▀▀░░▀░░▀▀▀░▀▀▀░▀▀▀░░▀░░▀░▀

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
