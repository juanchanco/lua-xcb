uname=`uname`
extra_pc=
if [ "$uname" = "Darwin" ]; then
        swig=swig
elif [ "$uname" = "NetBSD" ]; then
        swig=swig3.0
else
        swig=swig3.0
fi
$swig -lua $extra_incl swig_tinyc2.i
gcc -fPIC -c tinyc2.c -o tinyc2.o
if [ "$uname" = "Darwin" ]; then
gcc -fPIC `pkg-config --cflags lua5.3` -c swig_tinyc2_wrap.c -o swig_tinyc2_wrap.o
gcc -shared `pkg-config --libs lua5.3` swig_tinyc2_wrap.o tinyc2.o -o swig_tinyc2.so
else
gcc -fPIC $extra_pc -c swig_tinyc2_wrap.c -o swig_tinyc2_wrap.o
gcc -shared $extra_pc swig_tinyc2_wrap.o tinyc2.o -o swig_tinyc2.so
fi

