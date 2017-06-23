local fb = require("swig_fribidi")
local iconv = require("iconv")

local text8 = "Ленивый рыжий кот شَدَّة latin العَرَبِية";

local ic = assert(iconv.open("UTF-32", "UTF-8"))
local text = ic:iconv(text8)
