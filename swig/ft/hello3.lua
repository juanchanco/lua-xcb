local fb = require("swig_fribidi")
local iconv = require("iconv")
local hb = require("harfbuzz")

local cairo = require("cairo")
local ft = require("freetype")
local xcb = require("xcb")

local text8 = "Ленивый рыжий кот شَدَّة latin العَرَبِية";

local ic = assert(iconv.open("utf-32le", "utf-8"))
local text = ic:iconv(text8)

local nLineSize = #text/4

local pTempLogicalLine = fb.new_FriBidiCharArray(nLineSize)
local pTempVisualLine = fb.new_FriBidiCharArray(nLineSize)
local pTempPositionLogicToVisual = fb.new_FriBidiStrIndexArray(nLineSize)
local pTempBidiTypes  = fb.new_FriBidiCharTypeArray(nLineSize)
local pTempEmbeddingLevels = fb.new_FriBidiLevelArray(nLineSize)
local pTempJtypes  = fb.new_FriBidiJoiningTypeArray(nLineSize)
local pTempArProps = fb.new_FriBidiArabicPropArray(nLineSize)
--for i = 1, #text, 4 do
  --local c = (string.byte(text,i+3) << 24)|(string.byte(text,i+2) << 16|(string.byte(text,i+1) << 8))|(string.byte(text,i))
  --fb.FriBidiCharArray_setitem(pTempLogicalLine, (i-1)//4, c)
--end

fb.memcpy_FriBidiCharArray(pTempLogicalLine, text, #text)
fb.fribidi_get_bidi_types(pTempLogicalLine, nLineSize, pTempBidiTypes);

local resolveParDir, baseDirection = fb.get_par_embedding_levels_ref(pTempBidiTypes, nLineSize, fb.FRIBIDI_PAR_LTR, pTempEmbeddingLevels)
fb.fribidi_get_joining_types(pTempLogicalLine, nLineSize, pTempJtypes);
fb.memcpy_FriBidiJoiningTypeArray(pTempArProps, pTempJtypes, nLineSize);

fb.fribidi_join_arabic(pTempBidiTypes, nLineSize, pTempEmbeddingLevels, pTempArProps);
fb.fribidi_shape(fb.FRIBIDI_FLAG_SHAPE_MIRRORING | fb.FRIBIDI_FLAG_SHAPE_ARAB_PRES | fb.FRIBIDI_FLAG_SHAPE_ARAB_LIGA, pTempEmbeddingLevels, nLineSize, pTempArProps, pTempLogicalLine);

fb.memcpy_FriBidiCharArray2(pTempVisualLine, pTempLogicalLine, nLineSize);
for i = 0, nLineSize-1 do
  fb.FriBidiStrIndexArray_setitem(pTempPositionLogicToVisual, i, i)
end

local levels = fb.fribidi_reorder_line(fb.FRIBIDI_FLAGS_ARABIC, pTempBidiTypes, nLineSize, 0, baseDirection,  pTempEmbeddingLevels, pTempVisualLine, pTempPositionLogicToVisual);

--for i = 0, nLineSize-1 do
  --print(string.format("%i ====> %i", i, fb.FriBidiStrIndexArray_getitem(pTempPositionLogicToVisual, i)))
--end
local chunks = {}
local chunkStart = 0
local currentScript = hb.unicodeScript(fb.FriBidiCharArray_getitem(pTempLogicalLine, chunkStart))
for j = 1,nLineSize-1 do
  local script = hb.unicodeScript(fb.FriBidiCharArray_getitem(pTempLogicalLine, j))
  if (script ~= currentScript and script ~= hb.Script.Inherited) then
      local chunk = {
        start = chunkStart,
        length = j - chunkStart,
        script = currentScript,
      }
      table.insert(chunks,chunk)
      
      chunkStart = j
      currentScript = script
  end
end
local currentSymbol = fb.FriBidiCharArray_getitem(pTempLogicalLine, chunkStart)
if (chunkStart <= nLineSize) then
  local chunk = {
    start = chunkStart,
    length = nLineSize - chunkStart,
    script = currentScript,
  }
  table.insert(chunks,chunk)
end



-------------------- drawing ----------------

local ft_library = ft.initFreeType()
local ptSize      = 40.0;
local device_hdpi = 100;
local device_vdpi = 100;
local width      = 1000;
local height     = 500;
local fontPath = "fonts/arial.ttf"

local ft_face = ft_library:newFace(fontPath)
ft_face:setCharSize(ptSize*64.0, device_hdpi, device_vdpi)
local function createFontFromFile(path, index)
  local inp = assert(io.open(path, "rb"))
  local data = inp:read("*all")
  io.close(inp)
  local blob = hb.blobCreate(data, #data, hb.MemoryMode.Writable)
  local face = hb.faceCreate(blob, index);
  local font = hb.fontCreate(face);
  hb.otFontSetFuncs(font);
  return font
end
local hb_font = hb.ftFontCreate(ft_face)
--hb.otFontSetFuncs(hb_font);
--local hb_font = assert(createFontFromFile(fontPath, 0), "createFontFromFile failed")
--local metrics = ft_face:deref().size.metrics
--local x_scale  = math.tointeger(metrics.x_scale)
--local y_scale  = math.tointeger(metrics.y_scale)
--local units_per_EM = math.tointeger(ft_face:deref().units_per_EM)
--local nXScale = (x_scale * units_per_EM + (1<<15)) >> 16
--local nYScale = (y_scale * units_per_EM + (1<<15)) >> 16
--hb_font:setScale(nXScale, nYScale)
local charmap_arr = ft_face:getCharMapArray()
for i = 1,#charmap_arr do
  if (charmap_arr[i].platform_id == 0 and charmap_arr[i].encoding_id == 3) then
    ft_face:setCharMap(charmap_arr[i])
    break
  elseif (charmap_arr[i].platform_id == 3 and charmap_arr[i].encoding_id == 1) then
    ft_face:setCharMap(charmap_arr[i])
    break
  end
end
local cairo_ft_face = cairo.fontFaceCreateForFtFace(ft_face, 0)

--TODO: work out u32_t type issues
local textArray = fb.new_Uint32Array(nLineSize)
fb.memcpy_Uint32Array(textArray, text, #text)
local buf = hb.bufferCreate()
local x = 20.0
local y = 100.0
local cairo_glyphs = cairo.newGlyphsArray(nLineSize)
local c = 0
local function chunkToCairo(chunk)
  --print(string.format("st=%i, l=%i, script=%s", chunk.start, chunk.length, chunk.script))
  buf:clearContents()
  buf:setScript(chunk.script)
  buf:setDirection(hb.Direction.LTR)
  --buf:setScriptAndDirection(chunk.script)
  buf:addUtf32(textArray, nLineSize, chunk.start, chunk.length)
  buf:shape(hb_font)

  local glyph_infos = buf:getGlyphInfos()
  local glyph_positions = buf:getGlyphPositions()
  for j = 1, #glyph_positions do
    --print(string.format("x=%f, y=%f", x, y))
    --print(string.format("    j=%i, v=%i", j-1, chunk.start + j - 1))
    local o = fb.FriBidiStrIndexArray_getitem(pTempPositionLogicToVisual, chunk.start + j - 1)
    local i = o - chunk.start + 1
    local cairo_glyph = cairo.newGlyph()
    local position = glyph_positions[i]
    local info = glyph_infos[i]
    cairo_glyph.index = info.codepoint
    cairo_glyph.x = x + (position.x_offset/64)
    cairo_glyph.y = y - (position.y_offset/64)
    print(string.format("cp=%i xo=%i xa=%i (lua)", info.codepoint,
      math.tointeger(position.x_offset), math.tointeger(position.x_advance)))
    x = x + (position.x_advance/64)
    y = y - (position.y_advance/64)
    c = c + 1
    cairo_glyphs[c] = cairo_glyph
  end
end
for _,chunk in ipairs(chunks) do
  chunkToCairo(chunk)
end


------------------------- display -----------------------

--local conn = xcb.connect()
--local screen = conn:getSetup():setupRootsIterator().data

--local window = conn:createWindow({
  --parent=screen.root,
  --visual=screen.root_visual,
  --x=20, y=20, w=width, h=height, border=10,
  --class = xcb.WindowClass.InputOutput,
  --mask=xcb.CW.BackPixel | xcb.CW.EventMask,
  --value0=screen.black_pixel,
  --value1=xcb.EventMask.Exposure | xcb.EventMask.KeyPress
--})
--conn:mapWindow(window)
--conn:flush()
--local visual = cairo.findVisual(conn, screen.root_visual)
--conn:flush()

--local surface = cairo.xcbSurfaceCreate(conn, window.id, visual, width, height)
--local cr = surface:cairoCreate()
--cr:setFontSize(ptSize)
--cr:setFontFace(cairo_ft_face)

--local e = conn:waitForEvent()
--while (e) do
  --local response_type = e.response_type
  --if (response_type == xcb.EventType.Expose) then
    --cr:setSourceRgb(0.0, 0.0, 0.0)
    --cr:paint()
    --cr:setSourceRgba(0.5, 0.5, 0.5, 1.0)
    --cr:showGlyphs(cairo_glyphs)
    --surface:flush()
    --conn:flush()
  --elseif (response_type == xcb.EventType.KeyPress) then
    --break
  --end
  --e = conn:waitForEvent()
--end
--conn:disconnect()

