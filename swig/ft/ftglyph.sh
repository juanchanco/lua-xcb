uname=`uname`
if [ "$uname" = "Darwin" ]; then
        swig=swig
elif [ "$uname" = "NetBSD" ]; then
        swig=swig3.0
else
        swig=swig3.0
fi
$swig -lua `pkg-config --cflags-only-I freetype2` swig_ftglyph.i
gcc -fPIC `pkg-config --cflags freetype2` -c swig_ftglyph_wrap.c -o swig_ftglyph_wrap.o
gcc -shared `pkg-config --libs freetype2` swig_ftglyph_wrap.o -o swig_ftglyph.so
