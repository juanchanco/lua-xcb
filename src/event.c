#include <stdlib.h>
#include <xcb/xcb.h>
#include "common/table.h"
#include "common/xcb_common.h"
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



void pushEvent(lua_State *L, const xcb_generic_event_t *evt)
{
    lua_createtable(L, 0, 0);
    tableSetInt(L, -1, "response_type", evt->response_type);
    tableSetInt(L, -1, "sequence", evt->sequence);
}

void pushErrorEvent(lua_State *L, const xcb_generic_error_t *evt)
{
    pushEvent(L, (xcb_generic_event_t *) evt);
    /*tableSetString(L, -1, "name", "Error");*/
    tableSetInt(L, -1, "error_code", evt->error_code);
}

void pushExposeEvent(lua_State *L, const xcb_expose_event_t *evt)
{
    pushEvent(L, (xcb_generic_event_t *) evt);
    /*tableSetString(L, -1, "name", "Expose");*/
    tableSetInt(L, -1, "x", evt->x);
    tableSetInt(L, -1, "y", evt->y);
    tableSetInt(L, -1, "width", evt->width);
    tableSetInt(L, -1, "height", evt->height);
    tableSetInt(L, -1, "count", evt->count);
}

void pushButtonEvent(lua_State *L, const xcb_button_press_event_t *evt)
{
    pushEvent(L, (xcb_generic_event_t *) evt);
    tableSetInt(L, -1, "time", evt->time);
    tableSetInt(L, -1, "state", evt->state);
    tableSetInt(L, -1, "root_x", evt->root_x);
    tableSetInt(L, -1, "root_y", evt->root_y);
    tableSetInt(L, -1, "event_x", evt->event_x);
    tableSetInt(L, -1, "event_y", evt->event_y);
}

void pushKeyEvent(lua_State *L, const xcb_key_press_event_t *evt)
{
    pushEvent(L, (xcb_generic_event_t *) evt);
    tableSetInt(L, -1, "time", evt->time);
    tableSetInt(L, -1, "state", evt->state);
    tableSetInt(L, -1, "detail", evt->detail);
}

