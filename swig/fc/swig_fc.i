%module swig_fc
%{
 #include <fontconfig/fontconfig.h>
%}
%include <typemaps.i>
#define FcPublic
#define FC_ATTRIBUTE_SENTINEL(x)
%ignore FcObjectSetVaBuild;
%ignore FcPatternVaBuild;
%include <fontconfig/fontconfig.h>
%inline %{
FcObjectSet * FcObjectSetBuild1 (const char *first) {
  return FcObjectSetBuild (first, (char*) 0);
}
FcObjectSet * FcObjectSetBuild2 (const char *first, const char *second) {
  return FcObjectSetBuild (first, second, (char*) 0);
}
FcObjectSet * FcObjectSetBuild3 (const char *first, const char *second, const char *third) {
  return FcObjectSetBuild (first, second, third, (char*) 0);
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
