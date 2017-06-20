local xcb = require("swig_xcb")

local window_methods = {
  getGeometry = function(self)
    local cookie = xcb.xcb_get_geometry(self.connection, self.id)
    --TODO no one seems to use the error (always passing null) what do the codes mean?
    local reply,_ = xcb.xcb_get_geometry_reply(self.connection, cookie)
    return reply
  end,
}
local setup_methods = {
  setupRootsIterator = function(self) return xcb.xcb_setup_roots_iterator(self) end,
}
local connection_methods = {
  disconnect = function(self) return xcb.xcb_disconnect(self) end,
  hasError = function(self) return xcb.xcb_connection_has_error(self) end,
  getSetup = function(self) return xcb.xcb_get_setup(self) end,
  generateId = function(self) return xcb.xcb_generate_id(self) end,
  flush = function(self) return xcb.xcb_flush(self) end,
  waitForEvent = function(self) return xcb.xcb_wait_for_event_typed(self) end,
  pollForEvent = function(self) return xcb.xcb_poll_for_event_types(self) end,
  flush = function(self) return xcb.xcb_flush(self) end,
  mapWindow = function(self, win_id) xcb.xcb_map_window(self, win_id) end,
  unmapWindow = function(self, win_id) xcb.xcb_unmap_window(self, win_id) end,
}
--local c = xcb.xcb_connect(nil, 0)

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

local EventType = {
  KeyPress = xcb.XCB_KEY_PRESS,
  KeyRelease = xcb.XCB_KEY_RELEASE,
  ButtonPress = xcb.XCB_BUTTON_PRESS,
  ButtonRelease = xcb.XCB_BUTTON_RELEASE,
  MotionNotify = xcb.XCB_MOTION_NOTIFY,
  EnterNotify = xcb.XCB_ENTER_NOTIFY,
  LeaveNotify = xcb.XCB_LEAVE_NOTIFY,
  FocusIn = xcb.XCB_FOCUS_IN,
  FocusOut = xcb.XCB_FOCUS_OUT,
  KeymapNotify = xcb.XCB_KEYMAP_NOTIFY,
  Expose = xcb.XCB_EXPOSE,
  GraphicsExposure = xcb.XCB_GRAPHICS_EXPOSURE,
  NoExposure = xcb.XCB_NO_EXPOSURE,
  VisibilityNotify = xcb.XCB_VISIBILITY_NOTIFY,
  CreateNotify = xcb.XCB_CREATE_NOTIFY,
  DestroyNotify = xcb.XCB_DESTROY_NOTIFY,
  UnmapNotify = xcb.XCB_UNMAP_NOTIFY,
  MapNotify = xcb.XCB_MAP_NOTIFY,
  MapRequest = xcb.XCB_MAP_REQUEST,
  ReparentNotify = xcb.XCB_REPARENT_NOTIFY,
  ConfigureNotify = xcb.XCB_CONFIGURE_NOTIFY,
  ConfigureRequest = xcb.XCB_CONFIGURE_REQUEST,
  GravityNotify = xcb.XCB_GRAVITY_NOTIFY,
  ResizeRequest = xcb.XCB_RESIZE_REQUEST,
  CirculateNotify = xcb.XCB_CIRCULATE_NOTIFY,
  CirculateRequest = xcb.XCB_CIRCULATE_REQUEST,
  PropertyNotify = xcb.XCB_PROPERTY_NOTIFY,
  SelectionClear = xcb.XCB_SELECTION_CLEAR,
  SelectionRequest = xcb.XCB_SELECTION_REQUEST,
  SelectionNotify = xcb.XCB_SELECTION_NOTIFY,
  ColormapNotify = xcb.XCB_COLORMAP_NOTIFY,
  ClientMessage = xcb.XCB_CLIENT_MESSAGE,
  MappingNotify = xcb.XCB_MAPPING_NOTIFY
  --GeGeneric = xcb.XCB_GE_GENERIC,
}

local EventMask = {
  NoEvent = xcb.XCB_EVENT_MASK_NO_EVENT,
  KeyPress = xcb.XCB_EVENT_MASK_KEY_PRESS,
  KeyRelease = xcb.XCB_EVENT_MASK_KEY_RELEASE,
  ButtonPress = xcb.XCB_EVENT_MASK_BUTTON_PRESS,
  ButtonRelease = xcb.XCB_EVENT_MASK_BUTTON_RELEASE,
  EnterWindow = xcb.XCB_EVENT_MASK_ENTER_WINDOW,
  LeaveWindow = xcb.XCB_EVENT_MASK_LEAVE_WINDOW,
  PointerMotion = xcb.XCB_EVENT_MASK_POINTER_MOTION,
  PointerMotionHint = xcb.XCB_EVENT_MASK_POINTER_MOTION_HINT,
  Button1Motion = xcb.XCB_EVENT_MASK_BUTTON_1_MOTION,
  Button2Motion = xcb.XCB_EVENT_MASK_BUTTON_2_MOTION,
  Button3Motion = xcb.XCB_EVENT_MASK_BUTTON_3_MOTION,
  Button4Motion = xcb.XCB_EVENT_MASK_BUTTON_4_MOTION,
  Button5Motion = xcb.XCB_EVENT_MASK_BUTTON_5_MOTION,
  ButtonMotion = xcb.XCB_EVENT_MASK_BUTTON_MOTION,
  KeymapState = xcb.XCB_EVENT_MASK_KEYMAP_STATE,
  Exposure = xcb.XCB_EVENT_MASK_EXPOSURE,
  VisibilityChange = xcb.XCB_EVENT_MASK_VISIBILITY_CHANGE,
  StructureNotify = xcb.XCB_EVENT_MASK_STRUCTURE_NOTIFY,
  ResizeRedirect = xcb.XCB_EVENT_MASK_RESIZE_REDIRECT,
  SubstructureNotify = xcb.XCB_EVENT_MASK_SUBSTRUCTURE_NOTIFY,
  SubstructureRedirect = xcb.XCB_EVENT_MASK_SUBSTRUCTURE_REDIRECT,
  FocusChange = xcb.XCB_EVENT_MASK_FOCUS_CHANGE,
  PropertyChange = xcb.XCB_EVENT_MASK_PROPERTY_CHANGE,
  ColorMapChange = xcb.XCB_EVENT_MASK_COLOR_MAP_CHANGE,
  OwnerGrabButton = xcb.XCB_EVENT_MASK_OWNER_GRAB_BUTTON,
}
return {
  EventMask = EventMask,
  EventType = EventType,
  ConnectionError = ConnectionError,
  WindowClass = WindowClass,
  CW = CW,
  GC = GC
}
