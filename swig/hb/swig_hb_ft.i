%module swig_hb_ft
%{
 #include <hb.h>
 #include <hb-ft.h>
%}
#define HB_H_IN
#define HB_EXTERN extern
#define HB_BEGIN_DECLS
#define HB_END_DECLS
%include <hb-ft.h>
