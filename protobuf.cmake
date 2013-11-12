#
# Install protobuf from source
#

if (NOT protobuf_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)
include (python)

external_source (protobuf
    2.5.0
    protobuf-2.5.0.tar.gz
    b751f772bdeb2812a2a8e7202bf1dae8
    https://protobuf.googlecode.com/files)

message ("Installing ${protobuf_NAME} into build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${protobuf_NAME}
    PREFIX            ${BUILDEM_DIR}
    URL               ${protobuf_URL}
    URL_MD5           ${protobuf_MD5}
    UPDATE_COMMAND    ""
    PATCH_COMMAND     ""
    CONFIGURE_COMMAND   ${BUILDEM_ENV_STRING} ./configure 
        --prefix=${BUILDEM_DIR} 
        --enable-shared
        --enable-static
        LDFLAGS=${BUILDEM_LDFLAGS}
        CPPFLAGS=-I${BUILDEM_DIR}/include
    BUILD_COMMAND     ${BUILDEM_ENV_STRING} make
    BUILD_IN_SOURCE   1
    TEST_COMMAND      ${BUILDEM_ENV_STRING} make check
    INSTALL_COMMAND   ${BUILDEM_ENV_STRING} make install
)

##
## Add custom steps for the protobuf python bindings (build, test, install)
##

ExternalProject_Add_Step(${protobuf_NAME} python-build
    COMMENT "Building protobuf python bindings."
    COMMAND ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py build
    WORKING_DIRECTORY ${protobuf_SRC_DIR}/python
    DEPENDEES build
)

ExternalProject_Add_Step(${protobuf_NAME} python-test
    COMMENT "Testing protobuf python bindings."
    COMMAND ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py test
    WORKING_DIRECTORY ${protobuf_SRC_DIR}/python
    DEPENDEES python-build
)

ExternalProject_Add_Step(${protobuf_NAME} python-install
    COMMENT "Installing protobuf python bindings."
    COMMAND ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
    WORKING_DIRECTORY ${protobuf_SRC_DIR}/python
    DEPENDEES python-test
    DEPENDERS install
)

set_target_properties(${protobuf_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT protobuf_NAME)
