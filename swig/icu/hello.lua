local Icu = require "swig_icu"
local Ubrk = require "swig_icu_ubrk"

local text8 = "Ленивый  рыжий кот شَدَّة latin العَرَبِية";

local text = Icu.utext_openUTF8(nil, text8, #text8, 0)
--local text = ""

local itt,err = Ubrk.ubrk_open(Ubrk.UBRK_CHARACTER, 0, nil, 0, 0)
local _ = Ubrk.ubrk_setUText(itt, text, err)

--local n = 0
local i = Ubrk.ubrk_first(itt)
local j = Ubrk.ubrk_next(itt)
local chars = {}
while (j ~= -1) do
  chars[i] = j
  i = j
  j = Ubrk.ubrk_next(itt)
end

Icu.utext_setNativeIndex(text, 0)
local ch = Icu.utext_next32(text)
local offs = {}
i = 0
while (ch ~= -1) do
  local nxt = Icu.utext_next32(text)
  if (nxt == -1) then
    j = #text8
  else
    j = Icu.utext_getNativeIndex(text)
  end
  local scr,_ = Icu.uscript_getScript(ch, nil)
  local spc = Icu.u_isblank(ch)
  print(string.format("ch=%i, scr=%i, spc=%s ===> %s", ch, scr, spc, Icu.uscript_getShortName(scr)))
  print(string.format("    %i,%i => %s", i,j, string.sub(text8, i+1, j)))
  offs[i] = j
  i = j
  ch = nxt
end
Ubrk.ubrk_close(itt)
--for i=0,#text8 do
  --if (chars[i]) then
    --print(string.format("%i,%i => \"%s\"", i, chars[i], string.sub(text8, i+1, chars[i])))
    --for x=i,(chars[i]-1) do
      --if (offs[x]) then
        --print(string.format("    %i,%i => %s", x,offs[x], string.sub(text8, x+1, offs[x])))
      --end
    --end
  --end
--end
--print (#text8)
--print (n)
