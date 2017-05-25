#include <stdlib.h>
#include <xcb/xcb.h>
#include "common/table.h"
/*#include "connection.h"*/
#include "event.h"

const CommonEnum EventType[] = {
    { "Expose", XCB_EXPOSE },
    { "KeyPress", XCB_KEY_PRESS },
    { "ButtonPress", XCB_BUTTON_PRESS },
    { "ButtonRelease", XCB_BUTTON_RELEASE },
    { NULL, -1 }
};
const CommonEnum EventMask[] = {
    { "Exposure", XCB_EVENT_MASK_EXPOSURE },
    { "KeyPress", XCB_EVENT_MASK_KEY_PRESS },
    { "ButtonPress", XCB_EVENT_MASK_BUTTON_PRESS },
    { NULL, -1 }
};
/*typedef enum xcb_event_mask_t {
    XCB_EVENT_MASK_NO_EVENT = 0,
    XCB_EVENT_MASK_KEY_PRESS = 1,
    XCB_EVENT_MASK_KEY_RELEASE = 2,
    XCB_EVENT_MASK_BUTTON_PRESS = 4,
    XCB_EVENT_MASK_BUTTON_RELEASE = 8,
    XCB_EVENT_MASK_ENTER_WINDOW = 16,
    XCB_EVENT_MASK_LEAVE_WINDOW = 32,
    XCB_EVENT_MASK_POINTER_MOTION = 64,
    XCB_EVENT_MASK_POINTER_MOTION_HINT = 128,
    XCB_EVENT_MASK_BUTTON_1_MOTION = 256,
    XCB_EVENT_MASK_BUTTON_2_MOTION = 512,
    XCB_EVENT_MASK_BUTTON_3_MOTION = 1024,
    XCB_EVENT_MASK_BUTTON_4_MOTION = 2048,
    XCB_EVENT_MASK_BUTTON_5_MOTION = 4096,
    XCB_EVENT_MASK_BUTTON_MOTION = 8192,
    XCB_EVENT_MASK_KEYMAP_STATE = 16384,
    XCB_EVENT_MASK_EXPOSURE = 32768,
    XCB_EVENT_MASK_VISIBILITY_CHANGE = 65536,
    XCB_EVENT_MASK_STRUCTURE_NOTIFY = 131072,
    XCB_EVENT_MASK_RESIZE_REDIRECT = 262144,
    XCB_EVENT_MASK_SUBSTRUCTURE_NOTIFY = 524288,
    XCB_EVENT_MASK_SUBSTRUCTURE_REDIRECT = 1048576,
    XCB_EVENT_MASK_FOCUS_CHANGE = 2097152,
    XCB_EVENT_MASK_PROPERTY_CHANGE = 4194304,
    XCB_EVENT_MASK_COLOR_MAP_CHANGE = 8388608,
    XCB_EVENT_MASK_OWNER_GRAB_BUTTON = 16777216
} xcb_event_mask_t;*/

static int _response_type(lua_State* L) {
    xcb_generic_event_t *evt = commonGetAs(L, 1, EventName, xcb_generic_event_t *);
    return commonPush(L, "i", evt->response_type & ~0x80);
};
static int _error_code(lua_State* L) {
    xcb_generic_error_t *evt = commonGetAs(L, 1, EventName, xcb_generic_error_t *);
    return commonPush(L, "i", evt->error_code);
};

/*typedef struct {
    uint8_t   response_type;
    uint8_t   error_code;
    uint16_t sequence;
    uint32_t resource_id;
    uint16_t minor_code;
    uint8_t major_code;
    uint8_t pad0;
    uint32_t pad[5];
    uint32_t full_sequence;
} xcb_generic_error_t;*/

static int _free_event(lua_State* L) {
    xcb_generic_event_t *evt = commonGetAs(L, 1, EventName, xcb_generic_event_t *);
    free(evt);

    return 0;
};

static const luaL_Reg metamethods[] = {
    { "__gc", _free_event },
    { NULL, NULL }
};

/*TODO: different objects for different event types?*/
static const luaL_Reg methods[] = {
    { "getResonseType", _response_type },
    { "getErrorCode", _error_code },
    { NULL, NULL }
};

const CommonObject Event = {
    "Event",
    methods,
    metamethods
};

