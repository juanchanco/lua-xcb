%module swig_hb_icu
%{
 #include <hb.h>
 #include <hb-icu.h>
%}
#define HB_H_IN
#define HB_EXTERN extern
#define HB_BEGIN_DECLS
#define HB_END_DECLS
%include <hb-icu.h>
