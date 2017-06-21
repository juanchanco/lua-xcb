local ft = require("swig_freetype")
local hb = require("harfbuzz")
local cairo = require("cairo")
local xcb = require("xcb")

local FT_FaceRec_mt = getmetatable(ft.FT_FaceRec)
FT_FaceRec_mt[".instance"]["__gc"] = function(_) print("GC!") end

local _,ft_library = ft.FT_Init_FreeType()
local ptSize      = 20.0;
local device_hdpi = 100;
local device_vdpi = 100;
local width      = 500;
local height     = 500;

local texts = {
  en = {
    text = "This is some english text",
    font = "fonts/DejaVuSerif.ttf",
    direction = hb.Direction.LTR,
    script = hb.Script.Latin,
  },
  ar = {
    text = "هذه هي بعض النصوص العربي",
    font = "fonts/amiri-0.104/amiri-regular.ttf",
    direction = hb.Direction.RTL,
    script = hb.Script.Arabic,
  },
  ch = {
    text = "這是一些中文",
    font = "fonts/fireflysung-1.3.0/fireflysung.ttf",
    direction = hb.Direction.TTB,
    script = hb.Script.Han,
  }
}

local loadFonts = function(spec)
  local _,ft_face = ft.FT_New_Face(ft_library, spec.font, 0)
  ft.FT_Set_Char_Size(ft_face, 0, ptSize*64.0, device_hdpi, device_vdpi )
  local hb_ft_font = hb.ftFontCreate(ft_face)
  --local hb_ft_face = hb_ft.hb_ft_face_create_null_func(ft_face)
  local cairo_ft_face = cairo.fontFaceCreateForFtFace(ft_face, 0)
  print(cairo_ft_face:status())
  spec.ft_face = ft_face
  spec.hb_ft_font = hb_ft_font
  --spec.hb_ft_face = hb_ft_face
  spec.cairo_ft_face = cairo_ft_face
end
local createBuffer = function(ln, spec)
  local buf = hb.bufferCreate()
  buf:setDirection(spec.direction)
  buf:setScript(spec.script)
  buf:setLanguageFromName(ln)
  return buf
end

local render = function(ln, spec, x, y)
  print(spec.text)
  local buf = createBuffer(ln, spec)
  buf:addUtf8(spec.text)
  buf:shape(spec.hb_ft_font)

  local glyph_infos = buf:getGlyphInfos(buf)
  local glyph_positions = buf:getGlyphPositions(buf)
  local string_width_in_pixels = 0
  for i = 1, #glyph_positions do
    local position = glyph_positions[i]
    string_width_in_pixels = string_width_in_pixels + ((position.x_advance)//64);
  end

  if (ln == "en") then x = 20 end
  if (ln == "ar")  then x = width - string_width_in_pixels - 20 end
  if (ln == "ch") then x = width//2 - string_width_in_pixels/2 end
  local cairo_glyphs = cairo.newGlyphsArray(#glyph_positions)
  getmetatable(cairo_glyphs)["__len"] = function(_) return #glyph_positions end
  for i = 1, #glyph_positions do
    local cairo_glyph = cairo.newGlyph()
    local position = glyph_positions[i]
    local info = glyph_infos[i]
    cairo_glyph.index = info.codepoint
    cairo_glyph.x = x + ((position.x_offset)//64)
    cairo_glyph.y = y + ((position.y_offset)//64)
    x = x + ((position.x_advance)//64)
    y = y - ((position.y_advance)//64)
    cairo_glyphs[i] = cairo_glyph
  end
  return cairo_glyphs
end

local renderToCairo = function(cr, surface, ln, spec, x, y)
  print(string.format("HERE %s", ln))
  local glyphs = render(ln, spec, x, y)
  cr:setFontFace(spec.cairo_ft_face)
  cr:showGlyphs(glyphs)
  surface:flush()
end
local conn = xcb.connect()
local screen = conn:getSetup():setupRootsIterator().data

local window = conn:createWindow({
  parent=screen.root,
  visual=screen.root_visual,
  x=20, y=20, w=width, h=height, border=10,
  class = xcb.WindowClass.InputOutput,
  mask=xcb.CW.BackPixel | xcb.CW.EventMask,
  value0=screen.black_pixel,
  value1=xcb.EventMask.Exposure | xcb.EventMask.KeyPress
})
conn:mapWindow(window)
conn:flush()
local visual = cairo.findVisual(conn, screen.root_visual)
conn:flush()


for _,spec in pairs(texts) do
  loadFonts(spec)
end


local e = conn:waitForEvent()
while (e) do
  local response_type = e.response_type
  if (response_type == xcb.EventType.Expose) then
    local x = 20
    local y = 50
    --TODO: any way to change cairo context/surface width without recreating?
    width = e.width
    local surface = cairo.xcbSurfaceCreate(conn, window.id, visual, width, height)
    local cr = surface:cairoCreate()
    cr:setFontSize(ptSize)
    cr:setSourceRgb(0.0, 0.0, 0.0)
    cr:paint()
    cr:setSourceRgba(0.5, 0.5, 0.5, 1.0)
    renderToCairo(cr, surface, "en", texts.en, x, y)
    y = y + math.tointeger(ptSize * 2)
    renderToCairo(cr, surface, "ar", texts.ar, x, y)
    y = y + math.tointeger(ptSize * 2)
    renderToCairo(cr, surface, "ch", texts.ch, x, y)
    conn:flush()
  elseif (response_type == xcb.EventType.KeyPress) then
    break
  end
  e = conn:waitForEvent()
end
conn:disconnect()



for _,spec in pairs(texts) do
  cairo.cairo_font_face_destroy(spec.cairo_ft_face)
  hb.hb_font_destroy(spec.hb_ft_font)
  --hb.hb_face_destroy(spec.hb_ft_face)
end

ft.FT_Done_FreeType(ft_library)
