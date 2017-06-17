%module swig_hb_ft
%{
 #include <hb.h>
 #include <hb-ft.h>
%}
#define HB_H_IN
#define HB_EXTERN extern
#define HB_BEGIN_DECLS
#define HB_END_DECLS
/* torturous sequences of typedefs */
%import "../ft/freetype.hh"
%include <hb-ft.h>
/*%callback("%s_cb");*/
/*void hb_font_destroy(hb_font_t *font);*/
/*void hb_face_destroy(hb_face_t *face);*/
/*%nocallback;*/
