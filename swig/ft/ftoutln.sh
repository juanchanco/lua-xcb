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
$swig -lua `pkg-config --cflags-only-I freetype2` swig_ftoutln.i
gcc -fPIC `pkg-config --cflags freetype2 $extra_pc` -c swig_ftoutln_wrap.c -o swig_ftoutln_wrap.o
gcc -shared `pkg-config --libs freetype2 $extra_pc` swig_ftoutln_wrap.o -o swig_ftoutln.so
