local icu = require "swig_icu_ubrk"

local text8 = "Ленивый рыжий кот شَدَّة latin العَرَبِية";

local text = icu.utext_openUTF8(nil, text8, #text8, 0)
--local text = ""

local itt,err = icu.ubrk_open(icu.UBRK_CHARACTER, 0, nil, 0, 0)
local _ = icu.ubrk_setUText(itt, text, err)

local p = icu.ubrk_first(itt)
local i = 0
while (p ~= -1) do
  i = i + 1
  p = icu.ubrk_next(itt)
end
icu.ubrk_close(itt)
print (#text8)
print (i)
