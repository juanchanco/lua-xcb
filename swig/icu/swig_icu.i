%module swig_icu
%{
 #include <unicode/uchar.h>
 #include <unicode/uscript.h>
 #include <unicode/utext.h>
 #include <unicode/utypes.h>
%}
%include <typemaps.i>
%typemap(in) int8_t { $1 = (int8_t) lua_tointeger(L, $input); }
%typemap(out) int8_t { lua_pushinteger(L, (int) $1); SWIG_arg++; }
%typemap(in) uint8_t { $1 = (uint8_t) lua_tointeger(L, $input); }
%typemap(out) uint8_t { lua_pushinteger(L, (int) $1); SWIG_arg++; }
%typemap(in) uint32_t { $1 = (uint32_t) lua_tointeger(L, $input); }
%typemap(out) uint32_t { lua_pushinteger(L, (int) $1); SWIG_arg++; }
%typemap(in) uint16_t { $1 = (uint32_t) lua_tointeger(L, $input); }
%typemap(out) uint16_t { lua_pushinteger(L, (int) $1); SWIG_arg++; }
%typemap(in) uint32_t { $1 = (uint32_t) lua_tointeger(L, $input); }
%typemap(out) int32_t { lua_pushinteger(L, (int) $1); SWIG_arg++; }
%typemap(in) uint32_t { $1 = (uint32_t) lua_tointeger(L, $input); }
%typemap(out) uint32_t { lua_pushinteger(L, (int) $1); SWIG_arg++; }
%typemap(in) int64_t { $1 = (int64_t) lua_tointeger(L, $input); }
%typemap(out) int64_t { lua_pushinteger(L, (int) $1); SWIG_arg++; }
%typemap(in) uint64_t { $1 = (uint64_t) lua_tointeger(L, $input); }
%typemap(out) uint64_t { lua_pushinteger(L, (int) $1); SWIG_arg++; }
%typemap(in) UChar32 { $1 = (UChar32) lua_tointeger(L, $input); }
%typemap(out) UChar32 { lua_pushinteger(L, (int) $1); SWIG_arg++; }
%typemap(in) UScriptCode { $1 = (UScriptCode) lua_tointeger(L, $input); }
%typemap(out) UScriptCode { lua_pushinteger(L, (int) $1); SWIG_arg++; }
%typemap(in) UBool { $1 = (UBool) lua_toboolean(L, $input); }
%typemap(out) UBool { lua_pushboolean(L, (int) $1); SWIG_arg++; }
%typemap(in) UErrorCode *status {
  UErrorCode temp = (UErrorCode) lua_tointeger(L, $input);
  $1 = &temp;
}
%typemap(argout) UErrorCode *status {
  lua_pushinteger(L, (int)* $1); SWIG_arg++;
}
%typemap(in) UErrorCode *err {
  UErrorCode temp = (UErrorCode) lua_tointeger(L, $input);
  $1 = &temp;
}
%typemap(argout) UErrorCode *err {
  lua_pushinteger(L, (int)* $1); SWIG_arg++;
}
/*TODO: put in argout typemaps for VerionsInfo */
%ignore u_charAge;
%ignore u_getUnicodeVersion;
%import <unicode/uvernum.h>
/*%import <unicode/uversion.h>*/
%import <unicode/platform.h>
%import <unicode/umachine.h>
%import <unicode/uloc.h>
%import <unicode/localpointer.h>
%include <unicode/uchar.h>
%include <unicode/uscript.h>
%include <unicode/utypes.h>
%include <unicode/utext.h>
