%module swig_xcb
%{
 #include <xcb/xcb.h>
%}
/*#define __attribute__(x)*/
/*#define __asm(x)*/
/*#define __inline*/
/*#define __restrict*/
/*#define __extension__*/
%include <typemaps.i>
%apply int* INPUT {int *screenp};
/*typedef signed char int8_t;*/
/*typedef unsigned char uint8_t;*/
/*typedef short int int16_t;*/
/*typedef unsigned short int uint16_t;*/
/*typedef int int32_t;*/
/*typedef unsigned int uint32_t;*/
/*typedef long int int64_t;*/
/*typedef unsigned long int uint64_t;*/
%typemap(in) int8_t {
  $1 = (int8_t) lua_tointeger(L, $input);
}
%typemap(in) int16_t {
  $1 = (int16_t) lua_tointeger(L, $input);
}
%typemap(in) int32_t {
  $1 = (int32_t) lua_tointeger(L, $input);
}
%typemap(in) uint8_t {
  $1 = (uint8_t) lua_tointeger(L, $input);
}
%typemap(in) uint16_t {
  $1 = (uint16_t) lua_tointeger(L, $input);
}
%typemap(in) uint32_t {
  $1 = (uint32_t) lua_tointeger(L, $input);
}
%typemap(out) int8_t {
  lua_pushinteger(L, (int) $1); SWIG_arg++;
}
%typemap(out) uint16_t {
  lua_pushinteger(L, (int) $1); SWIG_arg++;
}
%typemap(out) int32_t {
  lua_pushinteger(L, (int) $1); SWIG_arg++;
}
%typemap(out) uint8_t {
  lua_pushinteger(L, (int) $1); SWIG_arg++;
}
%typemap(out) uint16_t {
  lua_pushinteger(L, (int) $1); SWIG_arg++;
}
%typemap(out) uint32_t {
  lua_pushinteger(L, (int) $1); SWIG_arg++;
}
/*%apply uint32_t* INPUT {uint32_t *value_list};*/
%include <carrays.i>
%array_functions(uint32_t, values)
/*%include "xcb.hh"*/
%include "/usr/X11R7/include/xcb/xcb.h"
%include "/usr/X11R7/include/xcb/xproto.h"
