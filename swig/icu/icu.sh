uname=`uname`
if [ "$uname" = "Darwin" ]; then
        swig=swig
        extra_pc=lua5.3
elif [ "$uname" = "NetBSD" ]; then
        swig=swig3.0
else
        swig=swig3.0
fi
$swig -lua `pkg-config --cflags-only-I icu-uc` swig_icu.i
gcc -fPIC `pkg-config --cflags icu-uc $extra_pc` -c swig_icu_wrap.c -o swig_icu_wrap.o
gcc -shared `pkg-config --libs icu-uc $extra_pc` swig_icu_wrap.o -o swig_icu.so
