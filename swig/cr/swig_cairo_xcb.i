%module swig_cairo_xcb
%{
 #include <cairo.h>
 #include <cairo-features.h>
#define CAIRO_HAS_XCB_SURFACE 1
 #include <cairo-xcb.h>
%}
#define CAIRO_HAS_XCB_SURFACE 1
%import <cairo.h>
%typemap(in) xcb_drawable_t {
  $1 = (uint32_t) lua_tointeger(L, $input);
}
%include <cairo-xcb.h>
