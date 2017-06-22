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
$swig -lua `pkg-config --cflags-only-I fontconfig` swig_fc.i
gcc -fPIC `pkg-config --cflags fontconfig $extra_pc` -c swig_fc_wrap.c -o swig_fc_wrap.o
gcc -shared `pkg-config --libs fontconfig $extra_pc` swig_fc_wrap.o -o swig_fc.so
