#
# Install h5py library from source
#

if (NOT h5py_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)
include (PatchSupport)

include (python)
include (hdf5)
include (numpy)

external_source (h5py
    2.5.0
    h5py-2.5.0.tar.gz
    6e4301b5ad5da0d51b0a1e5ac19e3b74
    https://pypi.python.org/packages/source/h/h5py)

message ("Installing ${h5py_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${h5py_NAME}
    DEPENDS             ${python_NAME} ${hdf5_NAME} ${numpy_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${h5py_URL}
    URL_MD5             ${h5py_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ${BUILDEM_ENV_STRING} ${PATCH_EXE}
            # This patch adds a linker flag on linux to allow for packaging executables
            ${h5py_SRC_DIR}/setup.py ${PATCH_DIR}/h5py.patch
            # do not specify a runtime path for the library, -R flag is unknown to newer GCCs
            ${h5py_SRC_DIR}/setup.py ${PATCH_DIR}/h5py-no-runtime.patch
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py build 
        --hdf5=${BUILDEM_DIR}
    BUILD_IN_SOURCE     1
    TEST_COMMAND        ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py test
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
)

set_target_properties(${h5py_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT h5py_NAME)
