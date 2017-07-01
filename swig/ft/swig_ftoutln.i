%module swig_ftoutln
%{
 #include <ft2build.h>
 #include FT_FREETYPE_H
 #include FT_OUTLINE_H
%}
#define __attribute__(x)
#define __asm(x)
#define __inline
#define __restrict
#define __extension__
%include <typemaps.i>
%include "ftoutln.hh";
