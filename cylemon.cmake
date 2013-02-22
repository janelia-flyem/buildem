#
# Install cylemon library from source
#

if (NOT cylemon_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

include (python)
include (numpy)
include (lemon)
include (cython)
#include (openmp)

external_git_repo (cylemon
    HEAD
    http://github.com/cstraehl/cylemon)

message ("Installing ${cylemon_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${cylemon_NAME}
    DEPENDS             ${lemon_NAME} ${python_NAME} ${cython_NAME} ${numpy_NAME}
    PREFIX              ${BUILDEM_DIR}
    GIT_REPOSITORY      ${cylemon_URL}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ${BUILDEM_ENV_STRING} ${PATCH_EXE}
    	${cylemon_SRC_DIR}/setup.py ${PATCH_DIR}/cylemon.patch
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py build 
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
)

set_target_properties(${cylemon_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT cylemon_NAME)
