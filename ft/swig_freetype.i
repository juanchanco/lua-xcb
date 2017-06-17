%module swig_freetype
%{
 #include <ft2build.h>
 #include FT_FREETYPE_H
%}
#define __attribute__(x)
#define __asm(x)
#define __inline
#define __restrict
#define __extension__
%include <typemaps.i>
%include "freetype.hh";
