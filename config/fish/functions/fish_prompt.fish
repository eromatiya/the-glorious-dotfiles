function git_dirty
	echo (command git status -s --ignore-submodules=dirty ^/dev/null)
end

function background_normal
	# Prevents background color to "overflow"
	echo (set_color -b normal)
end

function distro_icon
	# TODO: Automatically detect distro and set its logo
	#  Tux
	#  Archlinux
	#  Debian
	#  Ubuntu
	#  Manjaro
	#  Centos
	#  Fedora
	#  Mint
	#  Alpine
	#  Devuan
	#  Apple
	#  Docker
	#  Opensuse
	#  Slackware
	#  Redhat
	#  Elementary
	#  Fire
	# Sauce: https://nerdfonts.com/cheat-sheet

	set icon '  '
	set prompt_distro (set_color -b $blue $white)$icon
	echo $prompt_distro
end

function interval
	math "abs($argv[1] - $argv[2])"
end

function get_time
	set sec (math "round("(date +%H)"*12 + "(date +%M)"/5)")
	set r (echo "obase=16; "(math (interval $sec 144)"+ 111") | bc)
	set g (echo "obase=16; "(math (interval (math "($sec + 96) % 288") 144 )"+ 111") | bc)
	set b (echo "obase=16; "(math (interval (math "($sec + 192) % 288") 144 )"+ 111") | bc)
	set bg $r$g$b
	set prompt_time (set_color -b $bg -o $black)' '(date +%H:%M)' '
	echo $prompt_time
end

function user_host
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
	set prompt_pwd (set_color -b $black -o $blue)' '(prompt_pwd)' '
	echo $prompt_pwd
end

function last_status
	if not test $prev_status -eq 0
		set_color $fish_color_error
		echo -n (set_color -b $red $yellow) '✖ '
	else
		echo -n (set_color -b $cyan $black) '✔ '
	end
	set_color normal
end

function fish_prompt
	set -g prev_status $status
	# # Check working directory
	# if test -w $PWD
	# 	# if has write permission
	# 	if [ (git_dirty) ]
	# 		# if git modified
	# 		set arrow_color $yellow
	# 	else
	# 		set arrow_color $white
	# 	end
	# else
	# 	set arrow_color $red
	# end

	# Window title
	switch $TERM;
		case xterm'*' vte'*';
			printf '\033]0;['(prompt_pwd)']\007';
		case screen'*';
 			printf '\033k['(prompt_pwd)']\033\\';
 	end

 	# Print prompt
	printf '%s%s%s%s ' (distro_icon) (user_host) (pwd_prompt) (background_normal) (__fish_git_prompt) (background_normal)
end

function fish_right_prompt
	# Print right prompt
	printf '%s%s' (background_normal)(last_status) (get_time)(background_normal)
end
