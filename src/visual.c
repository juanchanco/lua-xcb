#include <stdlib.h>
#include <xcb/xcb.h>
#include "common/table.h"
#include "visual.h"


static const luaL_Reg metamethods[] = {
    { NULL, NULL }
};

static const luaL_Reg methods[] = {
    { NULL, NULL }
};

const CommonObject Visual = {
    "Visual",
    methods,
    metamethods
};

