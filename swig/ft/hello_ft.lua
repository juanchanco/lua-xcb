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
local ptSize      = 20.0;
local device_hdpi = 100;
local device_vdpi = 100;
local width      = 500;
local height     = 500;

local texts = {
  en = {
    text = "This is some english text",
    font = "fonts/DejaVuSerif.ttf",
    direction = hb.HB_DIRECTION_LTR,
    script = hb.HB_SCRIPT_LATIN
  },
  ar = {
    text = "هذه هي بعض النصوص العربي",
    font = "fonts/amiri-0.104/amiri-regular.ttf",
    direction = hb.HB_DIRECTION_RTL,
    script = hb.HB_SCRIPT_ARABIC
  },
  ch = {
    text = "這是一些中文",
    font = "fonts/fireflysung-1.3.0/fireflysung.ttf",
    direction = hb.HB_DIRECTION_TTB,
    script = hb.HB_SCRIPT_HAN
  }
}

function loadFonts(spec)
  local code,ft_face = ft.FT_New_Face(ft_library, spec.font, 0)
  ft.FT_Set_Char_Size(ft_face, 0, ptSize*64.0, device_hdpi, device_vdpi )
  local hb_ft_font = hb_ft.hb_ft_font_create_referenced(ft_face)
  local hb_ft_face = hb_ft.hb_ft_face_create_referenced(ft_face)
  local cairo_ft_face = cairo_ft.cairo_ft_font_face_create_for_ft_face(ft_face, 0)
  spec.ft_face = ft_face
  spec.hb_ft_font = hb_ft_font
  spec.hb_ft_face = hb_ft_face
  spec.cario_ft_face = cario_ft_face
end
function createBuffer(ln, spec)
  local buf = hb.hb_buffer_create()
  --getmetatable(buf)["__gc"] = function(self) hb.hb_buffer_destroy(self) end
  hb.hb_buffer_set_unicode_funcs(buf, hb_glib.hb_glib_get_unicode_funcs())
  hb.hb_buffer_set_direction(buf, spec.direction);
  hb.hb_buffer_set_script(buf, spec.script)
  hb.hb_buffer_set_language(buf, hb.hb_language_from_string(ln, #ln))
  return buf
end

function render(ln, spec, x, y)
  print(spec.text)
  local buf = createBuffer(ln, spec)
  hb.hb_buffer_add_utf8(buf, spec.text, #(spec.text), 0, #(spec.text))
  hb.hb_shape(spec.hb_ft_font, buf, nil, 0);

  local glyph_infos, glyph_count = hb.hb_buffer_get_glyph_infos(buf);
  local glyph_positions, _ = hb.hb_buffer_get_glyph_positions(buf);
  local string_width_in_pixels = 0
  for i = 0, (glyph_count-1) do
    local position = hb.get_glyph_position(glyph_positions, i)
    string_width_in_pixels = string_width_in_pixels + ((position.x_advance)//64);
  end

  if (ln == "en") then x = 20 end
  if (ln == "ar")  then x = width - string_width_in_pixels - 20 end
  if (ln == "ch") then x = width//2 - string_width_in_pixels/2 end
  print(string.format("%s -> %i/%i => %i", ln, x, y, string_width_in_pixels))
  local cairo_glyphs = cairo.new_glyphs(glyph_count)
  for i = 0, (glyph_count-1) do
    local cairo_glyph = cairo.cairo_glyph_t()
    local position = hb.get_glyph_position(glyph_positions, i)
    local info = hb.get_glyph_info(glyph_infos, i)
    cairo_glyph.index = info.codepoint
    cairo_glyph.x = x + ((position.x_offset)//64)
    cairo_glyph.y = y + ((position.y_offset)//64)
    x = x + ((position.x_advance)//64)
    y = y - ((position.y_advance)//64)
    cairo.glyphs_setitem(cairo_glyphs, i, cairo_glyph)
  --print(string.format("  %s -> %i/%i", ln, x, y))
  end
  hb.hb_buffer_destroy(buf)
  getmetatable(cairo_glyphs)["__len"] = function(self) return glyph_count end
  return cairo_glyphs
end

function renderToCairo(cr, surface, ln, spec, x, y)
  local glyphs = render(ln, spec, x, y)
  cairo.cairo_set_font_face(cr, spec.cairo_ft_face);
  cairo.cairo_show_glyphs(cr, glyphs, #glyphs);
  cairo.cairo_surface_flush(surface)
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
                     width, height,
                     10,
                     xcb.XCB_WINDOW_CLASS_INPUT_OUTPUT,
                     screen.root_visual,
                     mask, values)
xcb.xcb_map_window(conn, wid)
xcb.xcb_flush(conn)

local visual = xcb.find_visual(conn, screen.root_visual)
local surface = cairo_xcb.cairo_xcb_surface_create(conn, wid, visual, width, height)
local cr = cairo.cairo_create(surface)
xcb.xcb_flush(conn)


for _,spec in pairs(texts) do
  loadFonts(spec)
end
cairo.cairo_set_source_rgba (cr, 0.5, 0.5, 0.5, 1.0);
cairo.cairo_set_font_size(cr, ptSize);


local e = xcb.xcb_wait_for_event(conn)
while (e) do
  local response_type = e.response_type
  if (response_type == xcb.XCB_EXPOSE) then
    local x = 20
    local y = 50
    renderToCairo(cr, surface, "en", texts.en, x, y)
    y = y + math.tointeger(ptSize * 2)
    renderToCairo(cr, surface, "ar", texts.ar, x, y)
    y = y + math.tointeger(ptSize * 2)
    renderToCairo(cr, surface, "ch", texts.ch, x, y)
    xcb.xcb_flush(conn)
  elseif (response_type == xcb.XCB_KEY_PRESS) then
    break
  end
  e = xcb.xcb_wait_for_event(conn)
end
xcb.xcb_disconnect(conn)



for _,spec in pairs(texts) do
  cairo.cairo_font_face_destroy(spec.cairo_ft_face)
  hb.hb_font_destroy(spec.hb_ft_font)
  hb.hb_face_destroy(spec.hb_ft_face)
end

ft.FT_Done_FreeType(ft_library)
