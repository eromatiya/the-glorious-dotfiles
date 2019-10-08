Deb10 Plymouth Theme
=====================

Debian à la Windows 10 boot splash theme for Plymouth

![deb10 Plymouth Theme preview](preview.gif)

Copyright (c) 2018, Mauro A. Meloni <maumeloni@gmail.com>  
https://maurom.com/

Based on

- Pure CSS Windows10 Loader by Fernando de Almeida Faria  
  https://codepen.io/feebaa/pen/PPrLQP
and
- Plymouth theming guide (part 4)  
  http://brej.org/blog/?p=238

Documentation about scripting available at
- https://www.freedesktop.org/wiki/Software/Plymouth/Scripts/
and
- https://sources.debian.org/src/plymouth/0.9.2-4/src/plugins/splash/script/

### Installation

    wget https://gitlab.com/maurom/deb10/repository/master/archive.tar.gz
    tar xvaf archive.tar.gz
    cd deb10-master-*
    make install   # as root or with sudo
    plymouth-set-default-theme -R deb10
    # reboot to see the new theme

### License

This theme is licensed under GPLv2, for more details check COPYING.
