local hb_ot = require("swig_hb_ot")
local ft = require("freetype")
local hb = require("harfbuzz")


local text8 = "fluffy souffle fits if"
--local text8 = "Ленивый рыжий кот شَدَّة latin العَرَبِية";

local ft_library = ft.initFreeType()
local ptSize      = 40.0;
local device_hdpi = 72;
local device_vdpi = 72;
--local fontPath = "../ft/fonts/arial.ttf"
local fontPath = "../ft/fonts/DejaVuSerif.ttf"

local ft_face = ft_library:newFace(fontPath)
ft_face:setCharSize(ptSize*64.0, device_hdpi, device_vdpi)
local hb_font = hb.ftFontCreate(ft_face)

local buf = hb.bufferCreate()

buf:setScript(hb.Script.Latin)
buf:setDirection(hb.Direction.LTR)
buf:addUtf8(text8)

--local glyph_infos = buf:getGlyphInfos()
--print(string.format("BEFORE ===> %i", #glyph_infos))
--for i = 1, #glyph_infos do
  --print(glyph_infos[i].codepoint)
--end
buf:shape(hb_font)
print("============================================")
glyph_infos = buf:getGlyphInfos()
for i = 1, #glyph_infos do
  --local arr = hb_ot.new_hb_position_array(4)
  --local x,y = hb_ot.hb_ot_layout_get_ligature_carets(hb_font, hb.Direction.LTR, glyph_infos[i].codepoint, 0, 4, arr)
  print(string.format("cp=%i cl=%i", glyph_infos[i].codepoint, glyph_infos[i].cluster))
end
--local glyph_positions = buf:getGlyphPositions()
