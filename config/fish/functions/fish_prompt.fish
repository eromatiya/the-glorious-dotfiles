# ░▀▄░░░▄▀░▄▀░░▄▀░░▄▀░░▀░▀▄░░░░█▀█░█▀▄░█▀█░█▄█░█▀█░▀█▀
# ░░▄▀░▀▄░░█░░░█░░░█░░░░░░▄▀░░░█▀▀░█▀▄░█░█░█░█░█▀▀░░█░
# ░▀░░░░░▀░░▀░░░▀░░░▀░░░░▀░░░░░▀░░░▀░▀░▀▀▀░▀░▀░▀░░░░▀░
#
# Prompt made by manilarome
# Inspired by pastfish

function git_dirty
	echo (command git status -s --ignore-submodules=dirty ^/dev/null)
end

function git_directory
	if test -d .git
		echo true
	end
end

function background_normal
	# Prevents background color to "overflow".
	# A bit of a hack, but hey, it works. PR for improvement.
	echo (set_color -b normal)
end

function distro_prompt
	#  Tux
	# Sauce: https://nerdfonts.com/cheat-sheet

	# Get distro, tested only on Archlinux
	set distro_name (find /etc/ -maxdepth 1 -name '*release' 2> /dev/null |
		sed 's/\/etc\///' | sed 's/-release//' | head -1)
	set distro_name (string lower $distro_name)

	switch "$distro_name"
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

	set prompt_distro (set_color -b $blue $white)$icon
	echo $prompt_distro
end


function time_prompt
	function interval
		math "abs($argv[1] - $argv[2])"
	end
	switch $TERM;
		case 256'*' '*'kitty'*';
			set min_today (math "round("(date +%H)"*12 + "(date +%M)"/5)")
			set color_r (echo "obase=16; "(math (interval $min_today 144)"+ 111") | bc)
			set color_g (echo "obase=16; "(math (interval (math "($min_today + 96) % 288") 144 )"+ 111") | bc)
			set color_b (echo "obase=16; "(math (interval (math "($min_today + 192) % 288") 144 )"+ 111") | bc)
			set rgb $color_r$color_g$color_b
		case '*';
 			set rgb $green
 	end
	set prompt_time (set_color -b $rgb -o $black)' '(date +%H:%M)' '
	echo $prompt_time
end

function user_host_prompt
	# User is root.
	if [ $USER = 'root' ]
		set -g user_bg $red
	else if [ $USER != (logname) ]
		# User is not login user.
		set -g user_bg $yellow
	else
		set -g user_bg $white
	end
	set prompt_user (set_color -b $user_bg -o black)' '(whoami)@(hostname)' '

	# Connected on remote machine, via ssh (good).
	if [ $SSH_CONNECTION ]
		set prompt_user  $prompt_user(set_color -b $cyan -o black)' '(hostname)' '
	end
	echo $prompt_user
end

function git_prompt
	set prompt_git (set_color -b normal)(fish_git_prompt)
	echo $prompt_git
end

function pwd_prompt
	# Check working directory if writable
	if test -w $PWD
		# Check if git directory
		if [ (git_directory) ]
			# Check if dirty
			if [ (git_dirty) ]
				set pwd_color $yellow
			else
				set pwd_color $green
			end
		else
			set pwd_color $white
		end
	else
		set pwd_color $red
	end
	set prompt_pwd (set_color -b $black -o $pwd_color)' '(prompt_pwd)' '
	echo $prompt_pwd
end

function status_prompt
	if not test $prev_status -eq 0
		set_color $fish_color_error
		echo -n (set_color -b $red $yellow) '✖ '
	else
		echo -n (set_color -b $black $green) '✔ '
	end
	set_color normal
end

function fish_prompt
	set -g prev_status $status

	# Window title
	switch $TERM;
		case xterm'*' vte'*';
			printf '\033]0;[ '(prompt_pwd)' ]\007';
		case screen'*';
 			printf '\033k[ '(prompt_pwd)' ]\033\\';
 	end

 	# Print prompt
	printf '%s%s%s%s ' (distro_prompt) (user_host_prompt) (pwd_prompt) (background_normal) (__fish_git_prompt) (background_normal)
end

function fish_right_prompt
	# Print right prompt
	printf '%s%s%s%s' (background_normal)(status_prompt) (time_prompt)(background_normal)
end
