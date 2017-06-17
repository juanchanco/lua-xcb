%module swig_hb
%{
 #include <hb.h>
%}
#define HB_H_IN
#define HB_EXTERN extern
#define HB_BEGIN_DECLS
#define HB_END_DECLS
%include <hb-blob.h>
%include <hb-buffer.h>
%include <hb-common.h>
%include <hb-deprecated.h>
%include <hb-face.h>
%include <hb-font.h>
%include <hb-set.h>
%include <hb-shape.h>
%include <hb-shape-plan.h>
%include <hb-unicode.h>
%include <hb-version.h>
