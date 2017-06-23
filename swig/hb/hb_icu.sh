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
$swig -lua `pkg-config --cflags-only-I harfbuzz-icu` swig_hb_icu.i
gcc -fPIC `pkg-config --cflags harfbuzz-icu $extra_pc` -c swig_hb_icu_wrap.c -o swig_hb_icu_wrap.o
gcc -shared `pkg-config --libs harfbuzz-icu $extra_pc` swig_hb_icu_wrap.o -o swig_hb_icu.so
