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
$swig -lua `pkg-config --cflags-only-I harfbuzz` swig_hb.i
gcc -fPIC `pkg-config --cflags harfbuzz $extra_pc` -c swig_hb_wrap.c -o swig_hb_wrap.o
gcc -shared `pkg-config --libs harfbuzz $extra_pc` swig_hb_wrap.o -o swig_hb.so
