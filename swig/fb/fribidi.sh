uname=`uname`
extra_pc=
if [ "$uname" = "Darwin" ]; then
        swig=swig
        extra_pc=lua5.3
elif [ "$uname" = "NetBSD" ]; then
        swig=swig3.0
else
        extra_incl=-I/usr/include
        swig=swig3.0
fi
$swig -lua `pkg-config --cflags-only-I fribidi` $extra_incl swig_fribidi.i
gcc -fPIC `pkg-config --cflags fribidi $extra_pc` -c swig_fribidi_wrap.c -o swig_fribidi_wrap.o
gcc -shared `pkg-config --libs fribidi $extra_pc` swig_fribidi_wrap.o -o swig_fribidi.so
