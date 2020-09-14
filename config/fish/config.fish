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
set -g __fish_git_prompt_showupstream informative
set -g __fish_git_prompt_showdirtystate yes
set -g __fish_git_prompt_char_stateseparator ' '
set -g __fish_git_prompt_char_cleanstate '✔'
set -g __fish_git_prompt_char_dirtystate '✚'
set -g __fish_git_prompt_char_invalidstate '✖'
set -g __fish_git_prompt_char_stagedstate '●'
set -g __fish_git_prompt_char_stashstate '⚑'
set -g __fish_git_prompt_char_untrackedfiles '?'
set -g __fish_git_prompt_char_upstream_ahead ''
set -g __fish_git_prompt_char_upstream_behind ''
set -g __fish_git_prompt_char_upstream_diverged 'ﱟ'
set -g __fish_git_prompt_char_upstream_equal ''
set -g __fish_git_prompt_char_upstream_prefix ''''

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

# Directory abbreviations
abbr -a -g l 'ls'
abbr -a -g la 'ls -a'
abbr -a -g ll 'ls -l'
abbr -a -g lal 'ls -al'
abbr -a -g d 'dirs'
abbr -a -g h 'cd $HOME'

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

# User abbreviations
abbr -a -g ytmp3 'youtube-dl --extract-audio --audio-format mp3'				# Convert/Download YT videos as mp3
abbr -a -g cls 'clear'																								# Clear
abbr -a -g h 'history'																								# Show history
abbr -a -g upd 'yay'																								# Update everything
abbr -a -g please 'sudo'																						# Polite way to sudo
abbr -a -g fucking 'sudo'																						# Rude way to sudo
abbr -a -g sayonara 'shutdown now'																	# Epic way to shutdown
abbr -a -g stahp 'shutdown now'																		# Panik - stonk man
abbr -a -g ar 'echo "awesome.restart()" | awesome-client'							# Reload AwesomeWM
abbr -a -g shinei 'kill -9'																						# Kill ala DIO
abbr -a -g kv 'kill -9 (pgrep vlc)'																			# Kill zombie vlc
abbr -a -g priv 'fish --private'																				# Fish incognito mode
abbr -a -g sshon 'sudo systemctl start sshd.service'										# Start ssh service
abbr -a -g sshoff 'sudo systemctl stop sshd.service'										# Stop ssh service
abbr -a -g untar 'tar -zxvf'																					# Untar
abbr -a -g genpass 'openssl rand -base64 20'													# Generate a random, 20-charactered password
abbr -a -g sha 'shasum -a 256'																			# Test checksum
abbr -a -g cn 'ping -c 5 8.8.8.8'																			# Ping google, checking network
abbr -a -g ipe 'curl ifconfig.co'																				# Get external IP address
abbr -a -g ips 'ip link show'																					# Get network interfaces information
abbr -a -g wloff 'rfkill block wlan'																			# Block wlan, killing wifi connection
abbr -a -g wlon 'rfkill unblock wlan'																		# Unblock wlan, start wifi connection
abbr -a -g ff 'firefox'																								# Launch firefox

# Source plugins
# Useful plugins: archlinux bang-bang cd colorman sudope vcs
if test -d "$HOME/.local/share/omf/pkg/colorman/"
	source ~/.local/share/omf/pkg/colorman/init.fish
end

# Make su launch fish
function su
   command su --shell=/usr/bin/fish $argv
end
