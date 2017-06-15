local xcb = require("swig_xcb")

--for k,v in pairs(xcb) do
--for k,v in pairs(getmetatable(xcb.xcb_screen_t)) do
  --local m = getmetatable(xcb.xcb_key_press_event_t)
  --if (m.__gc) then
    --print(k)
  --end
  --print(string.format("%s = %s", k, v))
--end
local c = xcb.xcb_connect(nil, 0)
print(c)
local ConnectionError = {
    Error = xcb.XCB_CONN_ERROR,
    ClosedExtNotsupported = xcb.XCB_CONN_CLOSED_EXT_NOTSUPPORTED,
    ClosedMemInsufficient = xcb.XCB_CONN_CLOSED_MEM_INSUFFICIENT,
    ClosedReqLenExceed = xcb.XCB_CONN_CLOSED_REQ_LEN_EXCEED,
    ClosedParseErr = xcb.XCB_CONN_CLOSED_PARSE_ERR,
    ClosedInvalidScreen = xcb.XCB_CONN_CLOSED_INVALID_SCREEN,
    ClosedFdpassingFailed = xcb.XCB_CONN_CLOSED_FDPASSING_FAILED
}

local WindowClass = {
    CopyFromParent = xcb.XCB_WINDOW_CLASS_COPY_FROM_PARENT,
    InputOutput = xcb.XCB_WINDOW_CLASS_INPUT_OUTPUT,
    InputOnly = xcb.XCB_WINDOW_CLASS_INPUT_ONLY
}
local CW = {
    BackPixmap = xcb.XCB_CW_BACK_PIXMAP,
    BackPixel = xcb.XCB_CW_BACK_PIXEL,
    BorderPixmap = xcb.XCB_CW_BORDER_PIXMAP,
    BorderPixel = xcb.XCB_CW_BORDER_PIXEL,
    BitGravity = xcb.XCB_CW_BIT_GRAVITY,
    WinGravity = xcb.XCB_CW_WIN_GRAVITY,
    BackingStore = xcb.XCB_CW_BACKING_STORE,
    BackingPlanes = xcb.XCB_CW_BACKING_PLANES,
    BackingPixel = xcb.XCB_CW_BACKING_PIXEL,
    OverrideRedirect = xcb.XCB_CW_OVERRIDE_REDIRECT,
    SaveUnder = xcb.XCB_CW_SAVE_UNDER,
    EventMask = xcb.XCB_CW_EVENT_MASK,
    DontPropagate = xcb.XCB_CW_DONT_PROPAGATE,
    Colormap = xcb.XCB_CW_COLORMAP,
    Cursor = xcb.XCB_CW_CURSOR
}

--[[local Defines = {
    None = xcb.XCB_NONE,
    CopyFromParent = xcb.XCB_COPY_FROM_PARENT,
    CurrentTime = xcb.XCB_CURRENT_TIME,
    NoSymbol = xcb.XCB_NO_SYMBOL
}]]
local GC = {
    Function = xcb.XCB_GC_FUNCTION,
    Plane_mask = xcb.XCB_GC_PLANE_MASK,
    Foreground = xcb.XCB_GC_FOREGROUND,
    Background = xcb.XCB_GC_BACKGROUND,
    LineWidth = xcb.XCB_GC_LINE_WIDTH,
    LineStyle = xcb.XCB_GC_LINE_STYLE,
    CapStyle = xcb.XCB_GC_CAP_STYLE,
    JoinStyle = xcb.XCB_GC_JOIN_STYLE,
    FillStyle = xcb.XCB_GC_FILL_STYLE,
    FillRule = xcb.XCB_GC_FILL_RULE,
    Tile = xcb.XCB_GC_TILE,
    Stipple = xcb.XCB_GC_STIPPLE,
    TileStippleOriginX = xcb.XCB_GC_TILE_STIPPLE_ORIGIN_X,
    TileStippleOriginY = xcb.XCB_GC_TILE_STIPPLE_ORIGIN_Y,
    Font = xcb.XCB_GC_FONT,
    SubwindowMode = xcb.XCB_GC_SUBWINDOW_MODE,
    GraphicsExposures = xcb.XCB_GC_GRAPHICS_EXPOSURES,
    ClipOriginX = xcb.XCB_GC_CLIP_ORIGIN_X,
    ClipOriginY = xcb.XCB_GC_CLIP_ORIGIN_Y,
    ClipMask = xcb.XCB_GC_CLIP_MASK,
    DashOffset = xcb.XCB_GC_DASH_OFFSET,
    DashList = xcb.XCB_GC_DASH_LIST,
    ArcMode = xcb.XCB_GC_ARC_MODE
}

return {
  ConnectionError = ConnectionError,
  WindowClass = WindowClass,
  CW = CW,
  GC = GC
}
