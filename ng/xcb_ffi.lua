local ffi = require("ffi")
require("xcb_h")
local C = ffi.load("xcb")
local M = setmetatable({C = C}, {__index = C})

local function create_func(func, destroy_func)
	return function(...)
		local ptr = func(...)
		assert(ptr ~= nil)
		return ffi.gc(ptr, destroy_func)
	end
end

local function destroy_func(destroy_func)
	return function(ptr)
		ffi.gc(ptr, nil)
		destroy_func(ptr)
	end
end

return M
