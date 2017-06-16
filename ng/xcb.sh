#cpp `pkg-config --cflags-only-I xcb` /usr/X11R7/include/xcb/xcb.h | grep -v "^#" | grep -v '^$' > xcb.hh
swig3.0 -cpperraswarn -lua `pkg-config --cflags-only-I xcb` swig_xcb.i
gcc -fPIC `pkg-config --cflags xcb` -c swig_xcb_wrap.c -o swig_xcb_wrap.o
gcc -shared `pkg-config --libs xcb` swig_xcb_wrap.o -o swig_xcb.so
