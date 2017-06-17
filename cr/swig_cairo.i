%module swig_cairo
%{
 #include <cairo.h>
%}
#define CAIRO_HAS_PNG_FUNCTIONS 1
%include "cairo.h"
