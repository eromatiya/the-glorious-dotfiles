# Maintainer: manilarome <hum@idontknowhis.email>
# Contributor: demostanis worlds <demostanis@protonmail.com>

pkgname=the-glorious-dotfiles
pkgver=0.0.1
pkgrel=1
pkgdesc="A glorified personal dot files"
arch=("x86_64")
url="https://github.com/manilarome/the-glorious-dotfiles"
license=("AGPL3")
depends=(
	"awesome-git"
	"rofi-git"
	"picom-tryone-git"
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
	"archlinux-xdg-menu: Menu Module/Useful for generating app list" 
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
	for file in $(find config/awesome)
	do
		install -Dm644 ${file} $DEST/${file}
	done

	echo && echo
	echo "Copied files to $DEST."
	echo "To start using $pkgname, you will need to copy" \
		"one of the following themes: "
	for t in $(ls config/awesome/)
	do
		echo "   $t"
	done
	echo "to the config folder using: "
	echo
	echo "cp -r $DEST/config/awesome/<theme> \$HOME/.config/awesome"
	echo && echo
}

