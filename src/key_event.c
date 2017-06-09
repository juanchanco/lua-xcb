#include <stdlib.h>
#include <xcb/xcb.h>
#include "common/table.h"
#include "key_event.h"

const CommonEnum EventModMask[] = {
  { "Shift", XCB_MOD_MASK_SHIFT },
  { "Lock", XCB_MOD_MASK_LOCK },
  { "Control", XCB_MOD_MASK_CONTROL },
  { "Mod1", XCB_MOD_MASK_1 },
  { "Mod2", XCB_MOD_MASK_2 },
  { "Mod3", XCB_MOD_MASK_3 },
  { "Mod4", XCB_MOD_MASK_4 },
  { "Mod5", XCB_MOD_MASK_5 },
  { "Any", XCB_MOD_MASK_ANY },
  { NULL, -1 }
};

static int _key_keycode(lua_State* L) {
    xcb_key_press_event_t *evt = commonGetAs(L, 1, KeyEventName, xcb_key_press_event_t *);
    return commonPush(L, "i", evt->detail);
};
static int _key_press_timestamp(lua_State* L) {
    xcb_key_press_event_t *evt = commonGetAs(L, 1, KeyEventName, xcb_key_press_event_t *);
    return commonPush(L, "i", evt->time);
};
static int _key_press_state(lua_State* L) {
    xcb_key_press_event_t *evt = commonGetAs(L, 1, KeyEventName, xcb_key_press_event_t *);
    return commonPush(L, "i", evt->state);
};
static int _key_shift(lua_State* L) {
    xcb_key_press_event_t *evt = commonGetAs(L, 1, KeyEventName, xcb_key_press_event_t *);
    return commonPush(L, "b", evt->state & XCB_MOD_MASK_SHIFT);
};
static int _key_lock(lua_State* L) {
    xcb_key_press_event_t *evt = commonGetAs(L, 1, KeyEventName, xcb_key_press_event_t *);
    return commonPush(L, "b", evt->state & XCB_MOD_MASK_LOCK);
};
static int _key_control(lua_State* L) {
    xcb_key_press_event_t *evt = commonGetAs(L, 1, KeyEventName, xcb_key_press_event_t *);
    return commonPush(L, "b", evt->state & XCB_MOD_MASK_CONTROL);
};
static int _key_mod_1(lua_State* L) {
    xcb_key_press_event_t *evt = commonGetAs(L, 1, KeyEventName, xcb_key_press_event_t *);
    return commonPush(L, "b", evt->state & XCB_MOD_MASK_1);
};
static int _key_mod_2(lua_State* L) {
    xcb_key_press_event_t *evt = commonGetAs(L, 1, KeyEventName, xcb_key_press_event_t *);
    return commonPush(L, "b", evt->state & XCB_MOD_MASK_2);
};
static int _key_mod_3(lua_State* L) {
    xcb_key_press_event_t *evt = commonGetAs(L, 1, KeyEventName, xcb_key_press_event_t *);
    return commonPush(L, "b", evt->state & XCB_MOD_MASK_3);
};
static int _key_mod_4(lua_State* L) {
    xcb_key_press_event_t *evt = commonGetAs(L, 1, KeyEventName, xcb_key_press_event_t *);
    return commonPush(L, "b", evt->state & XCB_MOD_MASK_4);
};
static int _key_mod_5(lua_State* L) {
    xcb_key_press_event_t *evt = commonGetAs(L, 1, KeyEventName, xcb_key_press_event_t *);
    return commonPush(L, "b", evt->state & XCB_MOD_MASK_5);
};
static int _key_mod_any(lua_State* L) {
    xcb_key_press_event_t *evt = commonGetAs(L, 1, KeyEventName, xcb_key_press_event_t *);
    return commonPush(L, "b", evt->state & XCB_MOD_MASK_ANY);
};


static const luaL_Reg metamethods[] = {
    { NULL, NULL }
};

static const luaL_Reg methods[] = {
    { "getTime", _key_press_timestamp },
    { "getState", _key_press_state },
    { "keyCode", _key_keycode },
    { "shift", _key_shift },
    { "lock", _key_lock },
    { "control", _key_control },
    { "mod1", _key_mod_1 },
    { "mod2", _key_mod_2 },
    { "mod3", _key_mod_3 },
    { "mod4", _key_mod_4 },
    { "mod5", _key_mod_5 },
    { "anyMod", _key_mod_any },
    { NULL, NULL }
};

const CommonObject KeyEvent = {
    "Event.Key",
    methods,
    metamethods
};
