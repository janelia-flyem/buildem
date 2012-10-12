#
# Install nose from source
#

if (NOT nose)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (BuildSupport)

include (python)
include (setuptools)

add_custom_target (nose ALL 
    DEPENDS ${python_NAME} ${setuptools_NAME}
    COMMAND ${FLYEM_ENV_STRING}  easy_install nose
    COMMENT "Installing nose via easy_install")

endif (NOT nose)