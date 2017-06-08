#include <stdlib.h>
#include <xcb/xcb.h>
#include "common/table.h"
#include "window_event.h"


static int _expose_x(lua_State* L) {
    xcb_expose_event_t *evt = commonGetAs(L, 1, WindowEventName, xcb_expose_event_t *);
    return commonPush(L, "i", evt->x);
};
static int _expose_y(lua_State* L) {
    xcb_expose_event_t *evt = commonGetAs(L, 1, WindowEventName, xcb_expose_event_t *);
    return commonPush(L, "i", evt->y);
};
static int _expose_width(lua_State* L) {
    xcb_expose_event_t *evt = commonGetAs(L, 1, WindowEventName, xcb_expose_event_t *);
    return commonPush(L, "i", evt->width);
};
static int _expose_height(lua_State* L) {
    xcb_expose_event_t *evt = commonGetAs(L, 1, WindowEventName, xcb_expose_event_t *);
    return commonPush(L, "i", evt->height);
};
static int _expose_count(lua_State* L) {
    xcb_expose_event_t *evt = commonGetAs(L, 1, WindowEventName, xcb_expose_event_t *);
    return commonPush(L, "i", evt->count);
};

static int _free_event(lua_State* L) {
    xcb_expose_event_t *evt = commonGetAs(L, 1, WindowEventName, xcb_expose_event_t *);
    free(evt);

    return 0;
};


static const luaL_Reg expose_methods[] = {
    { "getX", _expose_x },
    { "getY", _expose_y },
    { "getWidth", _expose_width },
    { "getHeight", _expose_height },
    { "getCount", _expose_count },
    { NULL, NULL }
};

static const luaL_Reg metamethods[] = {
    { "__gc", _free_event },
    { NULL, NULL }
};

static const luaL_Reg methods[] = {
    { NULL, NULL }
};

const CommonObject WindowEvent = {
    "Event.Window",
    methods,
    metamethods
};
