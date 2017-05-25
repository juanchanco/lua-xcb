#ifndef _EVENT_
#define _EVENT_

#include <common/common.h>

#define EventName	Event.name

extern const luaL_Reg EventFunctions[];

extern const CommonObject Event;

extern const CommonEnum EventType[];
extern const CommonEnum EventMask[];

#endif /* !_EVENT_ */
