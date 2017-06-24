local fb = require("swig_fribidi")
local iconv = require("iconv")

local text8 = "Ленивый рыжий кот شَدَّة latin العَرَبِية";

local ic = assert(iconv.open("UTF-32LE", "UTF-8"))
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

for i = 0, nLineSize-1 do
  print(string.format("%i => %i", i, fb.FriBidiStrIndexArray_getitem(pTempPositionLogicToVisual, i)))
end
