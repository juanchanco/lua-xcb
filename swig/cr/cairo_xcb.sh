swig3.0 -lua `pkg-config --cflags-only-I cairo xcb` swig_cairo_xcb.i
gcc -fPIC `pkg-config --cflags cairo xcb` -c swig_cairo_xcb_wrap.c -o swig_cairo_xcb_wrap.o
gcc -shared `pkg-config --cflags --libs cairo xcb` swig_cairo_xcb_wrap.o -o swig_cairo_xcb.so
