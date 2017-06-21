local hb = require("swig_hb")
local hb_ft = require("swig_hb_ft")
local hb_glib = require("swig_hb_glib")

local bufferCreate = function()
  local buf = hb.hb_buffer_create()
  local mt = {}
  mt.__gc = function(self) hb.hb_buffer_destroy(self) end
  mt.__len = function(self) return hb.hb_buffer_get_length(self) end
  mt.__tostring = function(_) return "Harfbuzz Buffer" end
  mt.__index = {
    --setUnicodeFuncs = function(self, funcs)
      --hb.hb_buffer_set_unicode_funcs(self, funcs)
    --end,
    setDirection = function(self, direction)
      hb.hb_buffer_set_direction(self, direction)
    end,
    setScript = function(self, script)
      hb.hb_buffer_set_script(self, script)
    end,
    setLanguage = function(self, ln)
      hb.hb_buffer_set_language(self, ln)
    end,
    setLanguageFromName = function(self, name)
      hb.hb_buffer_set_language(self, hb.hb_language_from_string(name, #name))
    end,
    addUtf8 = function(self, text)
      -- TODO: what are the extra params for?
      hb.hb_buffer_add_utf8(self, text, #(text), 0, #(text))
    end,
    getGlyphInfos = function(self)
      local glyph_infos, glyph_count = hb.hb_buffer_get_glyph_infos(self);
      hb.setmetatable(glyph_infos, {
        __index = function(_, i)
          return hb.get_glyph_info(glyph_infos, i-1)
        end,
        __len = function(_) return glyph_count end,
      })
      -- TODO: need to maintain a reference to the buf to keep it from being
      -- GCed before glyph_infos?
      return glyph_infos
    end,
    getGlyphPositions = function(self)
      local glyph_positions, glyph_count = hb.hb_buffer_get_glyph_positions(self);
      hb.setmetatable(glyph_positions, {
        __index = function(_, i)
          return hb.get_glyph_position(glyph_positions, i-1)
        end,
        __len = function(_) return glyph_count end,
      })
      -- TODO: need to maintain a reference to the buf to keep it from being
      -- GCed before glyph_positions?
      return glyph_positions
    end,
    shape = function(self, font)
      -- TODO: what are the other params for?
      hb.hb_shape(font, self, nil, 0);
    end,
  }
  hb.setmetatable(buf, mt)
  hb.hb_buffer_set_unicode_funcs(buf, hb_glib.hb_glib_get_unicode_funcs())
  return buf
end

local ftFontCreate = function(ft_face)
  local hb_ft_font = hb_ft.hb_ft_font_create_null_func(ft_face)
  local mt = {
    __gc = function(_)
      hb.hb_font_destroy(hb_ft_font)
    end
  }
  hb.setmetatable(hb_ft_font, mt)
  return hb_ft_font
end

local Direction = {
  LTR = hb.HB_DIRECTION_LTR,
  RTL = hb.HB_DIRECTION_RTL,
  TTB = hb.HB_DIRECTION_TTB,
}

local Script = {
  Latin = hb.HB_SCRIPT_LATIN,
  Arabic = hb.HB_SCRIPT_ARABIC,
  Han = hb.HB_SCRIPT_HAN,
}

return {
  Direction = Direction,
  Script = Script,
  ftFontCreate = ftFontCreate,
  bufferCreate = bufferCreate,
}
