local fc = require("swig_fc")
local result = fc.FcInit()
print(result)
local config = fc.FcConfigGetCurrent();
fc.FcConfigSetRescanInterval(config, 0);
local pat = fc.FcPatternCreate();
local os = fc.FcObjectSetBuild3(fc.FC_FAMILY, fc.FC_STYLE, fc.FC_FILE);
local fs = fc.FcFontList(config, pat, os);
print(string.format("Total fonts: %s", fs.nfont))
for i = 0, (fs.nfont-1) do
  local font = fc.get_FcPattern(fs.fonts, i)
  --fc.FcPatternPrint(font)
  local name = fc.FcNameUnparse(font)
  local code, file = fc.FcPatternGetString(font, fc.FC_FILE, 0)
  if (code == fc.FcResultMatch) then
    print(string.format("match %s: %s", fc.fcToString(name), fc.fcToString(file)))
  else
    print(string.format("NO MATCH for %s: %i", fc.fcToString(name), code))
  end
end
--FcPattern *pat;
--FcFontSet *fs;
--FcObjectSet *os;
--FcChar8 *s, *file;
--FcConfig *config;
--FcBool result;
--int i;

--result = FcInit();
--config = FcConfigGetCurrent();
--FcConfigSetRescanInterval(config, 0);

--// show the fonts (debugging)
--pat = FcPatternCreate();
--os = FcObjectSetBuild (FC_FAMILY, FC_STYLE, FC_LANG, (char *) 0);
--fs = FcFontList(config, pat, os);
--printf("Total fonts: %d", fs->nfont);
--for (i=0; fs && i < fs->nfont; i++) {
--FcPattern *font = fs->fonts[i];//FcFontSetFont(fs, i);
--FcPatternPrint(font);
--s = FcNameUnparse(font);
--if (FcPatternGetString(font, FC_FILE, 0, &file) == FcResultMatch) {
    --printf("Filename: %s", file);
--}
--printf("Font: %s", s);
--free(s);
--}
--if (fs) FcFontSetDestroy(fs);
