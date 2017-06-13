#include <stdlib.h>
#include <xcb/xcb.h>
#include "common/table.h"
#include "screen.h"

void pushScreen(lua_State *L, const xcb_screen_t *screen)
{
	lua_createtable(L, 0, 0);
    tableSetInt(L, -1, "root", screen->root);
    tableSetInt(L, -1, "white_pixel", screen->white_pixel);
    tableSetInt(L, -1, "black_pixel", screen->black_pixel);
    tableSetInt(L, -1, "current_input_masks", screen->current_input_masks);
    tableSetInt(L, -1, "width_in_pixels", screen->width_in_pixels);
    tableSetInt(L, -1, "height_in_pixels", screen->height_in_pixels);
    tableSetInt(L, -1, "width_in_millimeters", screen->width_in_millimeters);
    tableSetInt(L, -1, "height_in_millimeters", screen->height_in_millimeters);
    tableSetInt(L, -1, "min_installed_maps", screen->min_installed_maps);
    tableSetInt(L, -1, "max_installed_maps", screen->max_installed_maps);
    tableSetInt(L, -1, "root_visual", screen->root_visual);
    tableSetInt(L, -1, "backing_stores", screen->backing_stores);
    tableSetInt(L, -1, "save_unders", screen->save_unders);
    tableSetInt(L, -1, "root_depth", screen->root_depth);
    tableSetInt(L, -1, "allowed_depths_len", screen->allowed_depths_len);
}
