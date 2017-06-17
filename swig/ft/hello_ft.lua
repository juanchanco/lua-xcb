local ft = require("swig_freetype")

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
print(code)
print(ft_library)
print(swig_type(ft_library))
local c2,ft_face = ft.FT_New_Face(ft_library, "fonts/DejaVuSerif.ttf", 0)
print(c2)
print(swig_type(ft_face))
local ptSize      = 50.0;
local device_hdpi = 100;
local device_vdpi = 100;
ft.FT_Set_Char_Size(ft_face, 0, ptSize, device_hdpi, device_vdpi )

local hb = require("swig_hb")
local hb_ft = require("swig_hb_ft")
local hb_font = hb_ft.hb_ft_font_create_referenced(ft_face)
--local mt = getmetatable(ft_face)
--mt["__gc"] = function(_) end
ft.FT_Done_FreeType(ft_library)
print("DONE")
