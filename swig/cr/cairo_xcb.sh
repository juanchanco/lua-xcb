uname=`uname`
extra_pc=
if [ "$uname" = "Darwin" ]; then
        swig=swig
        extra_pc=lua5.3
elif [ "$uname" = "NetBSD" ]; then
        swig=swig3.0
else
        swig=swig3.0
fi
$swig -lua `pkg-config --cflags-only-I cairo-xcb` swig_cairo_xcb.i
gcc -fPIC `pkg-config --cflags cairo-xcb $extra_pc` -c swig_cairo_xcb_wrap.c -o swig_cairo_xcb_wrap.o
gcc -shared `pkg-config --cflags --libs cairo-xcb $extra_pc` -L/opt/X11/lib swig_cairo_xcb_wrap.o -o swig_cairo_xcb.so
