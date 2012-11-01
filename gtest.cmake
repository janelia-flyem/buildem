#
# Install gtest from source
#

if (NOT gtest_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

external_source (gtest
    1.6.0
    gtest-1.6.0.zip
    4577b49f2973c90bf9ba69aa8166b786
    http://googletest.googlecode.com/files)

message ("Installing ${gtest_NAME} into FlyEM build area: ${FLYEM_BUILD_DIR} ...")
ExternalProject_Add(${gtest_NAME}
    PREFIX              ${FLYEM_BUILD_DIR}
    URL                 ${gtest_URL}
    URL_MD5             ${gtest_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ${FLYEM_ENV_STRING} ${CMAKE_COMMAND} ${gtest_SRC_DIR} 
        -DCMAKE_INSTALL_PREFIX=${FLYEM_BUILD_DIR}
        -DCMAKE_PREFIX_PATH=${FLYEM_BUILD_DIR}
    BUILD_COMMAND       ${FLYEM_ENV_STRING} make
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     "" 
)

ExternalProject_add_step(${gtest_NAME} install_includes
    DEPENDEES   build
    COMMAND     ${CMAKE_COMMAND} -E copy_directory 
        ${gtest_SRC_DIR}/include/gtest ${FLYEM_BUILD_DIR}/include/gtest
    COMMENT     "Placed gtest include files in ${FLYEM_BUILD_DIR}include"
)

ExternalProject_add_step(${gtest_NAME} install_library
    DEPENDEES   install_includes
    COMMAND     ${CMAKE_COMMAND} -E copy ${gtest_SRC_DIR}/libgtest.a ${FLYEM_BUILD_DIR}/lib
    COMMENT     "Placed libgtest.a in ${FLYEM_BUILD_DIR}/lib"
)

endif (NOT gtest_NAME)