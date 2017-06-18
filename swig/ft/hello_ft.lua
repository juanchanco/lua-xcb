local ft = require("swig_freetype")
local hb = require("swig_hb")
local hb_ft = require("swig_hb_ft")
local hb_glib = require("swig_hb_glib")
local cairo = require("swig_cairo")
local cairo_xcb = require("swig_cairo_xcb")
local cairo_ft = require("swig_cairo_ft")
local xcb = require("swig_xcb")

--for k,v in pairs(ft) do
  --print(string.format("%s = %s", k, v))
  --local mt = getmetatable(v)
  --if (mt) then
    --for x,y in pairs(mt) do
      --print(string.format("  %s = %s", x, y))
    --end
  --end
--end
local mt = getmetatable(ft.FT_FaceRec)
mt[".instance"]["__gc"] = function(_) print("GC!") end

local code,ft_library = ft.FT_Init_FreeType()
local c2,ft_face = ft.FT_New_Face(ft_library, "fonts/DejaVuSerif.ttf", 0)
local ptSize      = 50.0;
local device_hdpi = 100;
local device_vdpi = 100;
ft.FT_Set_Char_Size(ft_face, 0, ptSize, device_hdpi, device_vdpi )

local hb_ft_font = hb_ft.hb_ft_font_create_referenced(ft_face)
local hb_ft_face = hb_ft.hb_ft_face_create_referenced(ft_face)

local en_text = "This is some english text"
local ar_text = "هذه هي بعض النصوص العربي"
local ch_test = "這是一些中文"
local buf = hb.hb_buffer_create()
--getmetatable(buf)["__gc"] = function(self) hb.hb_buffer_destroy(self) end
hb.hb_buffer_set_unicode_funcs(buf, hb_glib.hb_glib_get_unicode_funcs())
hb.hb_buffer_set_direction(buf, hb.HB_DIRECTION_LTR);
hb.hb_buffer_set_script(buf, hb.HB_SCRIPT_LATIN)
hb.hb_buffer_set_language(buf, hb.hb_language_from_string("en", 2))
hb.hb_buffer_add_utf8(buf, en_text, #en_text, 0, #en_text)
hb.hb_shape(hb_ft_font, buf, nil, 0);

local glyph_infos, glyph_count = hb.hb_buffer_get_glyph_infos(buf);
local glyph_positions, gc = hb.hb_buffer_get_glyph_positions(buf);

local cairo_glyphs = cairo.new_glyphs(glyph_count)
local cairo_ft_face = cairo_ft.cairo_ft_font_face_create_for_ft_face(ft_face, 0)

local string_width_in_pixels = 0
local x = 20
local y = 50
for i = 0, (glyph_count-1) do
  local cairo_glyph = cairo.cairo_glyph_t()
  local position = hb.get_glyph_position(glyph_positions, i)
  local info = hb.get_glyph_info(glyph_infos, i)

  string_width_in_pixels = string_width_in_pixels + position.x_advance/64;
  
  cairo_glyph.index = info.codepoint
  cairo_glyph.x = x + (position.x_offset/64)
  cairo_glyph.y = y - (position.y_offset/64)
  x = x + position.x_advance/64
  y = y - position.y_advance/64
  cairo.glyphs_setitem(cairo_glyphs, i, cairo_glyph)
end


local conn = xcb.xcb_connect(nil, 0)
local screen = xcb.xcb_setup_roots_iterator(xcb.xcb_get_setup(conn)).data
local wid = xcb.xcb_generate_id(conn)
local mask = xcb.XCB_CW_BACK_PIXEL | xcb.XCB_CW_EVENT_MASK
local values = xcb.new_values(2)
xcb.values_setitem(values, 0, screen.black_pixel)
xcb.values_setitem(values, 1, xcb.XCB_EVENT_MASK_EXPOSURE | xcb.XCB_EVENT_MASK_KEY_PRESS)

xcb.xcb_create_window (conn, xcb.XCB_COPY_FROM_PARENT,
                     wid,
                     screen.root,
                     20, 20,
                     500, 500,
                     10,
                     xcb.XCB_WINDOW_CLASS_INPUT_OUTPUT,
                     screen.root_visual,
                     mask, values)
xcb.xcb_map_window(conn, wid)
xcb.xcb_flush(conn)

local visual = xcb.find_visual(conn, screen.root_visual)
local surface = cairo_xcb.cairo_xcb_surface_create(conn, wid, visual, 500, 500)
local cr = cairo.cairo_create(surface)
xcb.xcb_flush(conn)




local e = xcb.xcb_wait_for_event(conn)
while (e) do
  local response_type = e.response_type
  if (response_type == xcb.XCB_EXPOSE) then
    cairo.cairo_set_source_rgba (cr, 0.5, 0.5, 0.5, 1.0);
    cairo.cairo_set_font_face(cr, cairo_ft_face);
    cairo.cairo_set_font_size(cr, ptSize);
    cairo.cairo_show_glyphs(cr, cairo_glyphs, glyph_count);
    cairo.cairo_surface_flush(surface)
    xcb.xcb_flush(conn)
  elseif (response_type == xcb.XCB_KEY_PRESS) then
    break
  end
  e = xcb.xcb_wait_for_event(conn)
end
xcb.xcb_disconnect(conn)




cairo.cairo_font_face_destroy(cairo_ft_face)
hb.hb_font_destroy(hb_ft_font)
hb.hb_face_destroy(hb_ft_face)
ft.FT_Done_FreeType(ft_library)
