%module swig_fc
%{
 #include <fontconfig/fontconfig.h>
%}
/*typedef char FcChar8;*/
/*typedef short FcChar16;*/
/*typedef int FcChar32;*/
/*typedef int FcBool;*/
#define FcPublic
#define FC_ATTRIBUTE_SENTINEL(x)
%ignore FcObjectSetVaBuild;
%ignore FcPatternVaBuild;
%include <typemaps.i>
%apply SWIGTYPE ** OUTPUT { FcChar8 **s };
%apply SWIGTYPE ** OUTPUT { FcMatrix **s };
%apply SWIGTYPE ** OUTPUT { FcCharSet **c };
/*typedef unsigned char FcChar8;*/
/*typedef unsigned short FcChar16;*/
/*typedef unsigned int FcChar32;*/
/*typedef int FcBool;*/
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
FcObjectSet * FcObjectSetBuild4 (const char *first, const char *second, const char *third, const char* fourth) {
  return FcObjectSetBuild (first, second, third, fourth, (char*) 0);
}
FcPattern * get_FcPattern(FcPattern** arr, int i) {
  return arr[i];
}
/*TODO: figure out hwor to get swig to handle this*/
char* fcToString(FcChar8* str) { return (char*) str; }
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
