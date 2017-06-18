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
/*%apply (xcb_rectangle_t *INPUT, int) {(xcb_rectangle_t* rectangles, int len)};*/
/*%apply xcb_rectangle_t* INPUT {xcb_rectangle_t* rectangles};*/
%include <carrays.i>
%array_functions(uint32_t, values)
%array_functions(xcb_rectangle_t, rectangles)
/*%include "xcb.hh"*/
%include "xcb/xcb.h"
%include "xcb/xproto.h"
%inline %{
static xcb_visualtype_t *find_visual(xcb_connection_t *c, xcb_visualid_t visual) {
    xcb_screen_iterator_t screen_iter = xcb_setup_roots_iterator(xcb_get_setup(c));

    for (; screen_iter.rem; xcb_screen_next(&screen_iter)) {
        xcb_depth_iterator_t depth_iter = xcb_screen_allowed_depths_iterator(screen_iter.data);
        for (; depth_iter.rem; xcb_depth_next(&depth_iter)) {
            xcb_visualtype_iterator_t visual_iter = xcb_depth_visuals_iterator(depth_iter.data);
            for (; visual_iter.rem; xcb_visualtype_next(&visual_iter))
                if (visual == visual_iter.data->visual_id)
                    return visual_iter.data;
        }
    }

    return NULL;
}
%}
