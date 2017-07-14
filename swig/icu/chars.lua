require "std.strict"
local Icu = require "swig_icu"
local Ubrk = require "swig_icu_ubrk"

--local text8 = "Ленивый  рыжий кот شَدَّة. latin العَرَبِية";
local text8 = "Lorem ipsum dolor sit amét, «consectetur adipiscing elit,» sed ço eiusmod."

local text = Icu.utext_openUTF8(nil, text8, #text8, 0)

Icu.utext_setNativeIndex(text, 0)
local ch = Icu.utext_next32(text)
local offs = {}
i = 0
while (ch ~= -1) do
  local j = Icu.utext_getNativeIndex(text)
  local scr,_ = Icu.uscript_getScript(ch, nil)
  local spc = Icu.u_isblank(ch)
  local pnt = Icu.u_ispunct(ch)
  local typ = Icu.u_charType(ch)
  print(string.format("ch=%i/%s (%i,%i) scr=%i/%s --> typ=%i, spc=%s, punct=%s", ch, string.sub(text8, i+1, j), i, j, scr, Icu.uscript_getShortName(scr), typ, spc, pnt))
  --print(string.format("    %i,%i => %s", i,j, string.sub(text8, i+1, j)))
  offs[i] = j
  i = j
  ch = Icu.utext_next32(text)
end
