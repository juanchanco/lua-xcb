local fc = require("swig_fc")
local result = fc.FcInit()
print(result)
local config = fc.FcConfigGetCurrent();
fc.FcConfigSetRescanInterval(config, 0);
local pat = fc.FcPatternCreate();
local os = fc.fcObjectSetBuild (fc.FC_FAMILY, fc.FC_STYLE, fc.FC_LANG);
local fs = fc.FcFontList(config, pat, os);
print(string.format("Total fonts: %s", fs.nfont))
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
