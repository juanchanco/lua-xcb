#ifndef _CONNECTION_
#define _CONNECTION_

#include <common/common.h>

#define ConnectionName	Connection.name

extern const luaL_Reg ConnectionFunctions[];

extern const CommonObject Visual;
extern const CommonObject Connection;

extern const CommonEnum ConnectionError[];
extern const CommonEnum WindowClass[];
extern const CommonEnum CW[];
extern const CommonEnum Defines[];
extern const CommonEnum GC[];

#endif /* !_CONNECTION_ */
