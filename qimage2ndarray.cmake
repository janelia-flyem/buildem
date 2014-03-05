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

# The 1.3 tarball from PyPi seems malformed: 
#  it doesn't have an /include directory!
# Instead, we pull directly from github.
external_git_repo (qimage2ndarray
    release-1.3
    https://github.com/hmeine/qimage2ndarray)

message ("Installing ${qimage2ndarray_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")

ExternalProject_Add(${qimage2ndarray_NAME}
    DEPENDS             ${numpy_NAME} ${pyqt4_NAME}
    PREFIX              ${BUILDEM_DIR}
    GIT_REPOSITORY      ${qimage2ndarray_URL}
    GIT_TAG             ${qimage2ndarray_TAG}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    LIST_SEPARATOR      ^^
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} ${qimage2ndarray_SRC_DIR}/setup.py build
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} ${PYTHON_EXE} ${qimage2ndarray_SRC_DIR}/setup.py install --prefix=${PYTHON_PREFIX}
    BUILD_IN_SOURCE     1
)

set_target_properties(${qimage2ndarray_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT qimage2ndarray_NAME)
