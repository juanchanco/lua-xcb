uname=`uname`
if [ "$uname" = "Darwin" ]; then
        swig=swig
elif [ "$uname" = "NetBSD" ]; then
        swig=swig3.0
else
        swig=swig3.0
fi
$swig -lua `pkg-config --cflags-only-I harfbuzz freetype2` swig_hb_ft.i
gcc -fPIC `pkg-config --cflags harfbuzz freetype2` -c swig_hb_ft_wrap.c -o swig_hb_ft_wrap.o
gcc -shared `pkg-config --libs harfbuzz freetype2` swig_hb_ft_wrap.o -o swig_hb_ft.so
