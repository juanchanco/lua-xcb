%module swig_cairo_xcb
%{
 #include <cairo.h>
 #include <cairo-xcb.h>
%}
#define CAIRO_HAS_XCB_SURFACE 1
%import <cairo.h>
%include <cairo-xcb.h>
