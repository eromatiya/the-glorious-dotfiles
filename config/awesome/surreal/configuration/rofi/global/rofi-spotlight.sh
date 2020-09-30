#!/usr/bin/env bash

TMP_DIR="/tmp/rofi/${USER}/"

PREV_LOC_FILE="${TMP_DIR}rofi_fb_prevloc"
CURRENT_FILE="${TMP_DIR}rofi_fb_current_file"

MY_PATH="$(realpath "$0" | xargs dirname)"
HIST_FILE="${MY_PATH}/history.txt"

OPENER=xdg-open
TERM_EMU=kitty
TEXT_EDITOR=$EDITOR
FILE_MANAGER=xdg-open
BLUETOOTH_SEND=blueman-sendto

CUR_DIR=$PWD
NEXT_DIR=""
FD_INSTALLED=$(command -v fd)

SHOW_HIDDEN=false

# Setup menu options
declare -a OPEN_FILE_LOCATION=(
	"Open file location in ${TERM_EMU}"
	"Open file location in ${FILE_MANAGER}"
)
declare -a RUN_COMMANDS=(
	"Run"
	"Execute in ${TERM_EMU}"
)
declare -a STANDARD_CONTROLS=(
	"Move to trash"
	"Delete"
	"Back"
)
declare -a SHELL_NO_X_OPTIONS=(
	"Edit"
	"${OPEN_FILE_LOCATION[@]}"
    "${STANDARD_CONTROLS[@]}"
)
declare -a SHELL_OPTIONS=(
    "${RUN_COMMANDS[@]}"
    "${SHELL_NO_X_OPTIONS[@]}"
)
declare -a BIN_NO_X_OPTIONS=(
	"${OPEN_FILE_LOCATION[@]}"
	"Back"
)
declare -a BIN_OPTIONS=(
    "${RUN_COMMANDS[@]}"
    "${BIN_NO_X_OPTIONS[@]}"
)
declare -a TEXT_OPTIONS=("${SHELL_NO_X_OPTIONS[@]}")
declare -a HTML_OPTIONS=(
	"Open"
	"Edit"
	"${OPEN_FILE_LOCATION[@]}"
    "${STANDARD_CONTROLS[@]}"
)
declare -a XCF_SVG_OPTIONS=(
	"Open"
	"${OPEN_FILE_LOCATION[@]}"
    "${STANDARD_CONTROLS[@]}"
)
declare -a IMAGE_OPTIONS=(
	"Open"
	"Send via Bluetooth"
	"${OPEN_FILE_LOCATION[@]}"
    "${STANDARD_CONTROLS[@]}"
)

declare -a ALL_OPTIONS=()

# Combine all context menu
COMBINED_OPTIONS=(
	"${SHELL_OPTIONS[@]}"
	"${IMAGE_OPTIONS[@]}"
)

# Remove duplicates
ALL_OPTIONS=("$(printf '%s\n' "${COMBINED_OPTIONS[@]}" | sort -u)")

# Create tmp dir for rofi
[ ! -d "${TMP_DIR}" ] && mkdir -p "${TMP_DIR}";

# Create hist file if it doesn't exist
[ ! -f "${HIST_FILE}" ] && touch "${HIST_FILE}"

# Help message
if [ -n "$*" ] && [[ "$*" = ":help" ]]
then
    echo -en "Rofi Spotlight
A Rofi with file and web searching functionality
 
Commands:
:help to print this help message
:h or :hidden to show hidden files/dirs
:sh or :show_hist to show search history
:ch or :clear_hist to clear search history
:xdg to jump to an xdg directory
Examples:
	:xdg DOCUMENTS
	:xdg DOWNLOADS
Also supports incomplete path:
Examples:
	:xdg doc
	:xdg down
For more info about XDG dirs, see:
\`man xdg-user-dir\`
 
File search syntaxes:
!<search_query> to search for a file and web suggestions
?<search_query> to search parent directories
Examples:
	!half-life 3
 	?portal 3
 
Web search syntaxes:
!<search_query> to gets search suggestions
:web/:w <search_query> to also to gets search suggestions
:webbro/:wb <search_query> to search directly from your browser
Examples:
	!how to install archlinux
	:web how to install gentoo
	:w how to make a nuclear fission
	:webbro how to install wine in windowsxp
Back\0icon\x1fdraw-arrow-back\n"

	exit
fi

# Return the icon string
function icon_file_type(){
	icon_name=""
	mime_type=$(file --mime-type -b "${1}")

	case "${mime_type}" in
		"inode/directory")
			case "${1}" in
				"Desktop/" )
					icon_name='folder-blue-desktop'
					;;
				"Documents/" )
					icon_name='folder-blue-documents'
					;;
				"Downloads/" )
					icon_name='folder-blue-downloads'
					;;
				"Music/" )
					icon_name='folder-blue-music'
					;;
				"Pictures/" )
					icon_name='folder-blue-pictures'
					;;
				"Public/" )
					icon_name='folder-blue-public'
					;;
				"Templates/" )
					icon_name='folder-blue-templates'
					;;
				"Videos/" )
					icon_name='folder-blue-videos'
					;;
				"root/" )
					icon_name='folder-root'
					;;
				"home/" | "${USER}/")
					icon_name='folder-home'
					;;
				*"$" )
					icon_name='folder-blue'
					;;
				*)
					icon_name='folder-blue'
					;;
			esac
		;;
		"inode/symlink" )
			icon_name='inode-symlink'
			;;
		"audio/flac" | "audio/mpeg" )
			icon_name='music'
			;;
		"video/mp4" )
			icon_name='video-mp4'
			;;
		"video/x-matroska" )
			icon_name=video-x-matroska
			;;
		"image/x-xcf" )
			# notify-send '123'
			icon_name='image-x-xcf'
			;;
		"image/jpeg" | "image/png" | "image/svg+xml")
			icon_name="${CUR_DIR}/${1}"
			;;
		"image/gif" )
			icon_name='gif'
			;;
		"image/vnd.adobe.photoshop" )
			icon_name='image-vnd.adobe.photoshop'
			;;
		"image/webp" )
			icon_name='gif'
			;;
		"application/x-pie-executable" )
			icon_name='binary'
			;;
		"application/pdf" )
			icon_name='pdf'
			;;
		"application/zip" )
			icon_name='application-zip'
			;;
		"application/x-xz" ) 
			icon_name='application-x-xz-compressed-tar'
			;;
		"application/x-7z-compressed" )
			icon_name='application-x-7zip'
			;;
		"application/x-rar" )
			icon_name='application-x-rar'
			;;
		"application/octet-stream" | "application/x-iso9660-image" )
			icon_name='application-x-iso'
			;;
		"application/x-dosexec" )
			icon_name='application-x-ms-dos-executable'
			;;
		"text/plain" )
			icon_name='application-text'
			;;
		"text/x-shellscript" )
			icon_name='application-x-shellscript'
			;;
		"text/html" )
			icon_name='text-html'
			;;
		"font/sfnt" | "application/vnd.ms-opentype" )
			icon_name='application-x-font-ttf'
			;;
		* )
			case "${1}" in
				*."docx" | *".doc" )
					icon_name='application-msword'
					;;
				*."apk" )
					icon_name='android-package-archive'
					;;
				* )
					icon_name='unknown'
					;;
			esac
			;;
	esac

	echo -en "$1\0icon\x1f$icon_name\n"
}

export -f icon_file_type

# Pass the argument to python script
function web_search() {
	# Pass the search query to web-search script
	"${MY_PATH}/web-search.py" "${1}"
	exit;
}

# Handles the web search method
if [ ! -z "$@" ] && ([[ "$@" == ":webbro"* ]] || [[ "$@" == ":wb"* ]])
then
	remove=''
	[[ "$*" = ":webbro"* ]] && remove=":webbro" || remove=":wb"

	# Search directly from your web browser
	web_search "$(printf '%s\n' "${1//$remove/}")"
	exit;

elif [ ! -z "$@" ] && ([[ "$@" == ":web"* ]] || [[ "$@" == ":w"* ]])
then
	remove=''
	[[ "$*" = ":web"* ]] && remove=":web" || remove=":w"

	# Get search suggestions
	web_search "!$(printf '%s\n' "${1//$remove/}")"
	exit;
fi

function find_query() {
	QUERY=${1}
	if [[ ! "${QUERY}" =~ ( |\') ]]
	then
		if [ -z "$FD_INSTALLED" ];
		then
			find "${HOME}" -iname *"${QUERY}"* | sed "s/\/home\/$USER/\~/" |
				awk -v MY_PATH="${MY_PATH}" '{print $0"\0icon\x1f"MY_PATH"/icons/result.svg\n"}'
		else
			fd -H ${QUERY} ${HOME} | sed "s/\/home\/$USER/\~/" |
				awk -v MY_PATH="${MY_PATH}" '{print $0"\0icon\x1f"MY_PATH"/icons/result.svg\n"}'
		fi
	fi
}

# File and calls to the web search
if [ ! -z "$@" ] && ([[ "$@" == ?(\~)/* ]] || [[ "$@" == \?* ]] || [[ "$@" == \!* ]])
then
	QUERY=$@

	echo "${QUERY}" >> "${HIST_FILE}"

	if [[ "$@" == ?(\~)/* ]]
	then
		[[ "$*" = \~* ]] && QUERY="${QUERY//"~"/"$HOME"}"

		coproc ${OPENER} "${QUERY}" > /dev/null 2>&1
		exec 1>&-
		exit

	elif [[ "$@" == \?* ]]
	then
		find_query ${QUERY#\?}	

	else
		# Find the file
		find_query ${QUERY#!}

		# Web search
		web_search "! ${QUERY#!}"
	fi
	exit;
fi

# Create notification if there's an error
function create_notification() {
    case "${1}" in
        "denied" )
		    notify-send -a "Global Search" "Permission denied!" \
		    'You have no permission to access '"${CUR_DIR}!"
            ;;
        "deleted" )
		    notify-send -a "Global Search" "Success!" \
		    'File deleted!'
            ;;
        "trashed" )
		    notify-send -a "Global Search" "Success!" \
		    'The file has been moved to trash!'	
            ;;
        "cleared" )
		    notify-send -a "Global Search" "Success!" \
		    'Search history has been successfully cleared!'
            ;;
        * )
		    notify-send -a "Global Search" "Somethings wrong I can feel it!" \
		    'This incident will be reported!'
            ;;
    esac
}

# Show the files in the current directory
function navigate_to() {
	# process current dir.
	if [ -n "${CUR_DIR}" ]
	then
		CUR_DIR=$(readlink -e "${CUR_DIR}")
		if [ ! -d "${CUR_DIR}" ] || [ ! -r "${CUR_DIR}" ]
		then
			create_notification "denied"
			CUR_DIR=$(realpath ${CUR_DIR} | xargs dirname)
			echo "${CUR_DIR}" > "${PREV_LOC_FILE}"
		else
			echo "${CUR_DIR}/" > "${PREV_LOC_FILE}"
		fi
		pushd "${CUR_DIR}" >/dev/null || exit
	fi

	printf "..\0icon\x1fup\n"

	if [[ -z "$FD_INSTALLED" ]]
	then
		#Group directories
		if [[ ${SHOW_HIDDEN} == true ]]
		then
			for i in .*/
			do
				[[ -d "${i}" ]] && ([[ "${i}" != "./" ]] && [[ "${i}" != "../"* ]]) && icon_file_type "${i}"
			done
		fi
		for i in */
		do 
			[[ -d "${i}" ]] && icon_file_type "${i}"
		done
		#Group files
		if [[ ${SHOW_HIDDEN} = true ]]
		then
			for i in .*
			do 
				[[ -f "${i}" ]] && icon_file_type "${i}"
			done
		fi
		for i in *
		do 
			[[ -f "${i}" ]] && icon_file_type "${i}"
		done
	else
		THREADS=$(getconf _NPROCESSORS_ONLN)
		export CUR_DIR
		if [[ ${SHOW_HIDDEN} == true ]]
		then
			fd -Ht d -d 1 -x bash -c 'icon_file_type "$1/"' _ {} \ | sort -V --parallel=$THREADS 
			fd -Ht f -d 1 -x bash -c 'icon_file_type "$1"' _ {} \ | sort -V --parallel=$THREADS
		else
			fd -t d -d 1 -x bash -c 'icon_file_type "$1/"' _ {} \ | sort -V --parallel=$THREADS 
			fd -t f -d 1 -x bash -c 'icon_file_type "$1"' _ {} \ | sort -V --parallel=$THREADS
		fi
	fi	
}

# Set XDG dir
function return_xdg_dir() {
	target_dir=${1^^}

	if [[ "HOME" == *"${target_dir}"* ]]
	then
		CUR_DIR=$(xdg-user-dir)
	
	elif [[ "DESKTOP" == *"${target_dir}"* ]]
		then
		CUR_DIR=$(xdg-user-dir DESKTOP)
	
	elif [[ "DOCUMENTS" == *"${target_dir}"* ]]
		then
		CUR_DIR=$(xdg-user-dir DOCUMENTS)
	
	elif [[ "DOWNLOADS" == *"${target_dir}"* ]]
		then
		CUR_DIR=$(xdg-user-dir DOWNLOAD)
	
	elif [[ "MUSIC" == *"${target_dir}"* ]]
		then
		CUR_DIR=$(xdg-user-dir MUSIC)
	
	elif [[ "PICTURES" == *"${target_dir}"* ]]
		then
		CUR_DIR=$(xdg-user-dir PICTURES)
	
	elif [[ "PUBLICSHARE" == *"${target_dir}"* ]]
		then
		CUR_DIR=$(xdg-user-dir PUBLICSHARE)
	
	elif [[ "TEMPLATES" == *"${target_dir}"* ]]
		then
		CUR_DIR=$(xdg-user-dir TEMPLATES)
	
	elif [[ "VIDEOS" == *"${target_dir}"* ]]
		then
		CUR_DIR=$(xdg-user-dir VIDEOS)
	
	elif [[ "ROOT" == *"${target_dir}"* ]]
		then
		CUR_DIR="/"
	
	else
		CUR_DIR="${HOME}"
	fi
	navigate_to
	exit;
}

# Show and Clear History
if [ ! -z "$@" ] && ([[ "$@" == ":sh" ]] || [[ "$@" == ":show_hist" ]])
then
	hist=$(tac "${HIST_FILE}")

    echo -en "Back\0icon\x1fdraw-arrow-back\n"
	[ -z "${hist}" ] && echo -en "No History Yet\0icon\x1ftext-plain\n"

	while IFS= read -r line; 
	do 
		echo -en "${line}\0icon\x1f${MY_PATH}/icons/history.svg\n"; 
	done <<< "${hist}"
	
	exit;
elif [ ! -z "$@" ] && ([[ "$@" == ":ch" ]] || [[ "$@" == ":clear_hist" ]])
then
	:> "${HIST_FILE}"
	create_notification "cleared"

	CUR_DIR="${HOME}"
	navigate_to
	exit;
fi

# Accepts XDG command
if [[ ! -z "$@" ]] && [[ "$@" == ":xdg"* ]]
then
	NEXT_DIR=${*//":xdg "/}

	[[ -n "$NEXT_DIR" ]] && return_xdg_dir "${NEXT_DIR}" || return_xdg_dir "${HOME}"
fi

# Read last location, otherwise we default to PWD.
[ -f "${PREV_LOC_FILE}" ] && CUR_DIR=$(< "${PREV_LOC_FILE}")

if [[ ! -z "$@" ]] && ([[ "$@" == ":h" ]] || [[ "$@" == ":hidden" ]])
then
	SHOW_HIDDEN=true
	navigate_to
	exit;
fi

# Handle argument.
[ -n "$*" ] && CUR_DIR="${CUR_DIR}/$*"

# Context Menu
if [ -n "$*" ] && [[ "${ALL_OPTIONS[*]} " = *"$*"* ]]
then
	case "${1}" in
		"Run" )
			coproc ( eval "$(< ${CURRENT_FILE})" & > /dev/null 2>&1 )
			kill -9 $(pgrep rofi)
			;;
		"Execute in ${TERM_EMU}" )
			coproc ( eval "${TERM_EMU} \"$(< ${CURRENT_FILE})\"" & > /dev/null 2>&1 )
			kill -9 $(pgrep rofi)
			;;
		"Open" )
			coproc ( eval "${OPENER} \"$(< ${CURRENT_FILE})\"" & > /dev/null 2>&1 )
			kill -9 $(pgrep rofi)
			;;
		"Open file location in ${TERM_EMU}" )
			file_path="$(< ${CURRENT_FILE})"
			coproc ( ${TERM_EMU} bash -c "cd ${file_path%/*} ; ${SHELL}" & > /dev/null 2>&1 )
			kill -9 $(pgrep rofi)
			;;
		"Open file location in ${FILE_MANAGER}" )
			file_path="$(< "${CURRENT_FILE}")"
			coproc ( eval "${FILE_MANAGER} "${file_path%/*}"" & > /dev/null 2>&1 )
			kill -9 $(pgrep rofi)
			;;
		"Edit" )
			coproc ( eval "${TERM_EMU} ${TEXT_EDITOR} \"$(< ${CURRENT_FILE})\"" & > /dev/null 2>&1 )
			kill -9 $(pgrep rofi)
			;;
		"Move to trash" )
			coproc( gio trash "$(< ${CURRENT_FILE})" & > /dev/null 2>&1 )
			create_notification "trashed"
			CUR_DIR="$(dirname "$(< ${CURRENT_FILE})")"
			navigate_to
			;;
		"Delete" )
			shred "$(< ${CURRENT_FILE})"
			rm "$(< ${CURRENT_FILE})"
			create_notification "deleted"
			CUR_DIR="$(dirname "$(< ${CURRENT_FILE})")"
			navigate_to
			;;
		"Send via Bluetooth" )
			rfkill unblock bluetooth &&	bluetoothctl power on 
			sleep 1
			blueman-sendto "$(< ${CURRENT_FILE})" & > /dev/null 2>&1
			kill -9 $(pgrep rofi)
			;;
		"Back" )
			CUR_DIR="$(< ${PREV_LOC_FILE})"
			navigate_to
			;;
	esac
	exit;
fi

function context_menu_icons() {

	if [[ "${1}" == "Run" ]]
	then
		echo '\0icon\x1fsystem-run\n'

	elif [[ "${1}" == "Execute in ${TERM_EMU}" ]]
	then
		echo "\0icon\x1f${TERM_EMU}\n"

	elif [[ "${1}" == "Open" ]]
	then
		echo "\0icon\x1futilities-x-terminal\n"

	elif [[ "${1}" == "Open file location in ${TERM_EMU}" ]]
	then
		echo "\0icon\x1f${TERM_EMU}\n"

	elif [[ "${1}" == "Open file location in ${FILE_MANAGER}" ]]
	then
		echo "\0icon\x1fblue-folder-open\n"

	elif [[ "${1}" == "Edit" ]]
	then
		echo "\0icon\x1faccessories-text-editor\n"

	elif [[ "${1}" == "Move to trash" ]]
	then
		echo "\0icon\x1fapplication-x-trash\n"

	elif [[ "${1}" == "Delete" ]]
	then
		echo "\0icon\x1findicator-trashindicator\n"

	elif [[ "${1}" == "Send via Bluetooth" ]]
	then
		echo "\0icon\x1fbluetooth\n"

	elif [[ "${1}" == "Back" ]]
	then
		echo "\0icon\x1fback\n"
	fi
}

function print_context_menu() {
	declare -a arg_arr=("${!1}")
	
	for menu in "${arg_arr[@]}"
	do
		printf "$menu$(context_menu_icons "${menu}")\n"
	done
}

function context_menu() {

	type="$(file --mime-type -b "${CUR_DIR}")"
	
	if [ -w "${CUR_DIR}" ] && [[ "${type}" == "text/x-shellscript" ]]
	then
		if [ -x "${CUR_DIR}" ];
		then
			print_context_menu SHELL_OPTIONS[@]
		else
			print_context_menu SHELL_NO_X_OPTIONS[@]
		fi

	elif [[ "${type}" == "application/x-executable" ]] || [[ "${type}" == "application/x-pie-executable" ]]
	then
		if [ -x "${CUR_DIR}" ]
		then
			print_context_menu BIN_OPTIONS[@]
		else
			print_context_menu BIN_NO_X_OPTIONS[@]
		fi

	elif [[ "${type}" == "text/plain" ]]
	then
		print_context_menu TEXT_OPTIONS[@]

	elif [[ "${type}" == "text/html" ]]
	then
		print_context_menu HTML_OPTIONS[@]
	
	elif [[ "${type}" == "image/jpeg" ]] || [[ "${type}" == "image/png" ]]
	then
		print_context_menu IMAGE_OPTIONS[@]
	
	elif [[ "${type}" == "image/x-xcf" ]] || [[ "${type}" == "image/svg+xml" ]]
	then
		print_context_menu XCF_SVG_OPTIONS[@]
	
	elif [ ! -w "${CUR_DIR}" ] && [[ "${type}" == "text/x-shellscript" ]]
	then
		coproc ( exec "${CUR_DIR}" & > /dev/null  2>&1 )
	
	else
		if [ ! -d "${CUR_DIR}" ] && [ ! -f "${CUR_DIR}" ]
		then
			QUERY="${CUR_DIR//*\/\//}"

			echo "${QUERY}" >> "${HIST_FILE}"
			
			find_query "${QUERY#!}"

			web_search "!${QUERY}"
		else
			coproc ( ${OPENER} "${CUR_DIR}" & > /dev/null  2>&1 )
		fi
	fi
	exit;
}

# If argument is not a directory/folder
if [ ! -d "${CUR_DIR}" ]
then
	echo "${CUR_DIR}" > "${CURRENT_FILE}"
	context_menu
	exit;
fi

navigate_to
