#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include <config.h>

#include <xcb/xcb.h>
#include "common/common.h"
#include "common/table.h"

#include "connection.h"
#include "drawing.h"

int _xcb_image_text_8(lua_State* L) {
    xcb_connection_t *conn = commonGetAs(L, 1, ConnectionName, xcb_connection_t *);
	luaL_checktype(L, 2, LUA_TTABLE);
    /*TODO: check for zero*/
    xcb_gcontext_t context = (xcb_gcontext_t) tableGetInt(L, 2, "context");
    xcb_drawable_t target = (xcb_drawable_t) tableGetInt(L, 2, "target");
    int16_t x = (int16_t) tableGetInt(L, 2, "x");
    int16_t y = (int16_t) tableGetInt(L, 2, "y");
    const char* string = tableGetString(L, 2, "text");
    int16_t len = 0;
	if (tableIsType(L, 1, "len", LUA_TNUMBER)) {
        len = (int16_t) tableGetInt(L, 2, "len");
    } else {
        len = strlen(string);
        len = len < 255 ? len : 255;
    }
    xcb_image_text_8(conn, len, target, context, x, y, string);
    return 0;
};
/*typedef struct xcb_rectangle_t {
    int16_t  x;
    int16_t  y;
    uint16_t width;
    uint16_t height;
} xcb_rectangle_t;*/

int _xcb_poly_rectangle(lua_State* L) {
    /*TODO: pass rects as tables*/
    xcb_rectangle_t rectangles[] = {
        {40, 40, 20, 20},
    };
    xcb_connection_t *conn = commonGetAs(L, 1, ConnectionName, xcb_connection_t *);
	luaL_checktype(L, 2, LUA_TTABLE);
    /*TODO: check for zero*/
    xcb_gcontext_t context = (xcb_gcontext_t) tableGetInt(L, 2, "context");
    xcb_drawable_t target = (xcb_drawable_t) tableGetInt(L, 2, "target");
    xcb_poly_rectangle (conn, target, context, 1, rectangles);
    return 0;
};
