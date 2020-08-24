#!/bin/bash

BRANCH="1.18.3"

exec > >(tee build-gstreamer.log)
exec 2>&1

[ ! -d orc ] && git clone git://anongit.freedesktop.org/git/gstreamer/orc
[ ! -d gstreamer ] && git clone git://anongit.freedesktop.org/git/gstreamer/gstreamer
[ ! -d gst-plugins-base ] && git clone git://anongit.freedesktop.org/git/gstreamer/gst-plugins-base
[ ! -d gst-plugins-good ] && git clone git://anongit.freedesktop.org/git/gstreamer/gst-plugins-good
[ ! -d gst-plugins-bad ] && git clone git://anongit.freedesktop.org/git/gstreamer/gst-plugins-bad
[ ! -d gst-libav ] && git clone git://anongit.freedesktop.org/git/gstreamer/gst-libav
[ ! -d gst-plugins-ugly ] && git clone git://anongit.freedesktop.org/git/gstreamer/gst-plugins-ugly
[ ! -d gst-python ] && git clone git://anongit.freedesktop.org/git/gstreamer/gst-python

export LD_LIBRARY_PATH=/usr/local/lib/

cd orc
./autogen.sh --disable-gtk-doc
make
sudo make install
cd ..

cd gstreamer
git checkout $BRANCH
./autogen.sh --disable-gtk-doc
make
sudo make install
cd ..

cd gst-plugins-base
git checkout $BRANCH
./autogen.sh --disable-gtk-doc
make
sudo make install
cd ..

cd gst-libav
git checkout $BRANCH
./autogen.sh --disable-gtk-doc --enable-orc
make
sudo make install
cd ..

cd gst-plugins-good
git checkout $BRANCH
./autogen.sh --disable-gtk-doc
make
sudo make install
cd ..

cd gst-plugins-bad
git checkout $BRANCH
./autogen.sh --disable-gtk-doc --enable-orc
make
sudo make install
cd ..

cd gst-plugins-ugly
git checkout $BRANCH
./autogen.sh --disable-gtk-doc --enable-orc
make
sudo make install
cd ..

# export PYTHON=/usr/bin/python3 (Specify required python version)

cd gst-python
git checkout $BRANCH
./autogen.sh --disable-gtk-doc --noconfigure
# with-libpython-dir -> location of libpython*.so
./configure --with-libpython-dir="/usr/lib/x86_64-linux-gnu"
make
sudo make install
cd ..


sudo ldconfig