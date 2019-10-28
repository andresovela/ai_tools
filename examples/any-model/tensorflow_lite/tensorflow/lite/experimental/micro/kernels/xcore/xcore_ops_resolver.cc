#include "xcore_ops_resolver.h"

// XMOS custom operators
#include "xcore/maxpool.h"
#include "xcore/argmax.h"
#include "xcore/conv2d_deepin_deepout.h"
#include "xcore/conv2d_shallowin_deepout.h"
#include "xcore/fc_deepin_shallowout_final.h"

namespace tflite {
namespace ops {
namespace micro {

// TfLiteRegistration* Register_DEPTHWISE_CONV_2D();
// TfLiteRegistration* Register_FULLY_CONNECTED();
// TfLiteRegistration* Register_SOFTMAX();
// TfLiteRegistration* Register_SVDF();
// TfLiteRegistration* Register_CONV_2D();
// TfLiteRegistration* Register_AVERAGE_POOL_2D();
// TfLiteRegistration* Register_MAX_POOL_2D();
// TfLiteRegistration* Register_ABS();
// TfLiteRegistration* Register_SIN();
// TfLiteRegistration* Register_COS();
// TfLiteRegistration* Register_LOG();
// TfLiteRegistration* Register_SQRT();
// TfLiteRegistration* Register_RSQRT();
// TfLiteRegistration* Register_SQUARE();
// TfLiteRegistration* Register_PRELU();
// TfLiteRegistration* Register_FLOOR();
// TfLiteRegistration* Register_MAXIMUM();
// TfLiteRegistration* Register_MINIMUM();
// TfLiteRegistration* Register_ARG_MAX();
// TfLiteRegistration* Register_ARG_MIN();
// TfLiteRegistration* Register_LOGICAL_OR();
// TfLiteRegistration* Register_LOGICAL_AND();
// TfLiteRegistration* Register_LOGICAL_NOT();
// TfLiteRegistration* Register_RESHAPE();
// TfLiteRegistration* Register_EQUAL();
// TfLiteRegistration* Register_NOT_EQUAL();
// TfLiteRegistration* Register_GREATER();
// TfLiteRegistration* Register_GREATER_EQUAL();
// TfLiteRegistration* Register_LESS();
// TfLiteRegistration* Register_LESS_EQUAL();
// TfLiteRegistration* Register_CEIL();
// TfLiteRegistration* Register_ROUND();
// TfLiteRegistration* Register_STRIDED_SLICE();
// TfLiteRegistration* Register_PACK();
// TfLiteRegistration* Register_SPLIT();
// TfLiteRegistration* Register_UNPACK();
// TfLiteRegistration* Register_NEG();
// TfLiteRegistration* Register_ADD();

XcoreOpsResolver::XcoreOpsResolver() {
//   AddBuiltin(BuiltinOperator_DEPTHWISE_CONV_2D, Register_DEPTHWISE_CONV_2D());
//   AddBuiltin(BuiltinOperator_FULLY_CONNECTED, Register_FULLY_CONNECTED(),
//              /* min_version */ 1,
//              /* max_version */ 4);
//   AddBuiltin(BuiltinOperator_MAX_POOL_2D, Register_MAX_POOL_2D());
  //  AddBuiltin(BuiltinOperator_SOFTMAX, Register_SOFTMAX());
//   AddBuiltin(BuiltinOperator_SVDF, Register_SVDF());
//   AddBuiltin(BuiltinOperator_CONV_2D, Register_CONV_2D());
//   AddBuiltin(BuiltinOperator_AVERAGE_POOL_2D, Register_AVERAGE_POOL_2D());
//   AddBuiltin(BuiltinOperator_ABS, Register_ABS());
//   AddBuiltin(BuiltinOperator_SIN, Register_SIN());
//   AddBuiltin(BuiltinOperator_COS, Register_COS());
//   AddBuiltin(BuiltinOperator_LOG, Register_LOG());
//   AddBuiltin(BuiltinOperator_SQRT, Register_SQRT());
//   AddBuiltin(BuiltinOperator_RSQRT, Register_RSQRT());
//   AddBuiltin(BuiltinOperator_SQUARE, Register_SQUARE());
//   AddBuiltin(BuiltinOperator_PRELU, Register_PRELU());
//   AddBuiltin(BuiltinOperator_FLOOR, Register_FLOOR());
//   AddBuiltin(BuiltinOperator_MAXIMUM, Register_MAXIMUM());
//   AddBuiltin(BuiltinOperator_MINIMUM, Register_MINIMUM());
//   AddBuiltin(BuiltinOperator_ARG_MAX, Register_ARG_MAX());
//   AddBuiltin(BuiltinOperator_ARG_MIN, Register_ARG_MIN());
//   AddBuiltin(BuiltinOperator_LOGICAL_OR, Register_LOGICAL_OR());
//   AddBuiltin(BuiltinOperator_LOGICAL_AND, Register_LOGICAL_AND());
//   AddBuiltin(BuiltinOperator_LOGICAL_NOT, Register_LOGICAL_NOT());
//   AddBuiltin(BuiltinOperator_RESHAPE, Register_RESHAPE());
//   AddBuiltin(BuiltinOperator_EQUAL, Register_EQUAL());
//   AddBuiltin(BuiltinOperator_NOT_EQUAL, Register_NOT_EQUAL());
//   AddBuiltin(BuiltinOperator_GREATER, Register_GREATER());
//   AddBuiltin(BuiltinOperator_GREATER_EQUAL, Register_GREATER_EQUAL());
//   AddBuiltin(BuiltinOperator_LESS, Register_LESS());
//   AddBuiltin(BuiltinOperator_LESS_EQUAL, Register_LESS_EQUAL());
//   AddBuiltin(BuiltinOperator_CEIL, Register_CEIL());
//   AddBuiltin(BuiltinOperator_ROUND, Register_ROUND());
//   AddBuiltin(BuiltinOperator_STRIDED_SLICE, Register_STRIDED_SLICE());
//   AddBuiltin(BuiltinOperator_PACK, Register_PACK());
//   AddBuiltin(BuiltinOperator_SPLIT, Register_SPLIT(),
//              /* min_version */ 1,
//              /* max_version */ 3);
//   AddBuiltin(BuiltinOperator_UNPACK, Register_UNPACK());
//   AddBuiltin(BuiltinOperator_NEG, Register_NEG());
//   AddBuiltin(BuiltinOperator_ADD, Register_ADD());
    AddCustom("XC_argmax_16", Register_ArgMax16());
    AddCustom("XC_maxpool2d_deep", Register_MaxPool2DDeep());
    AddCustom("XC_fc_deepin_shallowout_final", Register_FCDeepinShallowoutFinal());
    AddCustom("XC_conv2d_shallowin_deepout_relu", Register_Conv2DShallowinDeepoutFinal());
    AddCustom("XC_conv2d_deepin_deepout_relu", Register_Conv2DDeepinDeepoutFinal());
}

}  // namespace micro
}  // namespace ops
}  // namespace tflite