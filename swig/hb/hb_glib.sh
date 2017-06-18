uname=`uname`
if [ "$uname" = "Darwin" ]; then
        swig=swig
elif [ "$uname" = "NetBSD" ]; then
        swig=swig3.0
else
        swig=swig3.0
fi
$swig -lua `pkg-config --cflags-only-I harfbuzz glib-2.0` swig_hb_glib.i
gcc -fPIC `pkg-config --cflags harfbuzz glib-2.0` -c swig_hb_glib_wrap.c -o swig_hb_glib_wrap.o
gcc -shared `pkg-config --libs harfbuzz glib-2.0` swig_hb_glib_wrap.o -o swig_hb_glib.so
