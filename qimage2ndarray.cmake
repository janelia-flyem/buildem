#
# Install qimage2ndarray libraries from source
#

if (NOT qimage2ndarray_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)
#include (PatchSupport)

include (numpy)
include (pyqt4)

external_source (qimage2ndarray
    1.0
    qimage2ndarray-1.0.tar.gz
    1f59c1c42395709a58c43ed74a866375    
    http://kogs-www.informatik.uni-hamburg.de/~meine/software/qimage2ndarray/dist)

if (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
    # This patch does no harm on non-mac builds, but there's no need to apply it on linux.
    set (qimage2ndarray_PATCH ${BUILDEM_ENV_STRING} ${PATCH_EXE}
        ${qimage2ndarray_SRC_DIR}/setup.py ${PATCH_DIR}/qimage2ndarray.patch )
else()
    set (qimage2ndarray_PATCH "")
endif()

message ("Installing ${qimage2ndarray_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")

ExternalProject_Add(${qimage2ndarray_NAME}
    DEPENDS             ${numpy_NAME} ${pyqt4_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${qimage2ndarray_URL}
    URL_MD5             ${qimage2ndarray_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ${qimage2ndarray_PATCH}
    LIST_SEPARATOR      ^^
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} ${qimage2ndarray_SRC_DIR}/setup.py build
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} ${PYTHON_EXE} ${qimage2ndarray_SRC_DIR}/setup.py install --prefix=${PYTHON_PREFIX}
    BUILD_IN_SOURCE     1
)

set_target_properties(${qimage2ndarray_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT qimage2ndarray_NAME)
