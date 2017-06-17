swig3.0 -lua `pkg-config --cflags-only-I cairo` swig_cairo.i
gcc -fPIC `pkg-config --cflags cairo` -c swig_cairo_wrap.c -o swig_cairo_wrap.o
gcc -shared `pkg-config --cflags --libs cairo` swig_cairo_wrap.o -o swig_cairo.so
