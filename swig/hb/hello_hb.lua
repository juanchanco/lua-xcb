local hb = require("swig_hb")

for k,v in pairs(hb) do
  print(string.format("%s = %s", k, v))
  local mt = getmetatable(v)
  if (mt) then
    for x,y in pairs(mt) do
      print(string.format("  %s = %s", x, y))
    end
  end
end
print("================================================")
local hb_ft = require("swig_hb_ft")
for k,v in pairs(hb_ft) do
  print(string.format("%s = %s", k, v))
  local mt = getmetatable(v)
  if (mt) then
    for x,y in pairs(mt) do
      print(string.format("  %s = %s", x, y))
    end
  end
end
