local ft = require("swig_freetype")

--TODO: is there a way to tell swig not to free() this?
local FT_FaceRec_mt = getmetatable(ft.FT_FaceRec)
FT_FaceRec_mt[".instance"].__gc = function(_) end

local face_metatable = {
  __index = {
    setCharSize = function(self, size, hdpi, vdpi)
      --TODO what is the second param for?
      ft.FT_Set_Char_Size(self, 0, size, hdpi, vdpi)
    end,
    --TODO: returns a status code
    setCharMap = function(self, map)
      ft.FT_Set_Charmap(self, map)
    end,
    getCharMapArray = function(self)
      local ftf = ft.derefFaceRec(self)
      local arr = {
        charmaps = ftf.charmaps
      }
      -- NOTE: swig has same metatable for this and cairo_glyph_t
      local mt = {}
      mt.__len = function(_) return ftf.num_charmaps end
      mt.__index = function(_, i)
        return swig_freetype.FT_CharMapArray_getitem(ftf.charmaps, i-1)
      end
      mt.__newindex = function(_, i, map)
        swig_freetype.FT_CharMapArray_setitem(ftf.charmaps, i-1, map)
      end
      setmetatable(arr, mt)
      return arr
    end,
    --TODO better understanding of swig. 
    deref = function(self)
      return ft.derefFaceRec(self)
    end
  }
}

local initFreeType = function()
  --TODO: check result code
  local _,ft_library = ft.FT_Init_FreeType()
  local mt = {
    __gc = function(_) ft.FT_Done_FreeType(ft_library) end,
    __index = {
      newFace = function(self, path)
        --TODO what is the last param for?
        --TODO check error
        local _,ft_face = ft.FT_New_Face(self, path, 0)
        ft.setmetatable(ft_face, face_metatable)
        return ft_face
      end,
    },
  }
  ft.setmetatable(ft_library, mt)
  return ft_library
end

local dumpChars = function(chars)
  ft.dumpChars(chars, #chars)
end

return {
  initFreeType = initFreeType,
  dumpChars = dumpChars,
}
