local pango = require("pango")
local cairo = require("cairo")
local RADIUS = 200
local N_WORDS = 8
local FONT_WITH_MANUAL_SIZE = "Times new roman,Sans"
local FONT_SIZE = 36
local DEVICE_DPI = 72
--local TWEAKABLE_SCALE = 0.1
local PANGO_SCALE = 1024
local draw_text = function(cr)
  --cr:translate (RADIUS, RADIUS)
  local layout = pango.PangoCairo.createPangoLayout(cr)
  local text8 = "Ленивый рыжий кот شَدَّة latin العَرَبِية";
  layout:setText(text8, -1)
  local desc = pango.Font.fontDescriptionFromString(FONT_WITH_MANUAL_SIZE)
  desc:setAbsoluteSize( FONT_SIZE * DEVICE_DPI * PANGO_SCALE / (72.0))

  local w,_ = layout:getSize()
  layout:setFontDescription(desc)

  cr:setSourceRgb(0.0, 0.0, 0.0)
  pango.PangoCairo.updatePangoLayout(cr, layout)

  cr:moveTo (10,10)
  pango.PangoCairo.showPangoLayout(cr, layout)
end

local xcb = require("xcb")
local conn = xcb.connect()
local screen = conn:getSetup():setupRootsIterator().data

local window = conn:createWindow({
  parent=screen.root,
  visual=screen.root_visual,
  x=20, y=20, w=650, h=150, border=10,
  class = xcb.WindowClass.InputOutput,
  mask=xcb.CW.BackPixel | xcb.CW.EventMask,
  value0=screen.white_pixel,
  value1=xcb.EventMask.Exposure | xcb.EventMask.KeyPress
})
conn:mapWindow(window)
conn:flush()
local visual = cairo.findVisual(conn, screen.root_visual)
local surface = cairo.xcbSurfaceCreate(conn, window.id, visual, 650, 150)
local cr = surface:cairoCreate()
--cr:scale(1 * TWEAKABLE_SCALE, 1 * TWEAKABLE_SCALE)
conn:flush()

local e = conn:waitForEvent()
while (e) do
  local response_type = e.response_type
  if (response_type == xcb.EventType.Expose) then
    cr:setSourceRgb(.9, .9, .9)
    cr:paint()
    draw_text (cr)
    surface:flush()
    conn:flush()
  elseif (response_type == xcb.EventType.KeyPress) then
    break
  elseif (response_type == 0) then
    if (e.error_code) then
      print(string.format("Event error code:%i", e.error_code))
    else
      print("Event error code:null")
    end
  end
  e = conn:waitForEvent()
end
conn:disconnect()
