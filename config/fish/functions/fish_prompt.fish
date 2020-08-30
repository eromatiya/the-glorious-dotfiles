# ░░█░░▀▄░░░▄▀░▄▀░░▄▀░░▄▀░░▀░▀▄░░░░█▀█░█▀▄░█▀█░█▄█░█▀█░▀█▀
# ░░█░░░▄▀░▀▄░░█░░░█░░░█░░░░░░▄▀░░░█▀▀░█▀▄░█░█░█░█░█▀▀░░█░
# ░░▀░░▀░░░░░▀░░▀░░░▀░░░▀░░░░▀░░░░░▀░░░▀░▀░▀▀▀░▀░▀░▀░░░░▀░
#
# Prompt made by manilarome

# ░█░█░█▀▀░█░░░█▀█░█▀▀░█▀▄░█▀▀
# ░█▀█░█▀▀░█░░░█▀▀░█▀▀░█▀▄░▀▀█
# ░▀░▀░▀▀▀░▀▀▀░▀░░░▀▀▀░▀░▀░▀▀▀

# Is git dirty?
function _git_dirty
	echo (command git status -s --ignore-submodules=dirty ^/dev/null)
end

# Is PWD a git directory?
function _git_directory
	if git rev-parse --git-dir > /dev/null 2>&1
		echo 0
	end
end

# Set git status color
function _git_status
	if [ (_git_directory) ]
		# Check if dirty
		if [ (_git_dirty) ]
			set git_color yellow
		else
			set git_color green
		end
	else
		set git_color white
	end
	echo $git_color
end

# Set time background color
function _time_bg
	set hour (date +%H)
	if test $hour -ge 6 && test $hour -lt 12
		echo brblue
	else if test $hour -ge 12 && test $hour -lt 18
		echo brgreen
	else
		echo brblack	
	end
end

# Set time foreground color
function _time_fg
	set hour (date +%H)
	if test $hour -ge 6 && test $hour -lt 12
		echo black
	else if test $hour -ge 12 && test $hour -lt 18
		echo black
	else
		echo white	
	end
end

# OS type
function _os_type
	set os_type ($SHELL -c "echo \$OSTYPE")
	echo $os_type
end

# Distro name
function _distro_name
	set distro_name (find /etc/ -maxdepth 1 -name '*release' 2> /dev/null |
		sed 's/\/etc\///' | sed 's/-release//' | head -1)
	set distro_name (string lower $distro_name)
	echo $distro_name
end

# Distro icon
function _distro_icon
	switch (_distro_name)
		case '*'arch'*'
			set icon '  '
		case '*'debian'*'
			set icon '  '
		case '*'ubuntu'*'
			set icon '  '
		case '*'manjaro'*'
			set icon '  '
		case '*'centos'*'
			set icon '  '
		case '*'fedora'*'
			set icon '  '
		case '*'mint'*'
			set icon '  '
		case '*'alpine'*'
			set icon '  '
		case '*'devuan'*'
			set icon '  '
		case '*'opensuse'*'
			set icon '  '
		case '*'slackware'*'
			set icon '  '
		case '*'redhat'*'
			set icon '  '
		case '*'elementary'*'
			set icon '  '
		case "*"
			set icon '  '
	end
	echo $icon
end

# OS icon
function _os_icon
	# Icons sauce: https://nerdfonts.com/cheat-sheet
	switch (_os_type)
		case linux-gnu
			set icon (_distro_icon)
		case darwin
			set icon '  '
		case msys win32
			set icon '  '
		case freebsd
			set icon '  '
		case "*"
			set icon '  '
	end
	echo $icon
end

# ░█▀█░█▀▄░█▀█░█▄█░█▀█░▀█▀░█▀▀
# ░█▀▀░█▀▄░█░█░█░█░█▀▀░░█░░▀▀█
# ░▀░░░▀░▀░▀▀▀░▀░▀░▀░░░░▀░░▀▀▀

# SSH Prompt
function _ssh_prompt
	set prompt
	if set -q SSH_TTY
		set prompt (set_color -b bryellow -o black)' SSH '
	end
	echo $prompt
end

# Distro prompt
function _distro_prompt
	set prompt_distro (set_color -b blue white)(_os_icon)
	echo $prompt_distro
end

# Time prompt
function _time_prompt
	set prompt_time (set_color -b (_time_bg) -o (_time_fg))' '(date +%H:%M)' '
	echo $prompt_time
end

# user@host prompt
function _user_host_prompt
	set -l user_hostname $USER@(prompt_hostname)
	if [ $USER = 'root' ]
		set user_bg red
	else if [ $USER != (logname) ]
		set user_bg yellow
	else
		set user_bg white
	end
	
	# If we're running via SSH.
	if set -q SSH_TTY
		set user_bg brblack
		set user_hostname (set_color -o brblue)$USER(set_color -o brred)@(set_color -o brgreen)(prompt_hostname)
	end

	set prompt_user (set_color -b $user_bg -o black)' '$user_hostname' '
	echo $prompt_user
end

# PWD prompt
function _pwd_prompt
	# Check working directory if writable
	if test -w $PWD
		set pwd_color (_git_status)
	else
		set pwd_color red
	end
	set prompt_pwd (set_color -b black -o $pwd_color)' '(prompt_pwd)' '
	echo $prompt_pwd
end

# Status prompt
function _status_prompt
	if not test $prev_status -eq 0
		set_color $fish_color_error
		echo -n (set_color -b red yellow) '✘ '
	else
		echo -n (set_color -b black green) '✔ '
	end
	set_color normal
end

function _git_prompt
	if [ (__fish_git_prompt) ]
		set git_bg (_git_status)
		set prompt (__fish_git_prompt) ' '
	else
		set git_bg normal
		set prompt (__fish_git_prompt)
	end
	echo (set_color -b $git_bg -o black) $prompt
end

function _private_prompt
	if  not test -z $fish_private_mode
		set prompt (set_color -b black white) '﫸'
	else
		set prompt
	end
	echo $prompt
end

# ░█░░░█▀▀░█▀▀░▀█▀░░░░░█░█░█▀█░█▀█░█▀▄░░░█▀█░█▀▄░█▀█░█▄█░█▀█░▀█▀
# ░█░░░█▀▀░█▀▀░░█░░▄▄▄░█▀█░█▀█░█░█░█░█░░░█▀▀░█▀▄░█░█░█░█░█▀▀░░█░
# ░▀▀▀░▀▀▀░▀░░░░▀░░░░░░▀░▀░▀░▀░▀░▀░▀▀░░░░▀░░░▀░▀░▀▀▀░▀░▀░▀░░░░▀░

# Left-hand prompt
function fish_prompt
	set -g prev_status $status

	# Window title
	switch $TERM;
		case xterm'*' vte'*';
			printf '\033]0;[ '(prompt_pwd)' ]\007';
		case screen'*';
 			printf '\033k[ '(prompt_pwd)' ]\033\\';
 	end

 	# Print right-hand prompt
	printf '%s%s%s%s%s ' (_distro_prompt) (_ssh_prompt) (_user_host_prompt) (_pwd_prompt) (set_color normal)
end

# ░█▀▄░▀█▀░█▀▀░█░█░▀█▀░░░░░█░█░█▀█░█▀█░█▀▄░░░█▀█░█▀▄░█▀█░█▄█░█▀█░▀█▀
# ░█▀▄░░█░░█░█░█▀█░░█░░▄▄▄░█▀█░█▀█░█░█░█░█░░░█▀▀░█▀▄░█░█░█░█░█▀▀░░█░
# ░▀░▀░▀▀▀░▀▀▀░▀░▀░░▀░░░░░░▀░▀░▀░▀░▀░▀░▀▀░░░░▀░░░▀░▀░▀▀▀░▀░▀░▀░░░░▀░

# Right-hand prompt
function fish_right_prompt
	printf '%s%s%s%s%s' (_status_prompt) (_git_prompt) (_time_prompt) (_private_prompt)
	set_color normal
end
