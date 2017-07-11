%module swig_tinyc2
%{
#include "tinyc2.h"
%}
/*#define TINYC2_IMPL*/
#define __attribute__(x)
%include "tinyc2.h"
