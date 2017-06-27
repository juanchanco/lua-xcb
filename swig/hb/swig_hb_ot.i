%module swig_hb_ot
%{
 #include <hb-ot.h>
%}
#define HB_H_IN
#define HB_OT_H_IN
#define HB_EXTERN extern
#define HB_BEGIN_DECLS
#define HB_END_DECLS
/* torturous sequences of typedefs */
%import "../ft/freetype.hh"
%include <hb-ot-font.h>
/*%inline %{
hb_face_t * hb_ft_face_create_null_func (FT_Face ft_face) {
    return hb_ft_face_create (ft_face, NULL);
}
hb_font_t * hb_ft_font_create_null_func (FT_Face ft_face) {
    return hb_ft_font_create (ft_face, NULL);
}
%}*/
