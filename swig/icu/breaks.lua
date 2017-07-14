require "std.strict"
local Serpent = require "serpent"
local Icu = require "swig_icu"
local Ubrk = require "swig_icu_ubrk"
List = require 'pl.List'

local text8 = "Lorem ipsum dolor sit amet, «consectetur adipiscing elit,» sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.\nExcepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

local text = Icu.utext_openUTF8(nil, text8, #text8, 0)
--local text = ""

local itt,err = Ubrk.ubrk_open(Ubrk.UBRK_WORD, 0, nil, 0, 0)
err = Ubrk.ubrk_setUText(itt, text, err)

--local n = 0
local i = Ubrk.ubrk_first(itt)
local j = Ubrk.ubrk_next(itt)
local elts = {}
local indices = {}
--local indices = List()
while (j ~= -1) do
  table.insert(indices, i)
  elts[i] = j
  i = j
  j = Ubrk.ubrk_next(itt)
end

for _,i in ipairs(indices) do
  print(string.format("%i,%i => \"%s\"", i, elts[i], string.sub(text8, i+1, elts[i])))
end
