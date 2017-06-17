  typedef struct FT_Glyph_Class_ FT_Glyph_Class;
  typedef struct FT_GlyphRec_* FT_Glyph;
  typedef struct FT_GlyphRec_
  {
    FT_Library library;
    const FT_Glyph_Class* clazz;
    FT_Glyph_Format format;
    FT_Vector advance;
  } FT_GlyphRec;
  typedef struct FT_BitmapGlyphRec_* FT_BitmapGlyph;
  typedef struct FT_BitmapGlyphRec_
  {
    FT_GlyphRec root;
    FT_Int left;
    FT_Int top;
    FT_Bitmap bitmap;
  } FT_BitmapGlyphRec;
  typedef struct FT_OutlineGlyphRec_* FT_OutlineGlyph;
  typedef struct FT_OutlineGlyphRec_
  {
    FT_GlyphRec root;
    FT_Outline outline;
  } FT_OutlineGlyphRec;
  extern FT_Error
  FT_Get_Glyph( FT_GlyphSlot slot,
                FT_Glyph *aglyph );
  extern FT_Error
  FT_Glyph_Copy( FT_Glyph source,
                 FT_Glyph *target );
  extern FT_Error
  FT_Glyph_Transform( FT_Glyph glyph,
                      FT_Matrix* matrix,
                      FT_Vector* delta );
  typedef enum FT_Glyph_BBox_Mode_
  {
    FT_GLYPH_BBOX_UNSCALED = 0,
    FT_GLYPH_BBOX_SUBPIXELS = 0,
    FT_GLYPH_BBOX_GRIDFIT = 1,
    FT_GLYPH_BBOX_TRUNCATE = 2,
    FT_GLYPH_BBOX_PIXELS = 3
  } FT_Glyph_BBox_Mode;
  extern void
  FT_Glyph_Get_CBox( FT_Glyph glyph,
                     FT_UInt bbox_mode,
                     FT_BBox *acbox );
  extern FT_Error
  FT_Glyph_To_Bitmap( FT_Glyph* the_glyph,
                      FT_Render_Mode render_mode,
                      FT_Vector* origin,
                      FT_Bool destroy );
  extern void
  FT_Done_Glyph( FT_Glyph glyph );
  extern void
  FT_Matrix_Multiply( const FT_Matrix* a,
                      FT_Matrix* b );
  extern FT_Error
  FT_Matrix_Invert( FT_Matrix* matrix );
