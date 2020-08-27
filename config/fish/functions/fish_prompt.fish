
function _is_git_dirty
  echo (command git status -s --ignore-submodules=dirty ^/dev/null)
end

function _inteval
  math "abs($argv[1] - $argv[2])"
end

function fish_prompt

  # if has cache
  if not [ $staticPrompt ]
    # Test user type:
    if [ $USER = "root" ]
        # User is root.
        set color "red"
    else if [ $USER != (logname) ]
        # User is not login user.
        set color "yellow"
    else
        # User is normal (well ... most of us are).
        set color "white"
    end

    set promptTmp (set_color -b $color -o black)' '$USER' '

    # if is SSH type:
    if [ $SSH_CONNECTION ]
        # Connected on remote machine, via ssh (good).
        set color "blue"
        set promptTmp  $promptTmp(set_color -b $color -o black)' '(hostname)' '
    end

    # save result to cache
    set -g staticPrompt $promptTmp
    set -g staticColor $color
  else # grab cache
    set promptTmp $staticPrompt
    set color $staticColor
  end

  # determine color of time
  switch $TERM
    case '*'256'*' # support 256color
      set minToday (math "round("(date +%H)"*12 + "(date +%M)"/5)")
      set color_R (echo "obase=16; "(math (_inteval $minToday 144)"+ 111") | bc)
      set color_G (echo "obase=16; "(math (_inteval (math "($minToday + 96) % 288") 144 )"+ 111") | bc)
      set color_B (echo "obase=16; "(math (_inteval (math "($minToday + 192) % 288") 144 )"+ 111") | bc)
      set color $color_R$color_G$color_B
    case '*' # not support 256color
      set color "#92B6F4"
  end

  # for debugging
  # echo $color
  # set color "cyan"

  # time with color
  set promptTmp $promptTmp(set_color -b $color -o black)' '(date +%H:%M)' '

  # test current working directory
  if test -w $PWD # if has write permission
    if [ (_is_git_dirty) ] # if git modified
      set posColor yellow
    else
      set posColor white
    end
  else
    set posColor red
  end

  # PWD
  set promptTmp $promptTmp(set_color -b black -o $color)' '(prompt_pwd)' '(set_color -b normal $posColor)' > '

  # ========================================
  # tmux, screen title
  switch $TERM;
    case xterm'*' vte'*';
      printf '\033]0;['(prompt_pwd)']\007';
    case screen'*';
      printf '\033k['(prompt_pwd)']\033\\';
  end
  # ========================================

  # output
  echo $promptTmp
end
