local XCB = require("xcb")

local conn = XCB.connect()
local screen = conn:getSetup():setupRootsIterator().data

local mask = XCB.GC.Foreground | XCB.GC.GraphicsExposures
local foreground = conn:createGc({parent=screen.root, mask=XCB.GC.Foreground | XCB.GC.GraphicsExposures, value0=screen.black_pixel})
local background = conn:createGc({parent=screen.root, mask=XCB.GC.Background | XCB.GC.GraphicsExposures, value0=screen.white_pixel})
local window = conn:createWindow({
  parent=screen.root,
  visual=screen.root_visual,
  x=0, y=0, w=150, h=150, border=10,
  class = XCB.WindowClass.InputOutput,
  mask=XCB.CW.BackPixel | XCB.CW.EventMask,
  value0=screen.white_pixel,
  value1=XCB.EventMask.Exposure | XCB.EventMask.KeyPress
})
conn:mapWindow(window)
conn:flush()

local string = "Hello, XCB!"
local rectangles = {{x=40,y=40,w=20,h=20}}
--local string_len = #string
local e = conn:waitForEvent()
while (e) do
  --local response_type = e.response_type | 0x7f
  local response_type = e.response_type
  if (response_type == XCB.EventType.Expose) then
    window:polyRectangle ({gc=foreground, rects=rectangles})
    window:imageText({x=20,y=20,gc=background,text=string})
    conn:flush()
  elseif (response_type == XCB.EventType.KeyPress) then
    break
  elseif (response_type == 0) then
    print(string.format("Event error code:%i", e.error_code))
  end
  e = conn:waitForEvent()
end
conn:disconnect()
