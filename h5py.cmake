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
    2.1.3
    h5py-2.1.3.tar.gz
    afd3c14f763339e186dd9cd24eb2eb74
    http://h5py.googlecode.com/files)

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
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py build 
        --hdf5=${BUILDEM_DIR}
    BUILD_IN_SOURCE     1
    TEST_COMMAND        ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py test
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
)

set_target_properties(${h5py_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT h5py_NAME)
