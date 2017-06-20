%module swig_xcb
%{
 #include <xcb/xcb.h>
%}
%include <typemaps.i>
%apply int* INPUT {int *screenp};
%apply SWIGTYPE** OUTPUT { xcb_generic_error_t **e };
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
xcb_visualtype_t *find_visual(xcb_connection_t *c, xcb_visualid_t visual) {
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
%native(setmetatable) int userdata_set_metatable(lua_State *L);
%native(xcb_poll_for_event_typed) int _xcb_poll_for_event_typed(lua_State *L);
%native(xcb_wait_for_event_typed) int _xcb_wait_for_event_typed(lua_State *L);
%{
int userdata_set_metatable(lua_State *L)
{
    luaL_checktype(L, 1, LUA_TUSERDATA);
    luaL_checktype(L, 2, LUA_TTABLE);
    lua_pushvalue(L,2);
    lua_setmetatable(L,1);
    return 0;
}

int _xcb_poll_for_event_typed(lua_State* L) {
  int SWIG_arg = 0;
  xcb_connection_t *arg1 = (xcb_connection_t *) 0 ;
  xcb_generic_event_t *result = 0 ;
  
  SWIG_check_num_args("xcb_poll_for_event",1,1)
  if(!SWIG_isptrtype(L,1)) SWIG_fail_arg("xcb_poll_for_event",1,"xcb_connection_t *");
  
  if (!SWIG_IsOK(SWIG_ConvertPtr(L,1,(void**)&arg1,SWIGTYPE_p_xcb_connection_t,0))){
    SWIG_fail_ptr("xcb_poll_for_event",1,SWIGTYPE_p_xcb_connection_t);
  }
  
  result = (xcb_generic_event_t *)xcb_poll_for_event(arg1);
  int t = result->response_type;

  if (t == XCB_BUTTON_PRESS || t == XCB_BUTTON_RELEASE || t == XCB_MOTION_NOTIFY || t == XCB_ENTER_NOTIFY || t == XCB_LEAVE_NOTIFY) {
    SWIG_NewPointerObj(L,result,SWIGTYPE_p_xcb_button_press_event_t,0); SWIG_arg++; 
  } else if (t == XCB_KEY_PRESS || t == XCB_KEY_RELEASE) {
    SWIG_NewPointerObj(L,result,SWIGTYPE_p_xcb_key_press_event_t,0); SWIG_arg++; 
  } else if (t == XCB_EXPOSE) {
    SWIG_NewPointerObj(L,result,SWIGTYPE_p_xcb_expose_event_t,0); SWIG_arg++; 
  /*} else if (result->response_type == 0) {*/
    /*SWIG_NewPointerObj(L,result,SWIGTYPE_p_xcb_generic_event_t,0); SWIG_arg++; */
  } else {
    SWIG_NewPointerObj(L,result,SWIGTYPE_p_xcb_generic_event_t,0); SWIG_arg++; 
  }
  return SWIG_arg;
  
  if(0) SWIG_fail;
  
fail:
  lua_error(L);
  return SWIG_arg;
}
int _xcb_wait_for_event_typed(lua_State* L) {
  int SWIG_arg = 0;
  xcb_connection_t *arg1 = (xcb_connection_t *) 0 ;
  xcb_generic_event_t *result = 0 ;
  
  SWIG_check_num_args("xcb_wait_for_event",1,1)
  if(!SWIG_isptrtype(L,1)) SWIG_fail_arg("xcb_wait_for_event",1,"xcb_connection_t *");
  
  if (!SWIG_IsOK(SWIG_ConvertPtr(L,1,(void**)&arg1,SWIGTYPE_p_xcb_connection_t,0))){
    SWIG_fail_ptr("xcb_wait_for_event",1,SWIGTYPE_p_xcb_connection_t);
  }
  
  result = (xcb_generic_event_t *)xcb_wait_for_event(arg1);
  int t = result->response_type;

  if (t == XCB_BUTTON_PRESS || t == XCB_BUTTON_RELEASE || t == XCB_MOTION_NOTIFY || t == XCB_ENTER_NOTIFY || t == XCB_LEAVE_NOTIFY) {
    SWIG_NewPointerObj(L,result,SWIGTYPE_p_xcb_button_press_event_t,0); SWIG_arg++; 
  } else if (t == XCB_KEY_PRESS || t == XCB_KEY_RELEASE) {
    SWIG_NewPointerObj(L,result,SWIGTYPE_p_xcb_key_press_event_t,0); SWIG_arg++; 
  } else if (t == XCB_EXPOSE) {
    SWIG_NewPointerObj(L,result,SWIGTYPE_p_xcb_expose_event_t,0); SWIG_arg++; 
  } else if (result->response_type == 0) {
    SWIG_NewPointerObj(L,result,SWIGTYPE_p_xcb_generic_error_t,0); SWIG_arg++; 
  } else {
    SWIG_NewPointerObj(L,result,SWIGTYPE_p_xcb_generic_event_t,0); SWIG_arg++; 
  }
  return SWIG_arg;
  
  if(0) SWIG_fail;
  
fail:
  lua_error(L);
  return SWIG_arg;
}

%}
