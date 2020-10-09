# Copyright (c) 2020, XMOS Ltd, All rights reserved
import numpy as np
from typing import Tuple

from tflite2xcore.utils import (
    WORD_SIZE_BITS,
    VECTOR_SIZE_BITS,
    ACC_PERIOD,
    calculate_same_padding,
    calculate_same_output_size,
)
from tflite2xcore.xcore_model import Operator
from tflite2xcore.xcore_schema import (
    Padding,
    TensorType,
    ExternalOpCodes,
    XCOREOpCodes,
    OperatorCode,
    BuiltinOpCodes,
)

from .transformation_passes import (
    OperatorMatchingPass,
    ReplaceQuantizedOperatorPass,
)
from .conv2d_passes import ReplaceConv2DPass


class ReplaceBconv2DPass(ReplaceConv2DPass):
    @property
    def matching_opcode(self) -> ExternalOpCodes:
        return ExternalOpCodes.add_new_opcode("LceBconv2d")

    @property
    def matching_input_type(self) -> TensorType:
        return TensorType.INT32

    @property
    def matching_biases_type(self) -> TensorType:
        return TensorType.INT32

    @property
    def matching_weights_type(self) -> TensorType:
        return TensorType.INT32

    @property
    def _strides(self) -> Tuple[int, int]:
        options = self._op.custom_options
        return options["stride_height"], options["stride_width"]

    @property
    def _dilation(self) -> Tuple[int, int]:
        options = self._op.custom_options
        return options["dilation_height_factor"], options["dilation_width_factor"]

    @property
    def _padding(self) -> Padding:
        return self._op.custom_options["padding"]

    @property
    def _input_channels(self) -> int:
        return self._op.custom_options["channels_in"]

    def match(self, op: Operator) -> bool:
        # other versions of the LCE op can have different number of inputs
        if super().match(op) and len(op.inputs) == 3:
            with self.using(op):
                inferred_input_channels = self._weights.shape[3] * WORD_SIZE_BITS
                if inferred_input_channels == self._input_channels:
                    # number of input channels must be multiple of 256
                    return inferred_input_channels % VECTOR_SIZE_BITS == 0
                else:
                    self.logger.warning(
                        f"Found {self.matching_opcode} operator "
                        f"with {self._input_channels} "
                        "(not a multiple of 32) input channels."
                    )

        return False

    def mutate(self, op: Operator) -> None:
        new_op = super().mutate(op)
        with self.using(op):
            new_op.add_custom_options(
                stride=self._strides, padding=self._padding,
            )
        return new_op


class ReplaceBconv2DInt8OutPass(ReplaceBconv2DPass):
    @property
    def new_opcode(self):
        return OperatorCode(XCOREOpCodes.XC_bconv2d_int8_out)

    def match(self, op: Operator) -> bool:
        with self.using(op):
            return super().match(op) and self._weights.shape[0] % ACC_PERIOD == 0


class ReplaceBconv2DBitpackedOutPass(ReplaceBconv2DPass):
    @property
    def new_opcode(self) -> OperatorCode:
        return OperatorCode(XCOREOpCodes.XC_bconv2d_bin_out)

    @property
    def matching_output_type(self) -> TensorType:
        return TensorType.INT32
