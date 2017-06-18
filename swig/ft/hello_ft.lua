local ft = require("swig_freetype")
local hb = require("swig_hb")
local hb_ft = require("swig_hb_ft")
local hb_glib = require("swig_hb_glib")
local cairo = require("swig_cairo")
local cairo_xcb = require("swig_cairo_xcb")
local cairo_ft = require("swig_cairo_ft")

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
hb.hb_buffer_set_unicode_funcs(buf, hb_glib.hb_glib_get_unicode_funcs())
hb.hb_buffer_set_direction(buf, hb.HB_DIRECTION_LTR);
hb.hb_buffer_set_script(buf, hb.HB_SCRIPT_LATIN)
hb.hb_buffer_set_language(buf, hb.hb_language_from_string("en", 2))
hb.hb_buffer_add_utf8(buf, en_text, #en_text, 0, #en_text)
hb.hb_shape(hb_ft_font, buf, nil, 0);

local cairo_ft_face = cairo_ft.cairo_ft_font_face_create_for_ft_face(ft_face, 0)


cairo.cairo_font_face_destroy(cairo_ft_face)
hb.hb_font_destroy(hb_ft_font)
hb.hb_face_destroy(hb_ft_face)
ft.FT_Done_FreeType(ft_library)
