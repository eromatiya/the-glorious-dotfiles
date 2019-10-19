.PHONY: install uninstall set-default

uninstall:
	rm -rv /usr/share/plymouth/themes/deb10 || true

install: uninstall
	mkdir /usr/share/plymouth/themes/deb10
	cp -v *.script *.plymouth *.png /usr/share/plymouth/themes/deb10/

set-default:
	plymouth-set-default-theme -R deb10
