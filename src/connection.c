#include <string.h>
#include <stdlib.h>
#include <xcb/xcb.h>
#include "common/table.h"
#include "common/xcb_common.h"
#include "screen.h"
#include "drawing.h"
#include "connection.h"

const CommonEnum ConnectionError[] = {
    { "Error", XCB_CONN_ERROR },
    { "ClosedExtNotsupported", XCB_CONN_CLOSED_EXT_NOTSUPPORTED },
    { "ClosedMemInsufficient", XCB_CONN_CLOSED_MEM_INSUFFICIENT },
    { "ClosedReqLenExceed", XCB_CONN_CLOSED_REQ_LEN_EXCEED },
    { "ClosedParseErr", XCB_CONN_CLOSED_PARSE_ERR },
    { "ClosedInvalidScreen", XCB_CONN_CLOSED_INVALID_SCREEN },
    { "ClosedFdpassingFailed", XCB_CONN_CLOSED_FDPASSING_FAILED }, 
    { NULL, -1 }
};
const CommonEnum WindowClass[] = {
    { "CopyFromParent", XCB_WINDOW_CLASS_COPY_FROM_PARENT },
    { "InputOutput", XCB_WINDOW_CLASS_INPUT_OUTPUT },
    { "InputOnly", XCB_WINDOW_CLASS_INPUT_ONLY },
    { NULL, -1 }
};
const CommonEnum CW[] = {
    { "BackPixmap", XCB_CW_BACK_PIXMAP },
    { "BackPixel", XCB_CW_BACK_PIXEL },
    { "BorderPixmap", XCB_CW_BORDER_PIXMAP },
    { "BorderPixel", XCB_CW_BORDER_PIXEL },
    { "BitGravity", XCB_CW_BIT_GRAVITY },
    { "WinGravity", XCB_CW_WIN_GRAVITY },
    { "BackingStore", XCB_CW_BACKING_STORE },
    { "BackingPlanes", XCB_CW_BACKING_PLANES },
    { "BackingPixel", XCB_CW_BACKING_PIXEL },
    { "OverrideRedirect", XCB_CW_OVERRIDE_REDIRECT },
    { "SaveUnder", XCB_CW_SAVE_UNDER },
    { "EventMask", XCB_CW_EVENT_MASK },
    { "DontPropagate", XCB_CW_DONT_PROPAGATE },
    { "Colormap", XCB_CW_COLORMAP },
    { "Cursor", XCB_CW_CURSOR },
    { NULL, -1 }
};

const CommonEnum Defines[] = {
    { "None", XCB_NONE },
    { "CopyFromParent", XCB_COPY_FROM_PARENT },
    { "CurrentTime", XCB_CURRENT_TIME },
    { "NoSymbol", XCB_NO_SYMBOL },
    { NULL, -1 }
};
const CommonEnum GC[] = {
    { "Function", XCB_GC_FUNCTION },
    { "Plane_mask", XCB_GC_PLANE_MASK },
    { "Foreground", XCB_GC_FOREGROUND },
    { "Background", XCB_GC_BACKGROUND },
    { "LineWidth", XCB_GC_LINE_WIDTH },
    { "LineStyle", XCB_GC_LINE_STYLE },
    { "CapStyle", XCB_GC_CAP_STYLE },
    { "JoinStyle", XCB_GC_JOIN_STYLE },
    { "FillStyle", XCB_GC_FILL_STYLE },
    { "FillRule", XCB_GC_FILL_RULE },
    { "Tile", XCB_GC_TILE },
    { "Stipple", XCB_GC_STIPPLE },
    { "TileStippleOriginX", XCB_GC_TILE_STIPPLE_ORIGIN_X },
    { "TileStippleOriginY", XCB_GC_TILE_STIPPLE_ORIGIN_Y },
    { "Font", XCB_GC_FONT },
    { "SubwindowMode", XCB_GC_SUBWINDOW_MODE },
    { "GraphicsExposures", XCB_GC_GRAPHICS_EXPOSURES },
    { "ClipOriginX", XCB_GC_CLIP_ORIGIN_X },
    { "ClipOriginY", XCB_GC_CLIP_ORIGIN_Y },
    { "ClipMask", XCB_GC_CLIP_MASK },
    { "DashOffset", XCB_GC_DASH_OFFSET },
    { "DashList", XCB_GC_DASH_LIST },
    { "ArcMode", XCB_GC_ARC_MODE },
    { NULL, -1 }
};

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

static int _xcb_connect(lua_State* L) {
    /*TODO: make this optional*/
	luaL_checktype(L, 1, LUA_TTABLE);
    const char* displayname = tableGetString(L, 1, "displayname");
    int screenp = (uint32_t) tableGetInt(L, 1, "screenp");
    xcb_connection_t* result = xcb_connect(displayname, &screenp);

    int error = xcb_connection_has_error(result);
    if (error) {
        return commonPushConnectionError(L, error);
    }
    return commonPush(L, "p", ConnectionName, result);
}

static int _xcb_create_screen(lua_State* L) {
    xcb_connection_t *conn = commonGetAs(L, 1, ConnectionName, xcb_connection_t *);
    xcb_screen_t *screen = xcb_setup_roots_iterator(xcb_get_setup(conn)).data;
    pushScreen(L, screen);
    return 1;
}
static int _xcb_generate_id(lua_State* L) {
    xcb_connection_t *conn = commonGetAs(L, 1, ConnectionName, xcb_connection_t *);
    xcb_window_t wid = xcb_generate_id(conn);
    return commonPush(L, "i", wid);
}

static int _xcb_create_gc(lua_State* L) {
    xcb_connection_t *conn = commonGetAs(L, 1, ConnectionName, xcb_connection_t *);
	luaL_checktype(L, 2, LUA_TTABLE);
    /*TODO: check for zero*/
    xcb_gcontext_t context = (xcb_gcontext_t) tableGetInt(L, 2, "context");
    xcb_drawable_t target = (xcb_drawable_t) tableGetInt(L, 2, "target");
    uint32_t mask;
    if (tableIsType(L, 2, "mask", LUA_TTABLE)) {
        mask = (uint32_t) tableGetEnum(L, 2, "mask");
    } else {
        mask = (uint32_t) tableGetInt(L, 2, "mask");
    }
    /*TODO: figure how to pass "array" (or use table as list) */
    uint32_t values[2];
    if (tableIsType(L, 2, "value0", LUA_TTABLE)) {
        values[0]  = (uint32_t) tableGetEnum(L, 2, "value0");
    } else {
        values[0]  = (uint32_t) tableGetInt(L, 2, "value0");
    }
    if (tableIsType(L, 2, "value1", LUA_TTABLE)) {
        values[1]  = (uint32_t) tableGetEnum(L, 2, "value1");
    } else {
        values[1]  = (uint32_t) tableGetInt(L, 2, "value1");
    }
    xcb_void_cookie_t ck = xcb_create_gc(conn, context, target, mask, values);
    xcb_generic_error_t * err = xcb_request_check(conn, ck);
    if (err != NULL) {
        char * fmt = "Some XCB error. Code: %i";
        char msg[strlen(fmt)];
        fprintf(stderr, "Some XCB error. Code: %i\n", err->error_code);
        /*fprintf(stderr, "%s\n", strerror(err->error_code));*/
        sprintf(msg, fmt, err->error_code);
        return commonPushError(L, msg);
    } else {
        return commonPush(L, "i", ck.sequence);
    }
};

static int _xcb_create_window(lua_State* L) {
    xcb_connection_t *conn = commonGetAs(L, 1, ConnectionName, xcb_connection_t *);
	luaL_checktype(L, 2, LUA_TTABLE);
    /*TODO: luasdl2 has a tableGetType wrapping the optional ones*/
    /*NOTE: if missing will be 0 which is CopyFromParent */
    uint8_t depth = (uint8_t) tableGetInt(L, 2, "depth");
    /*TODO: check for zero*/
    uint32_t wid = (uint32_t) tableGetInt(L, 2, "window");
    uint32_t parent = (uint32_t) tableGetInt(L, 2, "parent");
    int16_t x = (int16_t) tableGetInt(L, 2, "x");
    int16_t y = (int16_t) tableGetInt(L, 2, "y");
    /*TODO: check for zero?*/
    uint16_t width = (uint16_t) tableGetInt(L, 2, "width");
    uint16_t height = (uint16_t) tableGetInt(L, 2, "height");
    /*NOTE: border must be 0 if class is InputOnly
     * maybe have different methods for creating each class 
     * (and/or a warning that border is ignored for InputOnly) */
    uint16_t border = (uint16_t) tableGetInt(L, 2, "border");
    /*TODO: check for zero*/
    uint16_t class = (uint16_t) tableGetInt(L, 2, "class");
    /*TODO: check for zero*/
    uint32_t visual = (uint32_t) tableGetInt(L, 2, "visual");
    uint32_t mask;
    if (tableIsType(L, 2, "mask", LUA_TTABLE)) {
        mask = (uint32_t) tableGetEnum(L, 2, "mask");
    } else {
        mask = (uint32_t) tableGetInt(L, 2, "mask");
    }
    /*TODO: figure how to pass "array" (or use table as list) */
    uint32_t values[2];
    if (tableIsType(L, 2, "value0", LUA_TTABLE)) {
        values[0]  = (uint32_t) tableGetEnum(L, 2, "value0");
    } else {
        values[0]  = (uint32_t) tableGetInt(L, 2, "value0");
    }
    if (tableIsType(L, 2, "value1", LUA_TTABLE)) {
        values[1]  = (uint32_t) tableGetEnum(L, 2, "value1");
    } else {
        values[1]  = (uint32_t) tableGetInt(L, 2, "value1");
    }
    /*TODO: what to do with void cookie */
    xcb_void_cookie_t ck = xcb_create_window(conn, depth, wid, parent,
            x, y, width, height, border,
            class, visual, mask, values);
    xcb_generic_error_t * err = xcb_request_check(conn, ck);
    if (err != NULL) {
        char * fmt = "Some XCB error. Code: %i";
        char msg[strlen(fmt)];
        fprintf(stderr, "Some XCB error. Code: %i\n", err->error_code);
        sprintf(msg, fmt, err->error_code);
        return commonPushError(L, msg);
    } else {
        return commonPush(L, "i", ck.sequence);
    }
};

static int _xcb_map_window(lua_State* L) {
    xcb_connection_t *conn = commonGetAs(L, 1, ConnectionName, xcb_connection_t *);
    uint32_t wid = (uint32_t) luaL_checkinteger(L, 2);
    xcb_void_cookie_t ck = xcb_map_window(conn, wid);
    xcb_generic_error_t * err = xcb_request_check(conn, ck);
    if (err != NULL) {
        char * fmt = "Some XCB error. Code: %i";
        char msg[strlen(fmt)];
        fprintf(stderr, "Some XCB error. Code: %i\n", err->error_code);
        sprintf(msg, fmt, err->error_code);
        return commonPushError(L, msg);
    } else {
        return commonPush(L, "i", ck.sequence);
    }
};

static int _xcb_flush(lua_State* L) {
    xcb_connection_t *conn = commonGetAs(L, 1, ConnectionName, xcb_connection_t *);
    int i = xcb_flush(conn);
    if (i <= 0) {
        // TODO: figure out string memory allocation passing string 
        // back to lua
        /*char * fmt = "Some XCB error. Code: %i";*/
        /*char msg[strlen(fmt)];*/
        /*fprintf(stderr, "Some XCB error. Code: %i\n", i);*/
        /*sprintf(msg, fmt, i);*/

        return commonPushError(L, "Flush Error");
    } else {
        return commonPush(L, "b", 1);
    }
    return 0;
};

static int _xcb_has_error(lua_State* L) {
    xcb_connection_t *conn = commonGetAs(L, 1, ConnectionName, xcb_connection_t *);
    int flag = xcb_connection_has_error(conn);
    return commonPush(L, "b", flag);
};
static int _xcb_check_error(lua_State* L) {
    xcb_connection_t *conn = commonGetAs(L, 1, ConnectionName, xcb_connection_t *);
    int error = xcb_connection_has_error(conn);
    if (error) {
        return commonPushConnectionError(L, error);
    }
    return commonPush(L, "b", 1);
};
static int _xcb_get_file_descriptor(lua_State* L) {
    xcb_connection_t *conn = commonGetAs(L, 1, ConnectionName, xcb_connection_t *);
    int fd = xcb_get_file_descriptor(conn);
    return commonPush(L, "i", fd);
};

static int POINTER_EVENT = XCB_BUTTON_PRESS | XCB_BUTTON_RELEASE | XCB_MOTION_NOTIFY | XCB_ENTER_NOTIFY | XCB_LEAVE_NOTIFY;
static int KEY_EVENT = XCB_KEY_PRESS | XCB_KEY_RELEASE;
static int WINDOW_EVENT = XCB_EXPOSE;
static void push_event(lua_State* L, xcb_generic_event_t* evt) {
    if (evt->response_type | POINTER_EVENT) {
        pushButtonEvent(L, (xcb_button_press_event_t *) evt);
    } else if (evt->response_type | KEY_EVENT) {
        pushKeyEvent(L, (xcb_key_press_event_t *) evt);
    } else if (evt->response_type | WINDOW_EVENT) {
        pushExposeEvent(L, (xcb_expose_event_t *) evt);
    } else if (evt->response_type == 0) {
        pushErrorEvent(L, (xcb_generic_error_t *) evt);
    } else {
        pushEvent(L, evt);
    }
}

static int _xcb_wait_for_event(lua_State* L) {
    xcb_connection_t *conn = commonGetAs(L, 1, ConnectionName, xcb_connection_t *);
    xcb_generic_event_t* evt = xcb_wait_for_event(conn);
    push_event(L, evt);
    free(evt);
    return 1;
}

static int _xcb_poll_for_event(lua_State* L) {
    xcb_connection_t *conn = commonGetAs(L, 1, ConnectionName, xcb_connection_t *);
    xcb_generic_event_t* evt = xcb_poll_for_event(conn);
    if (evt == NULL) {
        return commonPush(L, "n");
    } else {
        push_event(L, evt);
        free(evt);
        return 1;
    }
}

static int _xcb_disconnect(lua_State* L) {
    printf("GC: xcb_disconnect\n");
    CommonUserdata *conn = commonGetUserdata(L, 1, ConnectionName);
    /*if (path->mustdelete) {*/
    xcb_disconnect(conn->data);
    /*}*/

    return 0;
};

const luaL_Reg ConnectionFunctions[] = {
    { "xcbConnect", _xcb_connect },
    { NULL, NULL }
};

static const luaL_Reg methods[] = {
    { "generateId", _xcb_generate_id },
    { "createWindow", _xcb_create_window },
    { "createGC", _xcb_create_gc },
    { "mapWindow", _xcb_map_window },
    { "flush", _xcb_flush },
    { "hasError", _xcb_has_error },
    { "checkError", _xcb_check_error },
    { "getFileDescriptor", _xcb_get_file_descriptor },
    { "waitForEvent", _xcb_wait_for_event },
    { "pollForEvent", _xcb_poll_for_event },
    { "createScreen", _xcb_create_screen },
    /* drawing */
    { "imageText8", _xcb_image_text_8 },
    { "polyRectangle", _xcb_poly_rectangle },
    { NULL, NULL }
};

static const luaL_Reg metamethods[] = {
    { "__gc", _xcb_disconnect },
    { NULL, NULL }
};

const CommonObject Connection = {
    "XCB.Connection",
    methods,
    metamethods
};
