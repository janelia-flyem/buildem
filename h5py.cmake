#
# Install h5py library from source
#

if (NOT h5py_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

include (python)
include (hdf5)
include (numpy)
include (cython)

external_source (h5py
    2.3.1
    h5py-2.3.1.tar.gz
    8f32f96d653e904d20f9f910c6d9dd91
    https://pypi.python.org/packages/source/h/h5py)

message ("Installing ${h5py_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${h5py_NAME}
    DEPENDS             ${python_NAME} ${hdf5_NAME} ${numpy_NAME} ${cython_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${h5py_URL}
    URL_MD5             ${h5py_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py build 
        --hdf5=${BUILDEM_DIR}
    BUILD_IN_SOURCE     1
    TEST_COMMAND        ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py test
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
)

set_target_properties(${h5py_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT h5py_NAME)
