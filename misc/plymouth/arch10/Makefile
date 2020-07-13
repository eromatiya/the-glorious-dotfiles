.PHONY: install uninstall set-default

uninstall:
	rm -rv /usr/share/plymouth/themes/arch10 || true

install: uninstall
	mkdir /usr/share/plymouth/themes/arch10
	cp -v *.script *.plymouth *.png /usr/share/plymouth/themes/arch10/

set-default:
	plymouth-set-default-theme -R arch10
