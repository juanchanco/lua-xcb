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
%include <typemaps.i>
%apply unsigned int* INOUT {unsigned int *caret_count};
%typemap(in, numinputs=0) hb_position_t *caret_array (hb_position_t temp) {
  $1 = &temp;
}
%typemap(argout) hb_position_t *caret_array {
  lua_pushinteger(L, (int)* $1); SWIG_arg++;
}
%include <hb-ot-font.h>
%include <hb-ot-layout.h>
%include <hb-ot-math.h>
%include <hb-ot-tag.h>
%include <hb-ot-shape.h>
%include <hb-ot-var.h>
/*%inline %{
hb_face_t * hb_ft_face_create_null_func (FT_Face ft_face) {
    return hb_ft_face_create (ft_face, NULL);
}
hb_font_t * hb_ft_font_create_null_func (FT_Face ft_face) {
    return hb_ft_font_create (ft_face, NULL);
}
%}*/
