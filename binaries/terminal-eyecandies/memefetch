#!/usr/bin/env bash

# GENERAL

# set colors
f7=$'\e[37m'
f1=$'\e[31m'

# FUNCTIONS

# check if a command exists
exists() {
    command -v "$1" > /dev/null
}

# memed
memed() {
    echo "meme"
}

# not memed
not_memed() {
    echo "not a meme"
}

# look for pywal
check_wal() {
    if exists wal; then
        memed
    else
        not_memed
    fi
}

# look for i3-gaps
check_wm() {
   if exists i3; then
       if i3 -v | grep -q gaps; then
           memed
       else
           not_memed
       fi
   else
       not_memed
   fi
}

# look for polybar
check_bar() {
    if exists polybar; then
        memed
    else
        not_memed
    fi
}

# look for neofetch
check_fetch() {
   if exists neofetch; then
       memed
   else
       not_memed
   fi
}

# look for urxt and termite
check_term() {
    if exists urxvt || exists termite; then
        memed
    else
        not_memed
    fi
}

# look for plank
check_dock() {
    if exists plank; then
        memed
    else
        not_memed
    fi
}

# look for i3block-blur
check_lock() {
    if exists i3lock-blur; then
        memed
    else
        not_memed
    fi
}

# look for gnome
check_de() {
    if exists gnome-software; then
        memed
    else
        not_memed
    fi
}

# look for vim (best editor)
check_editor() {
    if exists vim || exists nvim; then
        not_memed
    else
        memed
    fi
}

# look for arch, void and gentoo
check_distro() {
    if [[ -f /etc/os-release ]]; then
        if grep -qiP '(arch|void|gentoo)' /etc/os-release; then
            memed
        else
            not_memed
        fi
    else
        not_memed
    fi
}

# look for oh-my-zsh
check_shell() {
    if [[ -d ${HOME}/.oh-my-zsh ]]; then
        memed
    else
        not_memed
    fi
}

# look for arc and numix themes
check_theme() {
    # gtk 2
    if [[ -f ${HOME}/.gtkrc-2.0 ]]; then
        if grep -qiP '(arc|numix)' "${HOME}/.gtkrc-2.0"; then
            memed
        else
            not_memed
        fi
    # gtk 3
    elif [[ -f ${HOME}/.config/gtk-3.0/settings.ini ]]; then
        if grep -qiP '(arc|numix)' "${HOME}/.config/gtk-3.0/settings.ini"; then
            memed
        else
            not_memed
        fi
    else
        not_memed
    fi
}

# OUTPUT

cat << EOF
             me                         ${f1}distro:${f7} $(check_distro)
         mememememe                     ${f1}colors:${f7} $(check_wal)
       memememememem                    ${f1}bar:${f7} $(check_bar)
      emememememememe                   ${f1}wm:${f7} $(check_wm)
     mememememememememememem            ${f1}fetch:${f7} $(check_fetch)
    emememememememememe  memem          ${f1}theme:${f7} $(check_theme)
   ememememememememememe   mememe       ${f1}term:${f7} $(check_term)
  mememememe     mememem     ememe      ${f1}shell:${f7} $(check_shell)
  memememe         mememe   mememe      ${f1}dock:${f7} $(check_dock)
 emememe            mememememememe      ${f1}lockscreen:${f7} $(check_lock)
 emememe           mememememememe       ${f1}de:${f7} $(check_de)
mememem       ememememememememe         ${f1}editor:${f7} $(check_editor)
mememe    memememememememem
emem ememememememem    emem
memem                    em
 eme                     me
EOF
