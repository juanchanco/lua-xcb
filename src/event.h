#ifndef _EVENT_
#define _EVENT_

extern const CommonEnum EventType[];
extern const CommonEnum EventMask[];

void pushEvent(lua_State *L, const xcb_generic_event_t *evt);

void pushErrorEvent(lua_State *L, const xcb_generic_error_t *evt);

void pushExposeEvent(lua_State *L, const xcb_expose_event_t *evt);

void pushButtonEvent(lua_State *L, const xcb_button_press_event_t *evt);

void pushKeyEvent(lua_State *L, const xcb_key_press_event_t *evt);
#endif /* !_EVENT_ */
