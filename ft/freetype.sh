uname=`uname`
if [ "$uname" = "Darwin" ]; then
        swig=swig
elif [ "$uname" = "NetBSD" ]; then
        swig=swig3.0
else
        swig=swig3.0
fi
$swig -lua `pkg-config --cflags-only-I freetype2` swig_freetype.i
gcc -fPIC `pkg-config --cflags freetype2` -c swig_freetype_wrap.c -o swig_freetype_wrap.o
gcc -shared `pkg-config --libs freetype2` swig_freetype_wrap.o -o swig_freetype.so
