local fc = require("swig_fc")

for k,v in pairs(fc) do
  print(string.format("%s = %s", k, v))
  local mt = getmetatable(v)
  if (mt) then
    for x,y in pairs(mt) do
      print(string.format("  %s = %s", x, y))
    end
  end
end
