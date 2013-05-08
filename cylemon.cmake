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
    http://github.com/ilastik/cylemon)

if (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
    set (cylemon_SPECIAL_SETUP "--no-openmp")
endif()

message ("Installing ${cylemon_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${cylemon_NAME}
    DEPENDS             ${lemon_NAME} ${python_NAME} ${cython_NAME} ${numpy_NAME}
    PREFIX              ${BUILDEM_DIR}
    GIT_REPOSITORY      ${cylemon_URL}
    UPDATE_COMMAND      ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} 
    	setup.py --no-extra-includes ${cylemon_SPECIAL_SETUP} build build_ext -I${BUILDEM_INCLUDE_DIR} -L${BUILDEM_LIB_DIR}
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
)

set_target_properties(${cylemon_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT cylemon_NAME)
