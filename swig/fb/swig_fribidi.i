%module swig_fribidi
%{
 #include <fribidi.h>
%}
%include "fribidi.hh"
%init %{
    printf("LOADING: %x\n", L);
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
