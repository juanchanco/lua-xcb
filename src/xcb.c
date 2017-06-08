#include <stdio.h>
#include <stdlib.h>

#include <config.h>

#include <xcb/xcb.h>
#include "common/common.h"
#include "common/xcb_common.h"
#include "common/table.h"
#include "event.h"
#include "key_event.h"
#include "button_event.h"
#include "screen.h"
#include "connection.h"


static const luaL_Reg functions[] = {
    { NULL, NULL }
};

static const struct {
    const luaL_Reg *functions;
} libraries[] = {
    { ConnectionFunctions },
    { NULL }
};

static const struct {
    const char	*name;
    const CommonEnum *values;
} enums[] = {
    { "ConnectionError", ConnectionError },
    { "WindowClass", WindowClass },
    { "CW", CW },
    { "Defines", Defines },
    { "EventType", EventType },
    { "EventMask", EventMask },
    { "GraphicsContext", GC },
    { NULL, NULL }
};

static const struct {
	const CommonObject *object;
} objects[] = {
    { &Connection },
    { &Visual },
    { &Event },
    { &Screen },
    { NULL }
};


int EXPORT
luaopen_XCB(lua_State *L)
{
    int i;

    commonNewLibrary(L, functions);

    for (i = 0; libraries[i].functions != NULL; ++i)
        commonBindLibrary(L, libraries[i].functions);

    for (i = 0; enums[i].values != NULL; ++i)
        commonBindEnum(L, -1, enums[i].name, enums[i].values);

    for (i = 0; objects[i].object != NULL; ++i)
        commonBindObject(L, objects[i].object);

    commonExtendObject(L, &Event, &KeyEvent);
    commonExtendObject(L, &Event, &ButtonEvent);
    
    return 1;
}
