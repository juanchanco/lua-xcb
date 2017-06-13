local XCB = require("XCB")
local conn = assert(XCB.xcbConnect({}))
local screen = conn:createScreen()
local win = screen.root
local foreground = conn:generateId()
assert(conn:createGC({
  context = foreground,
  target = win,
  mask = { XCB.GraphicsContext.Foreground, XCB.GraphicsContext.GraphicsExposures },
  value0 = screen.black_pixel,
  value1 = 0
}))
local background = conn:generateId()
assert(conn:createGC({
  context = background,
  target = win,
  mask = { XCB.GraphicsContext.Background, XCB.GraphicsContext.GraphicsExposures },
  value0 = screen.white_pixel,
  value1 = 0
}))
local main = conn:generateId()
assert(conn:createWindow({
  window = main,
  parent = screen.root,
  x = 0,
  y = 0,
  width = 150,
  height = 150,
  border = 10,
  class = XCB.WindowClass.InputOutput,
  visual = screen.root_visual,
  mask = { XCB.CW.BackPixel, XCB.CW.EventMask },
  value0 = screen.white_pixel,
  value1 = { XCB.EventMask.Exposure, XCB.EventMask.KeyPress }
}))
assert(conn:mapWindow(main))
assert(conn:flush())

while true do
  assert(conn:checkError())
  local evt = conn:waitForEvent()
  if (evt.response_type == XCB.EventType.Expose) then
    conn:polyRectangle({
        target = main,
        context = foreground,
      })
    conn:imageText8({
        target = main,
        context = background,
        x = 20,
        y = 20,
        text = "Hello World!",
      })
    assert(conn:flush())
  elseif (evt.response_type == 0) then
    print("ERROR")
    print(evt.error_code)
  elseif (evt.response_type == XCB.EventType.KeyPress) then
    break
  end
end
