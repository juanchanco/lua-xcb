%module swig_cairo
%{
 #include <cairo.h>
%}
#define CAIRO_HAS_PNG_FUNCTIONS 1
%include <carrays.i>
%array_functions(cairo_glyph_t, glyphs)
%include <cairo.h>
