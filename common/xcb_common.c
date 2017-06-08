#include <stdlib.h>
#include <string.h>
#include "xcb_common.h"

/*int
commonPushCairoError(lua_State *L, cairo_status_t status)
{
    lua_pushnil(L);
    lua_pushstring(L, cairo_status_to_string(status));
    return 2;
}*/

CommonUserdata *
commonGetUserdataBase(lua_State *L, int index, const char *tname)
{
    int type = luaL_getmetafield(L, index, "__name");
    if (type == LUA_TSTRING) {
        const int len = strlen(tname);
        const char * name = lua_tostring (L, -1);
        if (strncmp(name,tname,len) == 0) {
            /*TODO: how to pop name off the stack?*/
            lua_remove(L,-1);
            return lua_touserdata(L, index);
        } else {
            printf("Type error. Expected %s, found %s", tname, name);
            luaL_error(L, "Type error. Expected %s, found %s", tname, name);
            return NULL;
        }
    }
    luaL_error(L, "Type error. Expected %s", tname);
    return NULL;
}


void
commonExtendObject(lua_State *L, const CommonObject *base, const CommonObject *def)
{
	luaL_newmetatable(L, def->name);

	if (base->metamethods != NULL) {
#if LUA_VERSION_NUM >= 502
            luaL_setfuncs(L, base->metamethods, 0);
#else
            luaL_register(L, NULL, base->metamethods);
#endif
	}
	if (def->metamethods != NULL) {
#if LUA_VERSION_NUM >= 502
            luaL_setfuncs(L, def->metamethods, 0);
#else
            luaL_register(L, NULL, def->metamethods);
#endif
	}

	if (base->methods != NULL) {
            lua_createtable(L, 0, 0);
#if LUA_VERSION_NUM >= 502
            luaL_setfuncs(L, base->methods, 0);
#else
            luaL_register(L, NULL, base->methods);
#endif
            if (def->methods != NULL) {
#if LUA_VERSION_NUM >= 502
		luaL_setfuncs(L, def->methods, 0);
#else
		luaL_register(L, NULL, def->methods);
#endif
            }
            lua_setfield(L, -2, "__index");
	}

	lua_pop(L, 1);
}
