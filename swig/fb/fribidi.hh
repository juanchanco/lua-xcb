 int fribidi_debug_status (
  void
);
 int
fribidi_set_debug (
  int state
);
typedef unsigned char fribidi_int8;
typedef signed short fribidi_int16;
typedef signed int fribidi_int32;
typedef unsigned char fribidi_uint8;
typedef unsigned short fribidi_uint16;
typedef unsigned int fribidi_uint32;
typedef int fribidi_boolean;
typedef fribidi_uint32 FriBidiChar;
typedef int FriBidiStrIndex;
extern const char *fribidi_unicode_version;
typedef fribidi_uint32 FriBidiFlags;
typedef signed char FriBidiLevel;
typedef enum
{
FRIBIDI_TYPE_LTR = ( 0x00000010L | 0x00000100L ),
FRIBIDI_TYPE_RTL = ( 0x00000010L | 0x00000100L | 0x00000001L),
FRIBIDI_TYPE_AL = ( 0x00000010L | 0x00000100L | 0x00000001L | 0x00000002L ),
FRIBIDI_TYPE_EN = ( 0x00000020L | 0x00000200L ),
FRIBIDI_TYPE_AN = ( 0x00000020L | 0x00000200L | 0x00000002L ),
FRIBIDI_TYPE_ES = ( 0x00000020L | 0x00000400L | 0x00010000L ),
FRIBIDI_TYPE_ET = ( 0x00000020L | 0x00000400L | 0x00020000L ),
FRIBIDI_TYPE_CS = ( 0x00000020L | 0x00000400L | 0x00040000L ),
FRIBIDI_TYPE_NSM = ( 0x00000020L | 0x00080000L ),
FRIBIDI_TYPE_BN = ( 0x00000020L | 0x00000800L | 0x00100000L ),
FRIBIDI_TYPE_BS = ( 0x00000040L | 0x00000800L | 0x00002000L | 0x00200000L ),
FRIBIDI_TYPE_SS = ( 0x00000040L | 0x00000800L | 0x00002000L | 0x00400000L ),
FRIBIDI_TYPE_WS = ( 0x00000040L | 0x00000800L | 0x00800000L ),
FRIBIDI_TYPE_ON = ( 0x00000040L ),
FRIBIDI_TYPE_LRE = ( 0x00000010L | 0x00001000L),
FRIBIDI_TYPE_RLE = ( 0x00000010L | 0x00001000L | 0x00000001L ),
FRIBIDI_TYPE_LRO = ( 0x00000010L | 0x00001000L | 0x00004000L ),
FRIBIDI_TYPE_RLO = ( 0x00000010L | 0x00001000L | 0x00000001L | 0x00004000L ),
FRIBIDI_TYPE_PDF = ( 0x00000020L | 0x00001000L ),
  _FRIBIDI_TYPE_SENTINEL = ( 0x00000080L )
} ;
typedef enum
{
FRIBIDI_PAR_LTR = ( 0x00000010L | 0x00000100L ),
FRIBIDI_PAR_RTL = ( 0x00000010L | 0x00000100L | 0x00000001L),
FRIBIDI_PAR_ON = ( 0x00000040L ),
FRIBIDI_PAR_WLTR = ( 0x00000020L ),
FRIBIDI_PAR_WRTL = ( 0x00000020L | 0x00000001L ),
  _FRIBIDI_PAR_SENTINEL = ( 0x00000080L )
} FriBidiParType;
 FriBidiCharType
fribidi_get_bidi_type (
  FriBidiChar ch
) ;
     void fribidi_get_bidi_types (
  const FriBidiChar *str,
  const FriBidiStrIndex len,
  FriBidiCharType *btypes
);
     const char *fribidi_get_bidi_type_name (
  FriBidiCharType t
) ;
 FriBidiParType fribidi_get_par_direction (
  const FriBidiCharType *bidi_types,
  const FriBidiStrIndex len
);
 FriBidiLevel
fribidi_get_par_embedding_levels (
  const FriBidiCharType *bidi_types,
  const FriBidiStrIndex len,
  FriBidiParType *pbase_dir,
  FriBidiLevel *embedding_levels
) ;
     FriBidiLevel fribidi_reorder_line (
  FriBidiFlags flags,
  const FriBidiCharType *bidi_types,
  const FriBidiStrIndex len,
  const FriBidiStrIndex off,
  const FriBidiParType base_dir,
  FriBidiLevel *embedding_levels,
  FriBidiChar *visual_str,
  FriBidiStrIndex *map
) ;
enum _FriBidiJoiningTypeEnum
{
FRIBIDI_JOINING_TYPE_U = ( 0 ),
FRIBIDI_JOINING_TYPE_R = ( 0x01 | 0x04 ),
FRIBIDI_JOINING_TYPE_D = ( 0x01 | 0x02 | 0x04 ),
FRIBIDI_JOINING_TYPE_C = ( 0x01 | 0x02 ),
FRIBIDI_JOINING_TYPE_T = ( 0x08 | 0x04 ),
FRIBIDI_JOINING_TYPE_L = ( 0x02 | 0x04 ),
FRIBIDI_JOINING_TYPE_G = ( 0x10 ),
  _FRIBIDI_JOINING_TYPE_JUNK
};
typedef fribidi_uint8 FriBidiJoiningType;
typedef fribidi_uint8 FriBidiArabicProp;
 FriBidiJoiningType
fribidi_get_joining_type (
  FriBidiChar ch
) ;
     void fribidi_get_joining_types (
  const FriBidiChar *str,
  const FriBidiStrIndex len,
  FriBidiJoiningType *jtypes
);
     const char *fribidi_get_joining_type_name (
  FriBidiJoiningType j
) ;
 void fribidi_join_arabic (
  const FriBidiCharType *bidi_types,
  const FriBidiStrIndex len,
  const FriBidiLevel *embedding_levels,
  FriBidiArabicProp *ar_props
);
 fribidi_boolean fribidi_get_mirror_char (
  FriBidiChar ch,
  FriBidiChar *mirrored_ch
);
 void fribidi_shape_mirroring (
  const FriBidiLevel *embedding_levels,
  const FriBidiStrIndex len,
  FriBidiChar *str
);
 void
fribidi_shape_arabic (
  FriBidiFlags flags,
  const FriBidiLevel *embedding_levels,
  const FriBidiStrIndex len,
  FriBidiArabicProp *ar_props,
  FriBidiChar *str
);
 void fribidi_shape (
  FriBidiFlags flags,
  const FriBidiLevel *embedding_levels,
  const FriBidiStrIndex len,
  FriBidiArabicProp *ar_props,
  FriBidiChar *str
);
typedef enum
{
  _FRIBIDI_CHAR_SET_NOT_FOUND,
FRIBIDI_CHAR_SET_UTF8,
FRIBIDI_CHAR_SET_CAP_RTL,
FRIBIDI_CHAR_SET_ISO8859_6,
FRIBIDI_CHAR_SET_ISO8859_8,
FRIBIDI_CHAR_SET_CP1255,
FRIBIDI_CHAR_SET_CP1256,
  _FRIBIDI_CHAR_SETS_NUM_PLUS_ONE
}
FriBidiCharSet;
 FriBidiStrIndex fribidi_charset_to_unicode (
  FriBidiCharSet char_set,
  const char *s,
  FriBidiStrIndex len,
  FriBidiChar *us
);
 FriBidiStrIndex fribidi_unicode_to_charset (
  FriBidiCharSet char_set,
  const FriBidiChar *us,
  FriBidiStrIndex len,
  char *s
);
 FriBidiCharSet fribidi_parse_charset (
  const char *s
);
 const char *fribidi_char_set_name (
  FriBidiCharSet char_set
);
 const char *fribidi_char_set_title (
  FriBidiCharSet char_set
);
 const char *fribidi_char_set_desc (
  FriBidiCharSet char_set
);
     fribidi_boolean fribidi_mirroring_status (
  void
) ;
     fribidi_boolean fribidi_set_mirroring (
  fribidi_boolean state
) ;
     fribidi_boolean fribidi_reorder_nsm_status (
  void
) ;
     fribidi_boolean fribidi_set_reorder_nsm (
  fribidi_boolean state
) ;
 FriBidiLevel
fribidi_log2vis_get_embedding_levels (
  const FriBidiCharType *bidi_types,
  const FriBidiStrIndex len,
  FriBidiParType *pbase_dir,
  FriBidiLevel *embedding_levels
) ;
 FriBidiCharType
fribidi_get_type (
  FriBidiChar ch
) ;
 FriBidiCharType
fribidi_get_type_internal (
  FriBidiChar ch
) ;
 FriBidiStrIndex
fribidi_remove_bidi_marks (
  FriBidiChar *str,
  const FriBidiStrIndex len,
  FriBidiStrIndex *positions_to_this,
  FriBidiStrIndex *position_from_this_list,
  FriBidiLevel *embedding_levels
)
     ;
     FriBidiLevel fribidi_log2vis (
  const FriBidiChar *str,
  const FriBidiStrIndex len,
  FriBidiParType *pbase_dir,
  FriBidiChar *visual_str,
  FriBidiStrIndex *positions_L_to_V,
  FriBidiStrIndex *positions_V_to_L,
  FriBidiLevel *embedding_levels
)
     ;
     extern const char *fribidi_version_info;
