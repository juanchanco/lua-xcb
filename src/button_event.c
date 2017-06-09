#include <stdlib.h>
#include <xcb/xcb.h>
#include "common/table.h"
#include "button_event.h"

const CommonEnum EventButtonMask[] = {
  { "Button1", XCB_BUTTON_MASK_1 },
  { "Button2", XCB_BUTTON_MASK_2 },
  { "Button3", XCB_BUTTON_MASK_3 },
  { "Button4", XCB_BUTTON_MASK_4 },
  { "Button5", XCB_BUTTON_MASK_5 },
  { "Any", XCB_BUTTON_MASK_ANY },
  { NULL, -1 }
};

const CommonEnum EventKeyButMask[] = {
  { "Shift", XCB_KEY_BUT_MASK_SHIFT },
  { "Lock", XCB_KEY_BUT_MASK_LOCK },
  { "Control", XCB_KEY_BUT_MASK_CONTROL },
  { "Mod1", XCB_KEY_BUT_MASK_MOD_1 },
  { "Mod2", XCB_KEY_BUT_MASK_MOD_2 },
  { "Mod3", XCB_KEY_BUT_MASK_MOD_3 },
  { "Mod4", XCB_KEY_BUT_MASK_MOD_4 },
  { "Mod5", XCB_KEY_BUT_MASK_MOD_5 },
  { "Button1", XCB_KEY_BUT_MASK_BUTTON_1 },
  { "Button2", XCB_KEY_BUT_MASK_BUTTON_2 },
  { "Button3", XCB_KEY_BUT_MASK_BUTTON_3 },
  { "Button4", XCB_KEY_BUT_MASK_BUTTON_4 },
  { "Button5", XCB_KEY_BUT_MASK_BUTTON_5 },
  { NULL, -1 }
};

static int _button_timestamp(lua_State* L) {
    xcb_button_press_event_t *evt = commonGetAs(L, 1, ButtonEventName, xcb_button_press_event_t *);
    return commonPush(L, "i", evt->time);
};
static int _button_state(lua_State* L) {
    xcb_button_press_event_t *evt = commonGetAs(L, 1, ButtonEventName, xcb_button_press_event_t *);
    return commonPush(L, "i", evt->state);
};

static int _root_x(lua_State* L) {
    xcb_button_press_event_t *evt = commonGetAs(L, 1, ButtonEventName, xcb_button_press_event_t *);
    return commonPush(L, "i", evt->root_x);
};
static int _root_y(lua_State* L) {
    xcb_button_press_event_t *evt = commonGetAs(L, 1, ButtonEventName, xcb_button_press_event_t *);
    return commonPush(L, "i", evt->root_y);
};
static int _event_x(lua_State* L) {
    xcb_button_press_event_t *evt = commonGetAs(L, 1, ButtonEventName, xcb_button_press_event_t *);
    return commonPush(L, "i", evt->event_x);
};
static int _event_y(lua_State* L) {
    xcb_button_press_event_t *evt = commonGetAs(L, 1, ButtonEventName, xcb_button_press_event_t *);
    return commonPush(L, "i", evt->event_y);
};


static const luaL_Reg metamethods[] = {
    { NULL, NULL }
};

static const luaL_Reg methods[] = {
    { "getTime", _button_timestamp },
    { "getState", _button_state },
    { "rootX", _root_x },
    { "rootY", _root_y },
    { "eventX", _event_x },
    { "eventY", _event_y },
    { NULL, NULL }
};
const CommonObject ButtonEvent = {
    "Event.Button",
    methods,
    metamethods
};
