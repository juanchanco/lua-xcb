%module swig_icu_ubrk
%{
 #include <unicode/utext.h>
 #include <unicode/ubrk.h>
%}
%include <typemaps.i>
%typemap(in) int8_t { $1 = (int8_t) lua_tointeger(L, $input); }
%typemap(out) int8_t { lua_pushinteger(L, (int) $1); SWIG_arg++; }
%typemap(in) uint8_t { $1 = (uint8_t) lua_tointeger(L, $input); }
%typemap(out) uint8_t { lua_pushinteger(L, (int) $1); SWIG_arg++; }
%typemap(in) int16_t { $1 = (int8_t) lua_tointeger(L, $input); }
%typemap(out) int16_t { lua_pushinteger(L, (int) $1); SWIG_arg++; }
%typemap(in) uint16_t { $1 = (uint8_t) lua_tointeger(L, $input); }
%typemap(out) uint16_t { lua_pushinteger(L, (int) $1); SWIG_arg++; }
%typemap(in) int32_t { $1 = (int8_t) lua_tointeger(L, $input); }
%typemap(out) int32_t { lua_pushinteger(L, (int) $1); SWIG_arg++; }
%typemap(in) uint32_t { $1 = (uint8_t) lua_tointeger(L, $input); }
%typemap(out) uint32_t { lua_pushinteger(L, (int) $1); SWIG_arg++; }
%typemap(in) int64_t { $1 = (int8_t) lua_tointeger(L, $input); }
%typemap(out) int64_t { lua_pushinteger(L, (int) $1); SWIG_arg++; }
%typemap(in) uint64_t { $1 = (uint8_t) lua_tointeger(L, $input); }
%typemap(out) uint64_t { lua_pushinteger(L, (int) $1); SWIG_arg++; }
%typemap(in) UErrorCode *status {
  UErrorCode temp = (UErrorCode) lua_tointeger(L, $input);
  $1 = &temp;
}
%typemap(argout) UErrorCode *status {
  lua_pushinteger(L, (int)* $1); SWIG_arg++;
}
%import <unicode/platform.h>
%import <unicode/umachine.h>
%include <unicode/utypes.h>
%import <unicode/uloc.h>
%import <unicode/localpointer.h>
%include <unicode/utext.h>
%include <unicode/ubrk.h>
