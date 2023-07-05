package(
    default_visibility = ["//visibility:public"],
)

filegroup(
    name = "TFLITE_SOURCES",
    srcs = [
        "@tflite_micro//tensorflow/lite/core/c:common.cc",
        "@tflite_micro//tensorflow/lite/core/api:error_reporter.cc",
        "@tflite_micro//tensorflow/lite/core/api:tensor_utils.cc",
        "@tflite_micro//tensorflow/lite/core/api:flatbuffer_conversions.cc",
        "@tflite_micro//tensorflow/lite/core/api:op_resolver.cc",
        "@tflite_micro//tensorflow/lite/kernels:kernel_util.cc",
        "@tflite_micro//tensorflow/lite/kernels/internal:quantization_util.cc",
        "@tflite_micro//tensorflow/lite/kernels/internal:portable_tensor_utils.cc",
        "@tflite_micro//tensorflow/lite/schema:schema_utils.cc",
        "@tflite_micro//tensorflow/lite/micro:micro_log.cc",
    ],
)

filegroup(
    name = "TFLM_SOURCES",
    srcs = [
        "@tflite_micro//tensorflow/lite/micro:all_ops_resolver.cc",
        "@tflite_micro//tensorflow/lite/micro:micro_op_resolver.cc",
        "@tflite_micro//tensorflow/lite/micro:micro_allocator.cc",
        "@tflite_micro//tensorflow/lite/micro:micro_allocation_info.cc",
        "@tflite_micro//tensorflow/lite/micro:micro_context.cc",
        "@tflite_micro//tensorflow/lite/micro:micro_graph.cc",
        "@tflite_micro//tensorflow/lite/micro:micro_interpreter.cc",
        "@tflite_micro//tensorflow/lite/micro:micro_profiler.cc",
        "@tflite_micro//tensorflow/lite/micro:micro_time.cc",
        "@tflite_micro//tensorflow/lite/micro:mock_micro_graph.cc",
        "@tflite_micro//tensorflow/lite/micro:recording_micro_allocator.cc",
        "@tflite_micro//tensorflow/lite/micro:system_setup.cc",
        "@tflite_micro//tensorflow/lite/micro:test_helpers.cc",
        "@tflite_micro//tensorflow/lite/micro:test_helper_custom_ops.cc",
        "@tflite_micro//tensorflow/lite/micro/arena_allocator:non_persistent_arena_buffer_allocator.cc",
        "@tflite_micro//tensorflow/lite/micro/arena_allocator:persistent_arena_buffer_allocator.cc",
        "@tflite_micro//tensorflow/lite/micro/arena_allocator:recording_single_arena_buffer_allocator.cc",
        "@tflite_micro//tensorflow/lite/micro/arena_allocator:single_arena_buffer_allocator.cc",
        "@tflite_micro//tensorflow/lite/micro/memory_planner:greedy_memory_planner.cc",
    ],
)

filegroup(
    name = "TFLM_KERNEL_SOURCES",
    srcs = [
        # We need to add below files to kernel sources as they are used from the kernels
        # and we need the files to link successfully
        "@tflite_micro//tensorflow/lite/micro:flatbuffer_utils.cc",
        "@tflite_micro//tensorflow/lite/micro/tflite_bridge:micro_error_reporter.cc",
        "@tflite_micro//tensorflow/lite/micro/tflite_bridge:flatbuffer_conversions_bridge.cc",
        "@tflite_micro//tensorflow/lite/micro:micro_resource_variable.cc",
        "@tflite_micro//tensorflow/lite/micro:micro_string.cc",
        "@tflite_micro//tensorflow/lite/micro:micro_utils.cc",
        "@tflite_micro//tensorflow/lite/micro:memory_helpers.cc",

        "@tflite_micro//tensorflow/lite/micro/kernels:activations.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:activations_common.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:add.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:add_common.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:add_n.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:slice.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:arg_min_max.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:batch_to_space_nd.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:broadcast_args.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:broadcast_to.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:cast.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:ceil.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:circular_buffer.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:circular_buffer_common.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:circular_buffer_flexbuffers_generated_data.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:comparisons.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:concatenation.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:conv.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:conv_common.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:cumsum.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:depth_to_space.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:depthwise_conv.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:depthwise_conv_common.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:dequantize.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:dequantize_common.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:detection_postprocess_flexbuffers_generated_data.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:div.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:elementwise.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:elu.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:ethosu.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:exp.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:expand_dims.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:fill.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:floor.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:floor_div.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:floor_mod.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:fully_connected.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:fully_connected_common.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:gather.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:gather_nd.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:hard_swish.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:hard_swish_common.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:kernel_util.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:l2_pool_2d.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:l2norm.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:leaky_relu.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:leaky_relu_common.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:log_softmax.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:logical.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:logical_common.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:logistic.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:logistic_common.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:maximum_minimum.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:mirror_pad.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:mul.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:mul_common.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:neg.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:pack.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:pad.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:pooling.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:pooling_common.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:prelu.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:prelu_common.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:quantize.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:quantize_common.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:reduce.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:reduce_common.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:reshape.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:resize_bilinear.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:resize_nearest_neighbor.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:round.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:select.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:shape.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:softmax.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:softmax_common.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:space_to_batch_nd.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:space_to_depth.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:split.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:split_v.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:squared_difference.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:squeeze.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:strided_slice.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:sub.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:sub_common.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:svdf.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:svdf_common.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:tanh.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:transpose.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:transpose_conv.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:unpack.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:micro_tensor_utils.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:lstm_eval.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:lstm_eval_common.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:unidirectional_sequence_lstm.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:zeros_like.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:if.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:while.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:call_once.cc",
    ],
)

filegroup(
    name = "EXTRA_KERNEL_SOURCES",
    srcs = [
        # We dont support these kernels yet for compiled models
        # They link with micro_graph from within the kernels
        "@tflite_micro//tensorflow/lite/micro/kernels:var_handle.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:read_variable.cc",
        "@tflite_micro//tensorflow/lite/micro/kernels:assign_variable.cc",
    ],
)

cc_library(
    name = "tflmc_lib",
    hdrs = [
        "src/CodeWriter.h",
        "src/Compiler.h",
        "src/MemMap.h",
        "src/TypeToString.h",
        "src/xtflm_conf.h",
        "@org_tensorflow//tensorflow/lite/kernels:padding.h",
        "@org_tensorflow//tensorflow/lite/kernels/internal:reference/pooling.h",
        "@org_tensorflow//tensorflow/lite/kernels/internal:reference/integer_ops/pooling.h",
    ],
    srcs = [
        "src/CodeWriter.cc",
        "src/Compiler.cc",
        "src/MemMap.cc",
        "src/TypeToString.cc",
        "@lib_tflite_micro//:XTFLIB_SOURCES",
        "@lib_tflite_micro//:XTFLIB_KERNEL_SOURCES",
        "//:TFLITE_SOURCES",
        "//:TFLM_SOURCES",
        "//:TFLM_KERNEL_SOURCES",
        "//:EXTRA_KERNEL_SOURCES",
    ],
    deps = [
        "@lib_nn//:nn_lib",
        "@lib_tflite_micro//:shared_headers",
    ],
    local_defines = [
        "__xtflm_conf_h_exists__",
        "NN_USE_REF",
        #"TF_LITE_STATIC_MEMORY",
        "TF_LITE_DISABLE_X86_NEON",
        "SUFFICIENT_ARENA_SIZE=128*1024*1024",
    ],
    includes = [
        "src",
        "../../external/lib_tflite_micro/lib_tflite_micro/submodules/tflite-micro",
        "../../external/lib_tflite_micro/lib_tflite_micro/submodules/flatbuffers/include",
        "../../external/lib_tflite_micro/lib_tflite_micro/submodules/gemmlowp",
        "../../external/lib_tflite_micro/lib_tflite_micro/submodules/ruy",
        "../../external/lib_tflite_micro/lib_tflite_micro/src/tflite-xcore-kernels",
        "../../external/lib_tflite_micro/lib_tflite_micro/src",
        "../../external/lib_tflite_micro/lib_tflite_micro/api",
    ],
)
