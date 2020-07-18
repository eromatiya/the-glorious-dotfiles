#!/usr/bin/env bash

# ----------------------------------------------------------------------------
# --- Rofi File Browser
# --
# --
# -- @author manilarome &lt;gerome.matilla07@gmail.com&gt;
# -- @copyright 2020 manilarome
# -- @script rofi-spotlight.sh
# ----------------------------------------------------------------------------

TMP_DIR="/tmp/rofi/${USER}/"

PREV_LOC_FILE="${TMP_DIR}rofi_fb_prevloc"
CURRENT_FILE="${TMP_DIR}rofi_fb_current_file"

MY_PATH="$(dirname "${0}")"
HIST_FILE="${MY_PATH}/history.txt"

OPENER=xdg-open
TERM_EMU=kitty
TEXT_EDITOR=${EDITOR}
FILE_MANAGER=dolphin
BLUETOOTH_SEND=blueman-sendto

CUR_DIR=$PWD

NEXT_DIR=""

SHOW_HIDDEN=false

declare -a SHELL_OPTIONS=(
	"Run"
	"Execute in ${TERM_EMU}"
	"Edit"
	"Open file location in ${TERM_EMU}"
	"Open file location in ${FILE_MANAGER}"
	"Move to trash"
	"Delete"
	"Back"
)

declare -a SHELL_NO_X_OPTIONS=(
	"Edit"
	"Open file location in ${TERM_EMU}"
	"Open file location in ${FILE_MANAGER}"
	"Move to trash"
	"Delete"
	"Back"
)

declare -a BIN_OPTIONS=(
	"Run"
	"Execute in ${TERM_EMU}"
	"Open file location in ${TERM_EMU}"
	"Open file location in ${FILE_MANAGER}"
	"Back"
)

declare -a BIN_NO_X_OPTIONS=(
	"Open file location in ${TERM_EMU}"
	"Open file location in ${FILE_MANAGER}"
	"Back"
)

declare -a TEXT_OPTIONS=(
	"Edit"
	"Open file location in ${TERM_EMU}"
	"Open file location in ${FILE_MANAGER}"
	"Move to trash"
	"Delete"
	"Back"
)

declare -a XCF_SVG_OPTIONS=(
	"Open"
	"Open file location in ${TERM_EMU}"
	"Open file location in ${FILE_MANAGER}"
	"Move to trash"
	"Delete"
	"Back"
)

declare -a IMAGE_OPTIONS=(
	"Open"
	"Send via Bluetooth"
	"Open file location in ${TERM_EMU}"
	"Open file location in ${FILE_MANAGER}"
	"Move to trash"
	"Delete"
	"Back"
)

declare -a ALL_OPTIONS=()

# Combine all context menu
COMBINED_OPTIONS=(
	"${SHELL_OPTIONS[@]}"
	"${SHELL_NO_X_OPTIONS[@]}"
	"${BIN_OPTIONS[@]}"
	"${BIN_NO_X_OPTIONS[@]}"
	"${TEXT_OPTIONS[@]}"
	"${XCF_SVG_OPTIONS[@]}"
	"${IMAGE_OPTIONS[@]}"
)

# Remove duplicates
while IFS= read -r -d '' x; do
    ALL_OPTIONS+=("$x")
done < <(printf "%s\0" "${COMBINED_OPTIONS[@]}" | sort -uz)

# Create tmp dir for rofi
if [ ! -d "${TMP_DIR}" ]
then
	mkdir -p "${TMP_DIR}";
fi

# Create hist file if it doesn't exist
if [ ! -f "${HIST_FILE}" ]
then
	touch "${HIST_FILE}"
fi

# Help message
if [[ ! -z "$@" ]] && [[ "$@" == ":help" ]]
then

	echo "Rofi Spotlight"
	echo "A Rofi with file and web searching functionality"
	echo " "
	echo "Commands:"
	echo ":help to print this help message"
	echo ":h or :hidden to show hidden files/dirs"
	echo ":sh or :show_hist to show search history"
	echo ":ch or :clear_hist to clear search history"
	echo ":xdg to jump to an xdg directory"
	echo "Examples:"
	echo "	:xdg DOCUMENTS"
	echo "	:xdg DOWNLOADS"
	echo "Also supports incomplete path:"
	echo "Examples:"
	echo "	:xdg doc"
	echo "	:xdg down"
	echo "For more info about XDG dirs, see:"
	echo "\`man xdg-user-dir\`"
	echo " "
	echo "File search syntaxes:"
	echo "!<search_query> to search for a file and web suggestions"
	echo "?<search_query> to search parent directories"
	echo "Examples:"
	echo "	!half-life 3"
	echo " 	?portal 3"
	echo " "
	echo "Web search syntaxes:"
	echo "!<search_query> to gets search suggestions"
	echo ":web/:w <search_query> to also to gets search suggestions"
	echo ":webbro/:wb <search_query> to search directly from your browser"
	echo "Examples:"
	echo "	!how to install archlinux"
	echo "	:web how to install gentoo"
	echo "	:w how to make a nuclear fission"
	echo "	:webbro how to install wine in windowsxp"

	exit;
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

	echo "${1}""\0icon\x1f""${icon_name}""\n"
}


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

	if [[ "$@" == ":webbro"* ]]
	then
		remove=":webbro"
	else
		remove=":wb"
	fi

	# Search directly from your web browser
	web_search "$(printf '%s\n' "${1//$remove/}")"
	exit;

elif [ ! -z "$@" ] && ([[ "$@" == ":web"* ]] || [[ "$@" == ":w"* ]])
then
	remove=''

	if [[ "$@" == ":web"* ]]
	then
		remove=":web"
	else
		remove=":w"
	fi

	# Get search suggestions
	web_search "!$(printf '%s\n' "${1//$remove/}")"
	exit;
fi

# File and calls to the web search
if [ ! -z "$@" ] && ([[ "$@" == /* ]] || [[ "$@" == \?* ]] || [[ "$@" == \!* ]])
then
	QUERY=$@

	echo "${QUERY}" >> "${HIST_FILE}"

	if [[ "$@" == /* ]]
	then
	
		if [[ "$@" == *\?\? ]]
		then
			coproc ( ${OPENER} "${QUERY%\/* \?\?}"  > /dev/null 2>&1 )
			exec 1>&-
			exit;
		else
			coproc ( ${OPENER} "$@"  > /dev/null 2>&1 )
			exec 1>&-
			exit;
		fi

	elif [[ "$@" == \?* ]]
	then
		while read -r line
		do
			echo "$line" \?\?
		done <<< $(find "${HOME}" -iname *"${QUERY#\?}"* 2>&1 | grep -v 'Permission denied\|Input/output error')

	else
		# Find the file
		find "${HOME}" -iname *"${QUERY#!}"* -exec echo -ne \
		"{}\0icon\x1f${MY_PATH}/icons/result.svg\n" \; 2>&1 | 
		grep -av 'Permission denied\|Input/output error'

		# Web search
		web_search "${QUERY}"
	fi
	exit;
fi

# Create notification if there's an error
function create_notification() {
	if [[ "${1}" == "denied" ]]
	then
		notify-send -a "Global Search" "<b>Permission denied!</b>" \
		'You have no permission to access '"<b>${CUR_DIR}</b>!"
	elif [[ "${1}" == "deleted" ]]
	then
		notify-send -a "Global Search" "<b>Success!</b>" \
		'File deleted!'
	elif [[ "${1}" == "trashed" ]]
	then
		notify-send -a "Global Search" "<b>Success!</b>" \
		'The file has been moved to trash!'	
	elif [[ "${1}" == "cleared" ]]
	then
		notify-send -a "Global Search" "<b>Success!</b>" \
		'Search history has been successfully cleared!'

	else
		notify-send -a "Global Search" "<b>Somethings wrong I can feel it!</b>" \
		'This incident will be reported!'
	fi
}

# Show the files in the current directory
function navigate_to() {
	# process current dir.
	if [ -n "${CUR_DIR}" ]
	then
		CUR_DIR=$(readlink -e "${CUR_DIR}")
		if [ ! -d "${CUR_DIR}" ] || [ ! -r "${CUR_DIR}" ]
		then
			echo "${HOME}" > "${PREV_LOC_FILE}"
			create_notification "denied"
	
		else
			echo "${CUR_DIR}/" > "${PREV_LOC_FILE}"
		fi
		pushd "${CUR_DIR}" >/dev/null
	fi

	printf "..\0icon\x1fup\n"
	
	if [[ ${SHOW_HIDDEN} == true ]]
	then

		for i in .*/
		do
			if [[ -d "${i}" ]] && ([[ "${i}" != "./" ]] && [[ "${i}" != "../"* ]])
			then
				printf "$(icon_file_type "${i}")";
			fi
		done

		for i in .*
		do 
			if [[ -f "${i}" ]]
			then
				printf "$(icon_file_type "${i}")";
			fi
		done

	fi

	for i in */
	do 
		if [[ -d "${i}" ]]
		then
			printf "$(icon_file_type "${i}")";
		fi
	done

	for i in *
	do 
		if [[ -f "${i}" ]]
		then
			printf "$(icon_file_type "${i}")";
		fi
	done
}

# Set XDG dir
function return_xdg_dir() {
	target_dir=$(echo "$1" | tr "[:lower:]" "[:upper:]")

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

	if [ ! -n "${hist}" ]
	then
		printf ".\0icon\x1fback\n"
		printf "No history, yet.\0icon\x1ftext-plain\n"
	fi

	while IFS= read -r line; 
	do 
		printf "${line}\0icon\x1f${MY_PATH}/icons/history.svg\n"; 
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

	NEXT_DIR=$(echo "$@" | awk '{print $2}')

	if [[ ! -z "$NEXT_DIR" ]]
	then
		return_xdg_dir "${NEXT_DIR}"
	else
		return_xdg_dir "${HOME}"
	fi

fi

# Read last location, otherwise we default to PWD.
if [ -f "${PREV_LOC_FILE}" ]
then
	CUR_DIR=$(cat "${PREV_LOC_FILE}")
fi

if [[ ! -z "$@" ]] && ([[ "$@" == ":h" ]] || [[ "$@" == ":hidden" ]])
then
	SHOW_HIDDEN=true
	navigate_to
	exit;
fi

# Handle argument.
if [ -n "$@" ]
then
	CUR_DIR="${CUR_DIR}/$@"
fi


# Context Menu
if [[ ! -z "$@" ]] && [[ "${ALL_OPTIONS[*]} " == *"${1}"* ]]
then
	case "${1}" in
		"Run" )
			coproc ( eval "$(cat "${CURRENT_FILE}")" & > /dev/null 2>&1 )
			kill -9 $(pgrep rofi)
			;;
		"Execute in ${TERM_EMU}" )
			coproc ( eval "${TERM_EMU} "$(cat "${CURRENT_FILE}")"" & > /dev/null 2>&1 )
			kill -9 $(pgrep rofi)
			;;
		"Open" )
			coproc ( eval "${OPENER} "$(cat "${CURRENT_FILE}")"" & > /dev/null 2>&1 )
			kill -9 $(pgrep rofi)
			;;
		"Open file location in ${TERM_EMU}" )
			file_path="$(cat "${CURRENT_FILE}")"
			coproc ( ${TERM_EMU} bash -c "cd "${file_path%/*}" ; ${SHELL}" & > /dev/null 2>&1 )
			kill -9 $(pgrep rofi)
			;;
		"Open file location in ${FILE_MANAGER}" )
			file_path="$(cat "${CURRENT_FILE}")"
			coproc ( eval "${FILE_MANAGER} "${file_path%/*}"" & > /dev/null 2>&1 )
			kill -9 $(pgrep rofi)
			;;
		"Edit" )
			coproc ( eval "${TERM_EMU} ${TEXT_EDITOR} $(cat "${CURRENT_FILE}")" & > /dev/null 2>&1 )
			kill -9 $(pgrep rofi)
			;;
		"Move to trash" )
			coproc( gio trash "$(cat "${CURRENT_FILE}")" & > /dev/null 2>&1 )
			create_notification "trashed"
			CUR_DIR="$(dirname $(cat "${CURRENT_FILE}"))"
			navigate_to
			;;
		"Delete" )
			shred "$(cat "${CURRENT_FILE}")"
			rm "$(cat "${CURRENT_FILE}")"
			create_notification "deleted"
			CUR_DIR="$(dirname $(cat "${CURRENT_FILE}"))"
			navigate_to
			;;
		"Send via Bluetooth" )
			rfkill unblock bluetooth &&	bluetoothctl power on 
			sleep 1
			blueman-sendto "$(cat "${CURRENT_FILE}")" & > /dev/null 2>&1
			kill -9 $(pgrep rofi)
			;;
		"Back" )
			CUR_DIR=$(cat "${PREV_LOC_FILE}")
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

	type=$(file --mime-type -b "${CUR_DIR}")
	
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

			find "${HOME}" -iname *"${QUERY#!}"* -exec echo -ne \
			"{}\0icon\x1f${MY_PATH}/icons/result.svg\n" \; 2>&1 | 
			grep -av 'Permission denied\|Input/output error'

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
