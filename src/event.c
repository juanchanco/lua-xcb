#include <stdlib.h>
#include <xcb/xcb.h>
#include "common/table.h"
/*#include "connection.h"*/
#include "event.h"

const CommonEnum EventType[] = {
  { "KeyPress", XCB_KEY_PRESS },
  { "KeyRelease", XCB_KEY_RELEASE },
  { "ButtonPress", XCB_BUTTON_PRESS },
  { "ButtonRelease", XCB_BUTTON_RELEASE },
  { "MotionNotify", XCB_MOTION_NOTIFY },
  { "EnterNotify", XCB_ENTER_NOTIFY },
  { "LeaveNotify", XCB_LEAVE_NOTIFY },
  { "FocusIn", XCB_FOCUS_IN },
  { "FocusOut", XCB_FOCUS_OUT },
  { "KeymapNotify", XCB_KEYMAP_NOTIFY },
  { "Expose", XCB_EXPOSE },
  { "GraphicsExposure", XCB_GRAPHICS_EXPOSURE },
  { "NoExposure", XCB_NO_EXPOSURE },
  { "VisibilityNotify", XCB_VISIBILITY_NOTIFY },
  { "CreateNotify", XCB_CREATE_NOTIFY },
  { "DestroyNotify", XCB_DESTROY_NOTIFY },
  { "UnmapNotify", XCB_UNMAP_NOTIFY },
  { "MapNotify", XCB_MAP_NOTIFY },
  { "MapRequest", XCB_MAP_REQUEST },
  { "ReparentNotify", XCB_REPARENT_NOTIFY },
  { "ConfigureNotify", XCB_CONFIGURE_NOTIFY },
  { "ConfigureRequest", XCB_CONFIGURE_REQUEST },
  { "GravityNotify", XCB_GRAVITY_NOTIFY },
  { "ResizeRequest", XCB_RESIZE_REQUEST },
  { "CirculateNotify", XCB_CIRCULATE_NOTIFY },
  { "CirculateRequest", XCB_CIRCULATE_REQUEST },
  { "PropertyNotify", XCB_PROPERTY_NOTIFY },
  { "SelectionClear", XCB_SELECTION_CLEAR },
  { "SelectionRequest", XCB_SELECTION_REQUEST },
  { "SelectionNotify", XCB_SELECTION_NOTIFY },
  { "ColormapNotify", XCB_COLORMAP_NOTIFY },
  { "ClientMessage", XCB_CLIENT_MESSAGE },
  { "MappingNotify", XCB_MAPPING_NOTIFY },
  /*{ "GeGeneric", XCB_GE_GENERIC },*/
  { NULL, -1 }
};
const CommonEnum EventMask[] = {
  { "NoEvent", XCB_EVENT_MASK_NO_EVENT },
  { "KeyPress", XCB_EVENT_MASK_KEY_PRESS },
  { "KeyRelease", XCB_EVENT_MASK_KEY_RELEASE },
  { "ButtonPress", XCB_EVENT_MASK_BUTTON_PRESS },
  { "ButtonRelease", XCB_EVENT_MASK_BUTTON_RELEASE },
  { "EnterWindow", XCB_EVENT_MASK_ENTER_WINDOW },
  { "LeaveWindow", XCB_EVENT_MASK_LEAVE_WINDOW },
  { "PointerMotion", XCB_EVENT_MASK_POINTER_MOTION },
  { "PointerMotionHint", XCB_EVENT_MASK_POINTER_MOTION_HINT },
  { "Button1Motion", XCB_EVENT_MASK_BUTTON_1_MOTION },
  { "Button2Motion", XCB_EVENT_MASK_BUTTON_2_MOTION },
  { "Button3Motion", XCB_EVENT_MASK_BUTTON_3_MOTION },
  { "Button4Motion", XCB_EVENT_MASK_BUTTON_4_MOTION },
  { "Button5Motion", XCB_EVENT_MASK_BUTTON_5_MOTION },
  { "ButtonMotion", XCB_EVENT_MASK_BUTTON_MOTION },
  { "KeymapState", XCB_EVENT_MASK_KEYMAP_STATE },
  { "Exposure", XCB_EVENT_MASK_EXPOSURE },
  { "VisibilityChange", XCB_EVENT_MASK_VISIBILITY_CHANGE },
  { "StructureNotify", XCB_EVENT_MASK_STRUCTURE_NOTIFY },
  { "ResizeRedirect", XCB_EVENT_MASK_RESIZE_REDIRECT },
  { "SubstructureNotify", XCB_EVENT_MASK_SUBSTRUCTURE_NOTIFY },
  { "SubstructureRedirect", XCB_EVENT_MASK_SUBSTRUCTURE_REDIRECT },
  { "FocusChange", XCB_EVENT_MASK_FOCUS_CHANGE },
  { "PropertyChange", XCB_EVENT_MASK_PROPERTY_CHANGE },
  { "ColorMapChange", XCB_EVENT_MASK_COLOR_MAP_CHANGE },
  { "OwnerGrabButton", XCB_EVENT_MASK_OWNER_GRAB_BUTTON },
  { NULL, -1 }
};


static int _response_type(lua_State* L) {
    xcb_generic_event_t *evt = commonGetAs(L, 1, EventName, xcb_generic_event_t *);
    return commonPush(L, "i", evt->response_type & ~0x80);
};
/*static int _detail(lua_State* L) {*/
    /*xcb_generic_event_t *evt = commonGetAs(L, 1, EventName, xcb_generic_event_t *);*/
    /*return commonPush(L, "i", evt->pad0);*/
/*};*/
static int _sequence(lua_State* L) {
    xcb_generic_event_t *evt = commonGetAs(L, 1, EventName, xcb_generic_event_t *);
    return commonPush(L, "i", evt->sequence);
};



static int _expose_x(lua_State* L) {
    xcb_expose_event_t *evt = commonGetAs(L, 1, EventName, xcb_expose_event_t *);
    return commonPush(L, "i", evt->x);
};
static int _expose_y(lua_State* L) {
    xcb_expose_event_t *evt = commonGetAs(L, 1, EventName, xcb_expose_event_t *);
    return commonPush(L, "i", evt->y);
};
static int _expose_width(lua_State* L) {
    xcb_expose_event_t *evt = commonGetAs(L, 1, EventName, xcb_expose_event_t *);
    return commonPush(L, "i", evt->width);
};
static int _expose_height(lua_State* L) {
    xcb_expose_event_t *evt = commonGetAs(L, 1, EventName, xcb_expose_event_t *);
    return commonPush(L, "i", evt->height);
};
static int _expose_count(lua_State* L) {
    xcb_expose_event_t *evt = commonGetAs(L, 1, EventName, xcb_expose_event_t *);
    return commonPush(L, "i", evt->count);
};




/*static int _error_code(lua_State* L) {
    xcb_generic_error_t *evt = commonGetAs(L, 1, EventName, xcb_generic_error_t *);
    return commonPush(L, "i", evt->error_code);
};*/

static int _free_event(lua_State* L) {
    xcb_generic_event_t *evt = commonGetAs(L, 1, EventName, xcb_generic_event_t *);
    free(evt);

    return 0;
};

static const luaL_Reg metamethods[] = {
    { "__gc", _free_event },
    { NULL, NULL }
};

/*TODO: different objects for different event types?*/
static const luaL_Reg methods[] = {
    { "getResonseType", _response_type },
    { "getSequence", _sequence },
    /*{ "getErrorCode", _error_code },*/
    { NULL, NULL }
};

const CommonObject Event = {
    "Event",
    methods,
    metamethods
};

static const luaL_Reg expose_methods[] = {
    { "getX", _expose_x },
    { "getY", _expose_y },
    { "getWidth", _expose_width },
    { "getHeight", _expose_height },
    { "getCount", _expose_count },
    { NULL, NULL }
};
const CommonObject ExposeEvent = {
    "Event.Expose",
    expose_methods,
    metamethods
};
