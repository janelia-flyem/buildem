#
# Install gtest from source
#

if (NOT gtest_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)

external_source (gtest
    1.6.0
    gtest-1.6.0.zip
    http://googletest.googlecode.com/files)

message ("Installing ${gtest_NAME} into FlyEM build area: ${FLYEM_BUILD_DIR} ...")
ExternalProject_Add(${gtest_NAME}
    PREFIX ${FLYEM_BUILD_DIR}
    URL ${gtest_URL}
    UPDATE_COMMAND    ""
    PATCH_COMMAND     ""
    CONFIGURE_COMMAND ${CMAKE_COMMAND} ${gtest_SRC_DIR} 
        -DCMAKE_INSTALL_PREFIX:string=${FLYEM_BUILD_DIR}
        -DCMAKE_FIND_ROOT_PATH=${FLYEM_BUILD_DIR}
    BUILD_COMMAND     make
    BUILD_IN_SOURCE   1
    INSTALL_COMMAND   "" 
)

ExternalProject_add_step(${gtest_NAME} install_includes
    DEPENDEES   build
    COMMAND     ${CMAKE_COMMAND} -E make_directory ${FLYEM_BUILD_DIR}/include
    COMMAND     ${CMAKE_COMMAND} -E copy_directory 
        ${gtest_SRC_DIR}/include/gtest ${FLYEM_BUILD_DIR}/include/gtest
    COMMENT     "Placed gtest include files in ${FLYEM_BUILD_DIR}include"
)

ExternalProject_add_step(${gtest_NAME} install_library
    DEPENDEES   install_includes
    COMMAND     ${CMAKE_COMMAND} -E make_directory ${FLYEM_BUILD_DIR}/lib
    COMMAND     ${CMAKE_COMMAND} -E copy ${gtest_SRC_DIR}/libgtest.a ${FLYEM_BUILD_DIR}/lib
    COMMENT     "Placed libgtest.a in ${FLYEM_BUILD_DIR}/lib"
)

endif (NOT gtest_NAME)