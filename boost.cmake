#
# Install boost libraries from source
#

if (NOT boost_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (BuildSupport)
include (ExternalSource)

include (python)
include (zlib)

include_directories (${FLYEM_BUILD_DIR}/include)

external_source (boost
    1_51_0
    boost_1_51_0.tar.gz
    6a1f32d902203ac70fbec78af95b3cf8
    http://downloads.sourceforge.net/project/boost/boost/1.51.0)

if (EXISTS ${FLYEM_BUILD_DIR}/lib/libboost_python.so.1.51.0)
    add_custom_target (${boost_NAME}
        DEPENDS ${python_NAME} ${zlib_NAME})
else ()
    message ("Installing ${boost_NAME} into FlyEM build area: ${FLYEM_BUILD_DIR} ...")
    ExternalProject_Add(${boost_NAME}
        DEPENDS             ${python_NAME} ${zlib_NAME}
        PREFIX              ${FLYEM_BUILD_DIR}
        URL                 ${boost_URL}
        URL_MD5             ${boost_MD5}
        UPDATE_COMMAND      ""
        PATCH_COMMAND       ""
        CONFIGURE_COMMAND   ${FLYEM_ENV_STRING} ./bootstrap.sh 
            --with-python=${PYTHON_EXE} 
            --prefix=${FLYEM_BUILD_DIR}
            LDFLAGS=-L${FLYEM_BUILD_DIR}/lib,-Wl,-rpath=${FLYEM_BUILD_DIR}/lib
            CPPFLAGS=-I${FLYEM_BUILD_DIR}/include
        BUILD_COMMAND       ${FLYEM_ENV_STRING} ./b2 
            -sNO_BZIP2=1 
            -sZLIB_INCLUDE=${FLYEM_BUILD_DIR}/include 
            -sZLIB_SOURCE=${zlib_SRC_DIR} install
        BUILD_IN_SOURCE     1
        INSTALL_COMMAND     ""
    )
endif ()

endif (NOT boost_NAME)
