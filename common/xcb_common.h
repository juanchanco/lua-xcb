//#include <cairo.h>
#include "common.h"

#ifndef _XCB_COMMON_H_
#define _XCB_COMMON_H_

//int
//commonPushCairoError(lua_State *L, cairo_status_t status);

CommonUserdata *
commonGetUserdataBase(lua_State *L, int index, const char *tname);


void
commonExtendObject(lua_State *L, const CommonObject *base, const CommonObject *def);

#define commonGetAsBase(L, index, name, type)				\
	((type)commonGetUserdataBase(L, index, name)->data)

#endif /* !_XCB_COMMON_H_ */
