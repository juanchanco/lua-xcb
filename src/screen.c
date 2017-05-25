#include <stdlib.h>
#include <xcb/xcb.h>
#include "common/table.h"
#include "screen.h"

/*typedef struct xcb_screen_t {
    xcb_window_t   root; [>*<  <]
    xcb_colormap_t default_colormap; [>*<  <]
    uint32_t       white_pixel; [>*<  <]
    uint32_t       black_pixel; [>*<  <]
    uint32_t       current_input_masks; [>*<  <]
    uint16_t       width_in_pixels; [>*<  <]
    uint16_t       height_in_pixels; [>*<  <]
    uint16_t       width_in_millimeters; [>*<  <]
    uint16_t       height_in_millimeters; [>*<  <]
    uint16_t       min_installed_maps; [>*<  <]
    uint16_t       max_installed_maps; [>*<  <]
    xcb_visualid_t root_visual; [>*<  <]
    uint8_t        backing_stores; [>*<  <]
    uint8_t        save_unders; [>*<  <]
    uint8_t        root_depth; [>*<  <]
    uint8_t        allowed_depths_len; [>*<  <]
} xcb_screen_t;*/

static int _root(lua_State* L) {
    xcb_screen_t* screen = commonGetAs(L, 1, ScreenName, xcb_screen_t *);
    return commonPush(L, "i", screen->root);
}
static int _white_pixel(lua_State* L) {
    xcb_screen_t* screen = commonGetAs(L, 1, ScreenName, xcb_screen_t *);
    return commonPush(L, "i", screen->white_pixel);
}
static int _black_pixel(lua_State* L) {
    xcb_screen_t* screen = commonGetAs(L, 1, ScreenName, xcb_screen_t *);
    return commonPush(L, "i", screen->black_pixel);
}
static int _current_input_masks(lua_State* L) {
    xcb_screen_t* screen = commonGetAs(L, 1, ScreenName, xcb_screen_t *);
    return commonPush(L, "i", screen->current_input_masks);
}
static int _width_in_pixels(lua_State* L) {
    xcb_screen_t* screen = commonGetAs(L, 1, ScreenName, xcb_screen_t *);
    return commonPush(L, "i", screen->width_in_pixels);
}
static int _height_in_pixels(lua_State* L) {
    xcb_screen_t* screen = commonGetAs(L, 1, ScreenName, xcb_screen_t *);
    return commonPush(L, "i", screen->height_in_pixels);
}
static int _width_in_millimeters(lua_State* L) {
    xcb_screen_t* screen = commonGetAs(L, 1, ScreenName, xcb_screen_t *);
    return commonPush(L, "i", screen->width_in_millimeters);
}
static int _height_in_millimeters(lua_State* L) {
    xcb_screen_t* screen = commonGetAs(L, 1, ScreenName, xcb_screen_t *);
    return commonPush(L, "i", screen->height_in_millimeters);
}
static int _min_installed_maps(lua_State* L) {
    xcb_screen_t* screen = commonGetAs(L, 1, ScreenName, xcb_screen_t *);
    return commonPush(L, "i", screen->min_installed_maps);
}
static int _max_installed_maps(lua_State* L) {
    xcb_screen_t* screen = commonGetAs(L, 1, ScreenName, xcb_screen_t *);
    return commonPush(L, "i", screen->max_installed_maps);
}
static int _root_visual(lua_State* L) {
    xcb_screen_t* screen = commonGetAs(L, 1, ScreenName, xcb_screen_t *);
    return commonPush(L, "i", screen->root_visual);
}
static int _backing_stores(lua_State* L) {
    xcb_screen_t* screen = commonGetAs(L, 1, ScreenName, xcb_screen_t *);
    return commonPush(L, "i", screen->backing_stores);
}
static int _save_unders(lua_State* L) {
    xcb_screen_t* screen = commonGetAs(L, 1, ScreenName, xcb_screen_t *);
    return commonPush(L, "i", screen->save_unders);
}
static int _root_depth(lua_State* L) {
    xcb_screen_t* screen = commonGetAs(L, 1, ScreenName, xcb_screen_t *);
    return commonPush(L, "i", screen->root_depth);
}
static int _allowed_depths_len(lua_State* L) {
    xcb_screen_t* screen = commonGetAs(L, 1, ScreenName, xcb_screen_t *);
    return commonPush(L, "i", screen->allowed_depths_len);
}

/*static int _free(lua_State* L) {
    xcb_screen_t *evt = commonGetAs(L, 1, ScreenName, xcb_screen_t *);
    free(evt);
    return 0;
};*/

static const luaL_Reg metamethods[] = {
    /*TODO: does screen need to be freed (giving an error*/
    /*{ "__gc", _free },*/
    { NULL, NULL }
};

static const luaL_Reg methods[] = {
    { "getRoot", _root },
    { "getWhitePixel", _white_pixel },
    { "getBlackPixel", _black_pixel },
    { "getCurrentInputMasks", _current_input_masks },
    { "getWidthInPixels", _width_in_pixels },
    { "getHeightInPixels", _height_in_pixels },
    { "getWidthInMillimeters", _width_in_millimeters },
    { "getHeightInMillimeters", _height_in_millimeters },
    { "getMinInstalledMaps", _min_installed_maps },
    { "getMaxInstalledMaps", _max_installed_maps },
    { "getRootVisual", _root_visual },
    { "getBackingStores", _backing_stores },
    { "getSaveUnders", _save_unders },
    { "getRootDepth", _root_depth },
    { "getAllowedDepthsLen", _allowed_depths_len },
    { NULL, NULL }
};

const CommonObject Screen = {
    "Screen",
    methods,
    metamethods
};
