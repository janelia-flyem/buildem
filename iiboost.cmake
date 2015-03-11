#
# Install iiboost libraries from source
#

if (NOT iiboost_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

include (itk)
include (python)
include (numpy)

set(IIBOOST_UPDATE_COMMAND git checkout master && git pull) 

external_git_repo (iiboost
    HEAD
    https://github.com/stuarteberg/iiboost)

message ("Installing ${iiboost_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${iiboost_NAME}
    DEPENDS             ${itk_NAME} ${python_NAME} ${numpy_NAME}
    PREFIX              ${BUILDEM_DIR}
    GIT_REPOSITORY      ${iiboost_URL}
    GIT_TAG             ${iiboost_TAG}
    UPDATE_COMMAND      ${IIBOOST_UPDATE_COMMAND}
    CONFIGURE_COMMAND   ${BUILDEM_ENV_STRING} ${CMAKE_COMMAND}
    	-DCMAKE_BUILD_TYPE=Release
    	-DCMAKE_INSTALL_PREFIX=${BUILDEM_DIR}
        -DCMAKE_PREFIX_PATH=${BUILDEM_DIR}
	-DBUILD_PYTHON_WRAPPER=1
        -DPYTHON_BASE_PATH=${PYTHON_PREFIX}
	-DITK_DIR=${itk_CONFIG_DIR}
    	${iiboost_SRC_DIR}
    	
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} $(MAKE)
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} $(MAKE) install
)

endif (NOT iiboost_NAME)

