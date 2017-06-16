uname=`uname`
if [ "$uname" = "Darwin" ]; then
        swig=swig
elif [ "$uname" = "NetBSD" ]; then
        swig=swig3.0
else
        swig=swig3.0
fi
#cpp `pkg-config --cflags-only-I freetype2` ftadvanc.h | grep -v '^#' | grep -v '^$' > ftadvanc.hh
$swig -lua `pkg-config --cflags-only-I freetype2` swig_ftadvanc.i
gcc -fPIC `pkg-config --cflags freetype2` -c swig_ftadvanc_wrap.c -o swig_ftadvanc_wrap.o
gcc -shared `pkg-config --libs freetype2` swig_ftadvanc_wrap.o -o swig_ftadvanc.so
