%module swig_xcb
%{
 #include <xcb/xcb.h>
%}
#define __attribute__(x)
#define __inline
#define __restrict
#define __extension__
%include <typemaps.i>
%apply int* INPUT {int *screenp};
%include "xcb.hh"
