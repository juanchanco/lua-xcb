%module swig_hb
%{
 #include <hb.h>
%}
%include <typemaps.i>

/*typedef uint32_t hb_codepoint_t;*/
/*typedef int32_t hb_position_t;*/
/*typedef uint32_t hb_mask_t;*/

%typemap(in) hb_direction_t {
  $1 = (int) lua_tointeger(L, $input);
}
%typemap(out) hb_direction_t {
  lua_pushinteger(L, (int) $1); SWIG_arg++;
}
%typemap(in) hb_script_t {
  $1 = (int) lua_tointeger(L, $input);
}
%typemap(out) hb_script_t {
  lua_pushinteger(L, (int) $1); SWIG_arg++;
}
%typemap(in) hb_position_t {
  $1 = (uint32_t) lua_tointeger(L, $input);
}
%typemap(out) hb_position_t {
  lua_pushinteger(L, (int) $1); SWIG_arg++;
}
%typemap(in) uint32_t {
  $1 = (uint32_t) lua_tointeger(L, $input);
}
%typemap(out) uint32_t {
  lua_pushinteger(L, (int) $1); SWIG_arg++;
}
%typemap(in) int32_t {
  $1 = (int32_t) lua_tointeger(L, $input);
}
%typemap(out) int32_t {
  lua_pushinteger(L, (int) $1); SWIG_arg++;
}
%apply unsigned int* OUTPUT {unsigned int *length};
#define HB_H_IN
#define HB_EXTERN extern
#define HB_BEGIN_DECLS
#define HB_END_DECLS
%include <hb-blob.h>
%include <hb-buffer.h>
%include <hb-common.h>
%include <hb-deprecated.h>
%include <hb-face.h>
%include <hb-font.h>
%include <hb-set.h>
%include <hb-shape.h>
%include <hb-shape-plan.h>
%include <hb-unicode.h>
%include <hb-version.h>
%inline %{
hb_glyph_info_t get_glyph_info(hb_glyph_info_t* arr, int i) {
  return arr[i];
}
hb_glyph_position_t get_glyph_position(hb_glyph_position_t* arr, int i) {
  return arr[i];
}
%}
%native(setmetatable) int userdata_set_metatable(lua_State *L);
%{
int userdata_set_metatable(lua_State *L)
{
    luaL_checktype(L, 1, LUA_TUSERDATA);
    luaL_checktype(L, 2, LUA_TTABLE);
    lua_pushvalue(L,2);
    lua_setmetatable(L,1);
    return 0;
}
%}
