# Maintainer: manilarome <gerome.matilla07@gmail.com>
# Contributor: demostanis worlds <demostanis@protonmail.com>

pkgname=the-glorious-dotfiles
pkgver=0.0.2
pkgrel=1
pkgdesc="A glorified personal dot files"
arch=("x86_64")
url="https://github.com/manilarome/the-glorious-dotfiles"
license=("AGPL3")
depends=(
	"awesome-git"
	"rofi-git"
	"picom-tryone-git"
	"inter-font"
)
optdepends=(
	"light-git: Brightness widget and OSD" 
	"alsa-utils: Volume widget and OSD" 
	"acpi: Power/Battery Widgets" 
	"acpid: Power/Battery Widgets" 
	"acpi_call: Power/Battery Widgets" 
	"mpd: Music widget" 
	"mpc: Music widget" 
	"maim: Screenshot tool" 
	"xclip: Will be used in saving the screenshots to clipboard" 
	"imagemagick: Music widget/Extracts hardcoded album cover from songs" 
	"blueman: Default launch application for bluetooth widget" 
	"redshift: Blue light widget" 
	"xfce4-power-manager: Default launch application for battery widget" 
	"upower: Battery widget" 
	"jq: Read weather" 
	"noto-fonts-emoji: Emoji support for notification center" 
	"nerd-fonts-fantasque-sans-mono: Rofi unicode font" 
	"xdg-user-dirs: xdg-folders widget"
)
makedepends=("git")
source=("git+$url.git")
sha256sums=("SKIP")

package() {
	DEST="${pkgdir}/usr/lib/$pkgname"

	cd "${srcdir}/$pkgname"
	mkdir -p $DEST
	for file in $(find config/awesome -type f)
	do
		install -Dm755 ${file} $DEST/${file}
	done

	echo
	echo "Here's a list of available themes:"
	for t in $(ls config/awesome/)
	do
		echo -e " \033[1m$t\033[0m"
	done
	_ask
}

_ask() {
	echo -n "Please choose one to install: "
	read THEME

	if [[ -d $DEST/config/awesome/$THEME ]]; then
		[[ -d ~/.config/awesome ]] && \
			cp -r ~/.config/awesome ~/.config/awesome.bak && \
			rm -rf ~/.config/awesome && \
			echo "Saved old awesome config to ~/.config/awesome.bak"
		cp -r $DEST/config/awesome/$THEME ~/.config/awesome
		echo "Successfully installed theme"
		echo
	elif [[ ! $THEME = "cancel" ]]; then
		echo "Invalid theme"
		_ask
	fi
}

