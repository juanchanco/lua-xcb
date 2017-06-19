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
%apply SWIGTYPE** OUTPUT { FT_Library *alibrary };
%apply SWIGTYPE** OUTPUT { FT_Face *aface };
%typemap(out) FT_Error {
  lua_pushinteger(L, (int) $1); SWIG_arg++;
}
%include "freetype.hh";
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
