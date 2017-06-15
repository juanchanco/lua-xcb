#cpp `pkg-config --cflags-only-I xcb` /usr/include/xcb/xcb.h | grep -v "^#" | grep -v '^$' > xcb.hh
swig3.0 -lua `pkg-config --cflags-only-I xcb` swig_xcb.i
gcc -fPIC `pkg-config --cflags xcb` -c swig_xcb_wrap.c -o swig_xcb_wrap.o
gcc -shared `pkg-config --cflags --libs xcb` -lpthread -lrt swig_xcb_wrap.o -o swig_xcb.so
