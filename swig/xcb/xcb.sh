uname=`uname`
if [ "$uname" = "Darwin" ]; then
        xcb_incl_dir=/opt/X11/include
        swig=swig
        extra_pc=lua5.3
elif [ "$uname" = "NetBSD" ]; then
        xcb_incl_dir=/usr/X11R7/include
        swig=swig3.0
else
        xcb_incl_dir=/usr/include
        swig=swig3.0
fi
#$swig -lua `pkg-config --cflags-only-I xcb` -I$xcb_incl_dir swig_xcb.i
gcc -fPIC `pkg-config --cflags xcb $extra_pc` -c swig_xcb_wrap.c -o swig_xcb_wrap.o
gcc -shared `pkg-config --libs xcb $extra_pc` swig_xcb_wrap.o -o swig_xcb.so
