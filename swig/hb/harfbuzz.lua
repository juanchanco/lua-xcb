local hb = require("swig_hb")
local hb_ft = require("swig_hb_ft")
local hb_glib = require("swig_hb_glib")

local buffer_mt = {
  __gc = function(self) hb.hb_buffer_destroy(self) end,
  __len = function(self) return hb.hb_buffer_get_length(self) end,
  __tostring = function(_) return "Harfbuzz Buffer" end,
  __index = {
    setUnicodeFuncs = function(self, funcs)
      hb.hb_buffer_set_unicode_funcs(self, funcs)
    end,
    clearContents = function(self)
      hb.hb_buffer_clear_contents(self)
    end,
    setDirection = function(self, direction)
      hb.hb_buffer_set_direction(self, direction)
    end,
    setScript = function(self, script)
      hb.hb_buffer_set_script(self, script)
    end,
    setScriptAndDirection = function(self, script)
      hb.hb_buffer_set_script(self, script)
      hb.hb_buffer_set_direction(self, hb.hb_script_get_horizontal_direction(script))
    end,
    setLanguage = function(self, ln)
      hb.hb_buffer_set_language(self, ln)
    end,
    setLanguageFromName = function(self, name)
      hb.hb_buffer_set_language(self, hb.hb_language_from_string(name, #name))
    end,
    addUtf8 = function(self, text, offset, length)
      if (offset == nil) then offset = 0 end
      if (length == nil) then length = #text end
      hb.hb_buffer_add_utf8(self, text, #text, offset, length)
    end,
    --addUtf16 = function(self, text, offset, length)
      --if (offset == nil) then offset = 0 end
      --if (length == nil) then length = #text end
      --hb.hb_buffer_add_utf16(self, text, #text, offset, length)
    --end,
    --TODO: wrap u32 arrays
    addUtf32 = function(self, text, len, offset, length)
      if (offset == nil) then offset = 0 end
      if (length == nil) then length = #text end
      hb.hb_buffer_add_utf32(self, text, len, offset, length)
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
  },
}
local bufferCreate = function()
  local buf = hb.hb_buffer_create()
  hb.setmetatable(buf, buffer_mt)
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

local default_funcs = hb.hb_unicode_funcs_get_default()
local function unicodeFuncsGetDefault()
  return default_funcs
end

--TODO module level ufuncs?
local function unicodeScript(char, ufuncs)
  if (not(ufuncs)) then ufuncs = default_funcs end
  return hb.hb_unicode_script(ufuncs, char)
end

--TODO: are there other script functions? worth making an object?
local function getHorizontalDirection(char)
  return hb.hb_script_get_horizontal_direction(char)
end

local Direction = {
  Invalid = hb.HB_DIRECTION_INVALID,
  LTR = hb.HB_DIRECTION_LTR,
  RTL = hb.HB_DIRECTION_RTL,
  TTB = hb.HB_DIRECTION_TTB,
  BTT = hb.HB_DIRECTION_BTT,
}


local Script = {
  Common = hb.HB_SCRIPT_COMMON,
  Inherited = hb.HB_SCRIPT_INHERITED,
  Unknown = hb.HB_SCRIPT_UNKNOWN,
  Arabic = hb.HB_SCRIPT_ARABIC,
  Armenian = hb.HB_SCRIPT_ARMENIAN,
  Bengali = hb.HB_SCRIPT_BENGALI,
  Cyrillic = hb.HB_SCRIPT_CYRILLIC,
  Devanagari = hb.HB_SCRIPT_DEVANAGARI,
  Georgian = hb.HB_SCRIPT_GEORGIAN,
  Greek = hb.HB_SCRIPT_GREEK,
  Gujarati = hb.HB_SCRIPT_GUJARATI,
  Gurmukhi = hb.HB_SCRIPT_GURMUKHI,
  Hangul = hb.HB_SCRIPT_HANGUL,
  Han = hb.HB_SCRIPT_HAN,
  Hebrew = hb.HB_SCRIPT_HEBREW,
  Hiragana = hb.HB_SCRIPT_HIRAGANA,
  Kannada = hb.HB_SCRIPT_KANNADA,
  Katakana = hb.HB_SCRIPT_KATAKANA,
  Lao = hb.HB_SCRIPT_LAO,
  Latin = hb.HB_SCRIPT_LATIN,
  Malayalam = hb.HB_SCRIPT_MALAYALAM,
  Oriya = hb.HB_SCRIPT_ORIYA,
  Tamil = hb.HB_SCRIPT_TAMIL,
  Telugu = hb.HB_SCRIPT_TELUGU,
  Thai = hb.HB_SCRIPT_THAI,
  Tibetan = hb.HB_SCRIPT_TIBETAN,
  Bopomofo = hb.HB_SCRIPT_BOPOMOFO,
  Braille = hb.HB_SCRIPT_BRAILLE,
  CanadianSyllabics = hb.HB_SCRIPT_CANADIAN_SYLLABICS,
  Cherokee = hb.HB_SCRIPT_CHEROKEE,
  Ethiopic = hb.HB_SCRIPT_ETHIOPIC,
  Khmer = hb.HB_SCRIPT_KHMER,
  Mongolian = hb.HB_SCRIPT_MONGOLIAN,
  Myanmar = hb.HB_SCRIPT_MYANMAR,
  Ogham = hb.HB_SCRIPT_OGHAM,
  Runic = hb.HB_SCRIPT_RUNIC,
  Sinhala = hb.HB_SCRIPT_SINHALA,
  Syriac = hb.HB_SCRIPT_SYRIAC,
  Thaana = hb.HB_SCRIPT_THAANA,
  Yi = hb.HB_SCRIPT_YI,
  Deseret = hb.HB_SCRIPT_DESERET,
  Gothic = hb.HB_SCRIPT_GOTHIC,
  OldItalic = hb.HB_SCRIPT_OLD_ITALIC,
  Buhid = hb.HB_SCRIPT_BUHID,
  Hanunoo = hb.HB_SCRIPT_HANUNOO,
  Tagalog = hb.HB_SCRIPT_TAGALOG,
  Tagbanwa = hb.HB_SCRIPT_TAGBANWA,
  Cypriot = hb.HB_SCRIPT_CYPRIOT,
  Limbu = hb.HB_SCRIPT_LIMBU,
  LinearB = hb.HB_SCRIPT_LINEAR_B,
  Osmanya = hb.HB_SCRIPT_OSMANYA,
  Shavian = hb.HB_SCRIPT_SHAVIAN,
  TaiLe = hb.HB_SCRIPT_TAI_LE,
  Ugaritic = hb.HB_SCRIPT_UGARITIC,
  Buginese = hb.HB_SCRIPT_BUGINESE,
  Coptic = hb.HB_SCRIPT_COPTIC,
  Glagolitic = hb.HB_SCRIPT_GLAGOLITIC,
  Kharoshthi = hb.HB_SCRIPT_KHAROSHTHI,
  NewTaiLue = hb.HB_SCRIPT_NEW_TAI_LUE,
  OldPersian = hb.HB_SCRIPT_OLD_PERSIAN,
  SylotiNagri = hb.HB_SCRIPT_SYLOTI_NAGRI,
  Tifinagh = hb.HB_SCRIPT_TIFINAGH,
  Balinese = hb.HB_SCRIPT_BALINESE,
  Cuneiform = hb.HB_SCRIPT_CUNEIFORM,
  Nko = hb.HB_SCRIPT_NKO,
  PhagsPa = hb.HB_SCRIPT_PHAGS_PA,
  Phoenician = hb.HB_SCRIPT_PHOENICIAN,
  Carian = hb.HB_SCRIPT_CARIAN,
  Cham = hb.HB_SCRIPT_CHAM,
  KayahLi = hb.HB_SCRIPT_KAYAH_LI,
  Lepcha = hb.HB_SCRIPT_LEPCHA,
  Lycian = hb.HB_SCRIPT_LYCIAN,
  Lydian = hb.HB_SCRIPT_LYDIAN,
  OlChiki = hb.HB_SCRIPT_OL_CHIKI,
  Rejang = hb.HB_SCRIPT_REJANG,
  Saurashtra = hb.HB_SCRIPT_SAURASHTRA,
  Sundanese = hb.HB_SCRIPT_SUNDANESE,
  Vai = hb.HB_SCRIPT_VAI,
  Avestan = hb.HB_SCRIPT_AVESTAN,
  Bamum = hb.HB_SCRIPT_BAMUM,
  EgyptianHieroglyphs = hb.HB_SCRIPT_EGYPTIAN_HIEROGLYPHS,
  ImperialAramaic = hb.HB_SCRIPT_IMPERIAL_ARAMAIC,
  InscriptionalPahlavi = hb.HB_SCRIPT_INSCRIPTIONAL_PAHLAVI,
  InscriptionalParthian = hb.HB_SCRIPT_INSCRIPTIONAL_PARTHIAN,
  Javanese = hb.HB_SCRIPT_JAVANESE,
  Kaithi = hb.HB_SCRIPT_KAITHI,
  Lisu = hb.HB_SCRIPT_LISU,
  MeeteiMayek = hb.HB_SCRIPT_MEETEI_MAYEK,
  OldSouthArabian = hb.HB_SCRIPT_OLD_SOUTH_ARABIAN,
  OldTurkic = hb.HB_SCRIPT_OLD_TURKIC,
  Samaritan = hb.HB_SCRIPT_SAMARITAN,
  TaiTham = hb.HB_SCRIPT_TAI_THAM,
  TaiViet = hb.HB_SCRIPT_TAI_VIET,
  Batak = hb.HB_SCRIPT_BATAK,
  Brahmi = hb.HB_SCRIPT_BRAHMI,
  Mandaic = hb.HB_SCRIPT_MANDAIC,
  Chakma = hb.HB_SCRIPT_CHAKMA,
  MeroiticCursive = hb.HB_SCRIPT_MEROITIC_CURSIVE,
  MeroiticHieroglyphs = hb.HB_SCRIPT_MEROITIC_HIEROGLYPHS,
  Miao = hb.HB_SCRIPT_MIAO,
  Sharada = hb.HB_SCRIPT_SHARADA,
  SoraSompeng = hb.HB_SCRIPT_SORA_SOMPENG,
  Takri = hb.HB_SCRIPT_TAKRI,
  BassaVah = hb.HB_SCRIPT_BASSA_VAH,
  CaucasianAlbanian = hb.HB_SCRIPT_CAUCASIAN_ALBANIAN,
  Duployan = hb.HB_SCRIPT_DUPLOYAN,
  Elbasan = hb.HB_SCRIPT_ELBASAN,
  Grantha = hb.HB_SCRIPT_GRANTHA,
  Khojki = hb.HB_SCRIPT_KHOJKI,
  Khudawadi = hb.HB_SCRIPT_KHUDAWADI,
  LinearA = hb.HB_SCRIPT_LINEAR_A,
  Mahajani = hb.HB_SCRIPT_MAHAJANI,
  Manichaean = hb.HB_SCRIPT_MANICHAEAN,
  MendeKikakui = hb.HB_SCRIPT_MENDE_KIKAKUI,
  Modi = hb.HB_SCRIPT_MODI,
  Mro = hb.HB_SCRIPT_MRO,
  Nabataean = hb.HB_SCRIPT_NABATAEAN,
  OldNorthArabian = hb.HB_SCRIPT_OLD_NORTH_ARABIAN,
  OldPermic = hb.HB_SCRIPT_OLD_PERMIC,
  PahawhHmong = hb.HB_SCRIPT_PAHAWH_HMONG,
  Palmyrene = hb.HB_SCRIPT_PALMYRENE,
  PauCinHau = hb.HB_SCRIPT_PAU_CIN_HAU,
  PsalterPahlavi = hb.HB_SCRIPT_PSALTER_PAHLAVI,
  Siddham = hb.HB_SCRIPT_SIDDHAM,
  Tirhuta = hb.HB_SCRIPT_TIRHUTA,
  WarangCiti = hb.HB_SCRIPT_WARANG_CITI,
  Ahom = hb.HB_SCRIPT_AHOM,
  AnatolianHieroglyphs = hb.HB_SCRIPT_ANATOLIAN_HIEROGLYPHS,
  Hatran = hb.HB_SCRIPT_HATRAN,
  Multani = hb.HB_SCRIPT_MULTANI,
  OldHungarian = hb.HB_SCRIPT_OLD_HUNGARIAN,
  Signwriting = hb.HB_SCRIPT_SIGNWRITING,
  Adlam = hb.HB_SCRIPT_ADLAM,
  Bhaiksuki = hb.HB_SCRIPT_BHAIKSUKI,
  Marchen = hb.HB_SCRIPT_MARCHEN,
  Osage = hb.HB_SCRIPT_OSAGE,
  Tangut = hb.HB_SCRIPT_TANGUT,
  Newa = hb.HB_SCRIPT_NEWA,
  Invalid = hb.HB_SCRIPT_INVALID,
}

return {
  Direction = Direction,
  Script = Script,
  ftFontCreate = ftFontCreate,
  bufferCreate = bufferCreate,
  unicodeFuncsGetDefault = unicodeFuncsGetDefault,
  unicodeScript = unicodeScript,
}
