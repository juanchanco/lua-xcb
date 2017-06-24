%module swig_fribidi
%{
 #include <fribidi.h>
 #include <stdlib.h>
#define _FRIBIDI_TYPE_SENTINEL 0
#define _FRIBIDI_PAR_SENTINEL 0
%}
%ignore fribidi_set_debug;
%ignore fribidi_debug_status;
%include <fribidi-flags.h>
%include "fribidi.hh"
%include <carrays.i>
%array_functions(FriBidiChar, FriBidiCharArray)
%array_functions(FriBidiCharType, FriBidiCharTypeArray)
%array_functions(FriBidiStrIndex, FriBidiStrIndexArray)
%array_functions(FriBidiLevel, FriBidiLevelArray)
%array_functions(FriBidiJoiningType, FriBidiJoiningTypeArray)
%array_functions(FriBidiArabicProp, FriBidiArabicPropArray)
%array_functions(uint, UintArray)

%inline %{
void memcpy_FriBidiCharArray(FriBidiChar *dest, char *src, int l) {
    memcpy(dest,src,l);
}
void memcpy_FriBidiCharArray2(FriBidiChar *dest, FriBidiChar *src, int l) {
    l = l * sizeof(FriBidiChar);
    memcpy(dest,src,l);
}
void memcpy_FriBidiJoiningTypeArray(FriBidiArabicProp *dest, FriBidiJoiningType *src, int l) {
    l = l * sizeof(FriBidiJoiningType);
    memcpy(dest,src,l);
}
%}
%native(setmetatable) int userdata_set_metatable(lua_State *L);
%native(get_par_embedding_levels_ref) int _wrap_fribidi_get_par_embedding_levels_ref(lua_State *L);
%{
int userdata_set_metatable(lua_State *L)
{
    luaL_checktype(L, 1, LUA_TUSERDATA);
    luaL_checktype(L, 2, LUA_TTABLE);
    lua_pushvalue(L,2);
    lua_setmetatable(L,1);
    return 0;
}


static int _wrap_fribidi_get_par_embedding_levels_ref(lua_State* L) {
  int SWIG_arg = 0;
  FriBidiCharType *arg1 = (FriBidiCharType *) 0 ;
  FriBidiStrIndex arg2 ;
  FriBidiParType arg3 ;
  FriBidiLevel *arg4 = (FriBidiLevel *) 0 ;
  FriBidiLevel result;
  
  SWIG_check_num_args("fribidi_get_par_embedding_levels",4,4)
  if(!SWIG_isptrtype(L,1)) SWIG_fail_arg("fribidi_get_par_embedding_levels",1,"FriBidiCharType const *");
  if(!lua_isnumber(L,2)) SWIG_fail_arg("fribidi_get_par_embedding_levels",2,"FriBidiStrIndex const");
  if(!SWIG_isptrtype(L,4)) SWIG_fail_arg("fribidi_get_par_embedding_levels",4,"FriBidiLevel *");
  
  if (!SWIG_IsOK(SWIG_ConvertPtr(L,1,(void**)&arg1,SWIGTYPE_p_FriBidiCharType,0))){
    SWIG_fail_ptr("fribidi_get_par_embedding_levels",1,SWIGTYPE_p_FriBidiCharType);
  }
  
  arg2 = (FriBidiStrIndex const)lua_tonumber(L, 2);
  arg3 = (FriBidiParType)lua_tonumber(L, 3);
  
  if (!SWIG_IsOK(SWIG_ConvertPtr(L,4,(void**)&arg4,SWIGTYPE_p_signed_char,0))){
    SWIG_fail_ptr("fribidi_get_par_embedding_levels",4,SWIGTYPE_p_signed_char);
  }
  
  result = (FriBidiLevel)fribidi_get_par_embedding_levels((FriBidiCharType const *)arg1,arg2,&arg3,arg4);
  lua_pushnumber(L, (lua_Number) result); SWIG_arg++;
  lua_pushnumber(L, (lua_Number) arg3); SWIG_arg++;
  return SWIG_arg;
  
  if(0) SWIG_fail;
  
fail:
  lua_error(L);
  return SWIG_arg;
}


%}
