Building xmos-ai-tools
======================

* Some dependent libraries are included as git submodules. These can be obtained by cloning this repository with the following commands::

    git clone git@github.com:xmos/ai_tools.git
    cd ai_tools
    make submodule_update


* Install version 15 or later of the XMOS tools from your preferred location and activate it by sourcing ``SetEnv`` in the installation root.


* `CMake 3.23 <https://cmake.org/download/>`_ or newer is required for building libraries and test firmware.

* To set up and activate the environment, simply run::

    python -m venv ./venv
    . ./venv/bin/activate 


* Install the necessary python packages using ``pip``  inside the venv::
    ``pip install -r ./requirements.txt``

* Apply our patch for tflite-micro, run::
    ``cd third_party/lib_tflite_micro && make patch``

* Build the XCore host tflm interpreter libraries with default settings, run::
    ``make build``

After following the above instructions, to build xformer, please follow the build instructions `here <../../xformer#readme>`_. Upon building xformer, you may install ``xmos-ai-tools`` via ``cd python && pip install .``
