#
# Install nose from source
#

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (BuildSupport)

include (python)
include (setuptools)

if (NOT python-nose)

set (python-nose TRUE)
add_custom_target (nose ALL 
    DEPENDS ${APP_DEPENDENCIES}
    COMMAND ${FLYEM_ENV_STRING}  easy_install nose
    COMMENT "Installing nose via easy_install")

endif (NOT python-nose)