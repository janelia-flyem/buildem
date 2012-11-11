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

message ("Installing ${qimage2ndarray_NAME} into FlyEM build area: ${FLYEM_BUILD_DIR} ...")

ExternalProject_Add(${qimage2ndarray_NAME}
    DEPENDS             ${numpy_NAME} ${pyqt4_NAME}
    PREFIX              ${FLYEM_BUILD_DIR}
    URL                 ${qimage2ndarray_URL}
    URL_MD5             ${qimage2ndarray_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    LIST_SEPARATOR      ^^
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${FLYEM_ENV_STRING} ${PYTHON_EXE} ${qimage2ndarray_SRC_DIR}/setup.py build
    INSTALL_COMMAND     ${FLYEM_ENV_STRING} ${PYTHON_EXE} ${qimage2ndarray_SRC_DIR}/setup.py install --prefix=${PYTHON_PREFIX}
    BUILD_IN_SOURCE     1
)

endif (NOT qimage2ndarray_NAME)
