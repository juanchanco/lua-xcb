#include <string.h>
#include <stdlib.h>
#include <xcb/xcb.h>
#include "common/table.h"
#include "common/xcb_common.h"
#include "event.h"
#include "key_event.h"
#include "button_event.h"
#include "window_event.h"
#include "screen.h"
#include "visual.h"
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
    /*TODO: unwrap the two calls*/
    xcb_connection_t *conn = commonGetAs(L, 1, ConnectionName, xcb_connection_t *);
    /*TODO: malloc and copy this?*/
    xcb_screen_t *screen = xcb_setup_roots_iterator(xcb_get_setup(conn)).data;
    /*xcb_screen_t *cpy = malloc(sizeof(xcb_screen_t));*/
    /*memcpy(screen,cpy,sizeof(xcb_screen_t));*/

    return commonPush(L, "p", ScreenName, screen);
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
static int push_event(lua_State* L, xcb_generic_event_t* evt) {
    if (evt->response_type | POINTER_EVENT) {
        return commonPush(L, "p", ButtonEventName, evt);
    } else if (evt->response_type | KEY_EVENT) {
        return commonPush(L, "p", KeyEventName, evt);
    } else if (evt->response_type | WINDOW_EVENT) {
        return commonPush(L, "p", WindowEventName, evt);
    } else {
        return commonPush(L, "p", EventName, evt);
    }
}

static int _xcb_wait_for_event(lua_State* L) {
    xcb_connection_t *conn = commonGetAs(L, 1, ConnectionName, xcb_connection_t *);
    xcb_generic_event_t* evt = xcb_wait_for_event(conn);
    return push_event(L, evt);
}

static int _xcb_poll_for_event(lua_State* L) {
    xcb_connection_t *conn = commonGetAs(L, 1, ConnectionName, xcb_connection_t *);
    xcb_generic_event_t* evt = xcb_poll_for_event(conn);
    if (evt == NULL) {
        return commonPush(L, "n");
    } else {
        return push_event(L, evt);
    }
}

static xcb_visualtype_t *find_visual(xcb_connection_t *c, xcb_visualid_t visual) {
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

static int _find_visual(lua_State* L) {
    xcb_connection_t *conn = commonGetAs(L, 1, ConnectionName, xcb_connection_t *);
    xcb_screen_t *screen = commonGetAs(L, 2, ScreenName, xcb_screen_t *);
    xcb_visualtype_t* result = find_visual(conn, screen->root_visual);
    if (!result) {
        return commonPushError(L, "find_visual failed");
    }
    return commonPush(L, "p", VisualName, result);
};

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
    { "findVisual", _find_visual },
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
