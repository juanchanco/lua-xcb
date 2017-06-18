%module swig_hb_glib
%{
 #include <hb.h>
 #include <hb-glib.h>
%}
#define HB_H_IN
#define HB_EXTERN extern
#define HB_BEGIN_DECLS
#define HB_END_DECLS
%include <hb-glib.h>
