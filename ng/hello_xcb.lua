local xcb = require("swig_xcb")

--for k,v in pairs(xcb) do
  --local mt = getmetatable(v)
  --if (mt) then
    --print(string.format("%s = %s", k, v))
    --for x,y in pairs(mt) do
      --print(string.format("  %s = %s", x, y))
    --end
  --end
--end
local r = xcb.xcb_rectangle_t()
r.x = 40
r.y = 40
r.width = 20
r.height = 20
local rectangles = xcb.new_rectangles(1)
xcb.rectangles_setitem(rectangles, 0, r)
local c = xcb.xcb_connect(nil, 0)
local e = xcb.xcb_connection_has_error(c)
local screen = xcb.xcb_setup_roots_iterator(xcb.xcb_get_setup(c)).data
local win = screen.root
local foreground = xcb.xcb_generate_id (c)
local mask = xcb.XCB_GC_FOREGROUND | xcb.XCB_GC_GRAPHICS_EXPOSURES
local values = xcb.new_values(2)
xcb.values_setitem(values, 0, screen.black_pixel)
xcb.values_setitem(values, 1, 0)
xcb.xcb_create_gc (c, foreground, win, mask, values)

local background = xcb.xcb_generate_id (c)
mask = xcb.XCB_GC_BACKGROUND | xcb.XCB_GC_GRAPHICS_EXPOSURES
xcb.values_setitem(values, 0, screen.white_pixel)
xcb.values_setitem(values, 1, 0)
xcb.xcb_create_gc (c, background, win, mask, values)

xcb.delete_values(values)

win = xcb.xcb_generate_id (c)
mask = xcb.XCB_CW_BACK_PIXEL | xcb.XCB_CW_EVENT_MASK
xcb.values_setitem(values, 1, xcb.XCB_EVENT_MASK_EXPOSURE | xcb.XCB_EVENT_MASK_KEY_PRESS)

xcb.xcb_create_window (c, xcb.XCB_COPY_FROM_PARENT,
                     win,
                     screen.root,
                     0, 0,
                     150, 150,
                     10,
                     xcb.XCB_WINDOW_CLASS_INPUT_OUTPUT,
                     screen.root_visual,
                     mask, values)
 
xcb.xcb_map_window (c, win)
xcb.xcb_flush (c);
local string = "Hello, XCB!"
local string_len = #string
local e = xcb.xcb_wait_for_event(c)
while (e) do
  --local response_type = e.response_type | 0x7f
  local response_type = e.response_type
  --print(e.response_type)
  if (response_type == xcb.XCB_EXPOSE) then
  print("xcb.XCB_EXPOSE")
    xcb.xcb_poly_rectangle (c, win, foreground, 1, rectangles)
    xcb.xcb_image_text_8 (c, string_len, win, background, 20, 20, string)
    xcb.xcb_flush (c)
  elseif (response_type == xcb.XCB_KEY_PRESS) then
  print("xcb.XCB_KEY_PRESS")
    break
  end
  e = xcb.xcb_wait_for_event(c)
end
xcb.xcb_disconnect(c)
