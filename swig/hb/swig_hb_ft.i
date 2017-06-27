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
%import <hb-common.h>
%import "../ft/freetype.hh"
%include <hb-ft.h>
/*%callback("%s_cb");*/
/*void hb_font_destroy(hb_font_t *font);*/
/*void hb_face_destroy(hb_face_t *face);*/
/*%nocallback;*/
/*%inline %{*/
/*hb_face_t * hb_ft_face_create_null_func (FT_Face ft_face) {*/
    /*return hb_ft_face_create (ft_face, NULL);*/
/*}*/
/*hb_font_t * hb_ft_font_create_null_func (FT_Face ft_face) {*/
    /*return hb_ft_font_create (ft_face, NULL);*/
/*}*/
/*%}*/
