uname=`uname`
if [ "$uname" = "Darwin" ]; then
        swig=swig
elif [ "$uname" = "NetBSD" ]; then
        swig=swig3.0
else
        swig=swig3.0
fi
$swig -lua `pkg-config --cflags-only-I harfbuzz` swig_hb.i
gcc -fPIC `pkg-config --cflags harfbuzz` -c swig_hb_wrap.c -o swig_hb_wrap.o
gcc -shared `pkg-config --libs harfbuzz` swig_hb_wrap.o -o swig_hb.so
