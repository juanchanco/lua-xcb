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
$swig -lua `pkg-config --cflags-only-I cairo` swig_cairo.i
gcc -fPIC `pkg-config --cflags cairo $extra_pc` -c swig_cairo_wrap.c -o swig_cairo_wrap.o
gcc -shared `pkg-config --cflags --libs cairo $extra_pc` swig_cairo_wrap.o -o swig_cairo.so
