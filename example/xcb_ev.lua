local ev = require'ev'
local XCB = require("XCB")
local conn = assert(XCB.xcbConnect({}))
local screen = conn:createScreen()
local win = screen:getRoot()
local foreground = conn:generateId()
assert(conn:createGC({
  context = foreground,
  target = win,
  mask = { XCB.GraphicsContext.Foreground, XCB.GraphicsContext.GraphicsExposures },
  value0 = screen:getBlackPixel(),
  value1 = 0
}))
local background = conn:generateId()
assert(conn:createGC({
  context = background,
  target = win,
  mask = { XCB.GraphicsContext.Background, XCB.GraphicsContext.GraphicsExposures },
  value0 = screen:getWhitePixel(),
  value1 = 0
}))
local main = conn:generateId()
assert(conn:createWindow({
  window = main,
  parent = screen:getRoot(),
  x = 0,
  y = 0,
  width = 150,
  height = 150,
  border = 10,
  class = XCB.WindowClass.InputOutput,
  visual = screen:getRootVisual(),
  mask = { XCB.CW.BackPixel, XCB.CW.EventMask },
  value0 = screen:getWhitePixel(),
  value1 = { XCB.EventMask.Exposure, XCB.EventMask.KeyPress }
}))
assert(conn:mapWindow(main))
assert(conn:flush())

local xcb_prepare = function(loop)
  local xcb_prepare_cb = function(_, _, _)
    conn:flush()
  end
  local prepare = ev.Prepare.new(xcb_prepare_cb, "wtf")
  prepare:start(loop)
  return prepare
end

local xcb_check = function(loop)
  local xcb_check_cb = function(_, _, _)
    print("HERE I AM")
    if(conn:hasError()) then
      assert(nil,"ERROR")
    end
    local evt = conn:pollForEvent()
    while (evt ~= nil) do
      if (evt:getResonseType() == XCB.EventType.Expose) then
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
      elseif (evt:getResonseType() == 0) then
        print("ERROR")
        print(evt:getErrorCode())
      elseif (evt:getResonseType() == XCB.EventType.KeyPress) then
        print("DONE")
      end
      evt = conn:pollForEvent()
    end
  end
  local check = ev.Check.new(xcb_check_cb, "wtf")
  check:start(loop)
  return check
end

local main_loop = ev.Loop.default
print(main_loop)
xcb_prepare(main_loop)
local check = xcb_check(main_loop)
print(check)
check:invoke(main_loop, 0)
main_loop:loop()
