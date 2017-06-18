%module swig_cairo_ft
%{
 #include <cairo.h>
 #include <cairo-ft.h>
%}
/* torturous sequences of typedefs */
%import "../ft/freetype.hh"
#define CAIRO_HAS_FT_FONT 1
/*#define CAIRO_HAS_FC_FONT 1*/
%import <cairo.h>
%include <cairo-ft.h>
