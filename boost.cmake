#
# Install boost libraries from source
#

if (NOT boost_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)

include (python)

external_source (boost
    1_51_0
    boost_1_51_0.tar.gz
    http://downloads.sourceforge.net/project/boost/boost/1.51.0)

message ("Installing ${boost_NAME} into FlyEM build area: ${FLYEM_BUILD_DIR} ...")
ExternalProject_Add(${boost_NAME}
    DEPENDS ${python_NAME}
    PREFIX ${FLYEM_BUILD_DIR}
    URL ${boost_URL}
    UPDATE_COMMAND ""
    PATCH_COMMAND ""
    CONFIGURE_COMMAND ./bootstrap.sh --with-python=${PYTHON_EXE} --prefix=${FLYEM_BUILD_DIR}
    BUILD_COMMAND ./b2 install
    BUILD_IN_SOURCE 1
    INSTALL_COMMAND ""
)

endif (NOT boost_NAME)
