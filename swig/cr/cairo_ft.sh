uname=`uname`
if [ "$uname" = "Darwin" ]; then
        swig=swig
elif [ "$uname" = "NetBSD" ]; then
        swig=swig3.0
else
        swig=swig3.0
fi
$swig -lua `pkg-config --cflags-only-I cairo freetype2` swig_cairo_ft.i
gcc -fPIC `pkg-config --cflags cairo freetype2` -c swig_cairo_ft_wrap.c -o swig_cairo_ft_wrap.o
gcc -shared `pkg-config --libs cairo freetype2` swig_cairo_ft_wrap.o -o swig_cairo_ft.so
