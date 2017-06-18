local cairo = require("swig_cairo")
local cairo_xcb = require("swig_cairo_xcb")
local xcb = require("swig_xcb")

local conn = xcb.xcb_connect(nil, 0)
local screen = xcb.xcb_setup_roots_iterator(xcb.xcb_get_setup(conn)).data
local wid = xcb.xcb_generate_id(conn)
local mask = xcb.XCB_CW_BACK_PIXEL | xcb.XCB_CW_EVENT_MASK
local values = xcb.new_values(2)
xcb.values_setitem(values, 0, screen.white_pixel)
xcb.values_setitem(values, 1, xcb.XCB_EVENT_MASK_EXPOSURE | xcb.XCB_EVENT_MASK_KEY_PRESS)

xcb.xcb_create_window (conn, xcb.XCB_COPY_FROM_PARENT,
                     wid,
                     screen.root,
                     20, 20,
                     150, 150,
                     10,
                     xcb.XCB_WINDOW_CLASS_INPUT_OUTPUT,
                     screen.root_visual,
                     mask, values)
xcb.xcb_map_window(conn, wid)
xcb.xcb_flush(conn)

local visual = xcb.find_visual(conn, screen.root_visual)
local surface = cairo_xcb.cairo_xcb_surface_create(conn, wid, visual, 150, 150)
local cr = cairo.cairo_create(surface)
xcb.xcb_flush(conn)
local e = xcb.xcb_wait_for_event(conn)
while (e) do
  local response_type = e.response_type
  if (response_type == xcb.XCB_EXPOSE) then
    cairo.cairo_set_source_rgb(cr, 0.0, 1.0, 0.0)
    cairo.cairo_paint(cr)
    cairo.cairo_set_source_rgb(cr, 1.0, 0.0, 0.0)
    cairo.cairo_move_to(cr, 0,0)
    cairo.cairo_line_to(cr, 150, 0)
    cairo.cairo_line_to(cr, 150, 150)
    cairo.cairo_close_path(cr)
    cairo.cairo_fill(cr)

    cairo.cairo_set_source_rgb(cr, 0.0, 0.0, 1.0)
    cairo.cairo_set_line_width(cr, 20)
    cairo.cairo_move_to(cr, 0, 150)
    cairo.cairo_line_to(cr, 150, 0)
    cairo.cairo_stroke(cr)
    cairo.cairo_surface_flush(surface)
    -- "old" version didn't need this (or was it just hidden?)
    xcb.xcb_flush(conn)
  elseif (response_type == xcb.XCB_KEY_PRESS) then
    break
  end
  e = xcb.xcb_wait_for_event(conn)
end
xcb.xcb_disconnect(conn)
--for k,v in pairs(cairo) do
  --print(string.format("%s = %s", k, v))
  --local mt = getmetatable(v)
  --if (mt) then
    --for x,y in pairs(mt) do
      --print(string.format("  %s = %s", x, y))
    --end
  --end
--end
--print("================================================")
--for k,v in pairs(cairo_xcb) do
  --print(string.format("%s = %s", k, v))
  --local mt = getmetatable(v)
  --if (mt) then
    --for x,y in pairs(mt) do
      --print(string.format("  %s = %s", x, y))
    --end
  --end
--end
