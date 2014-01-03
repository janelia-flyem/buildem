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

message ("Installing ${gtest_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${gtest_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${gtest_URL}
    URL_MD5             ${gtest_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ${BUILDEM_ENV_STRING} ${CMAKE_COMMAND} ${gtest_SRC_DIR} 
        -DCMAKE_INSTALL_PREFIX=${BUILDEM_DIR}
        -DCMAKE_PREFIX_PATH=${BUILDEM_DIR}
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} $(MAKE)
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     "" 
)

ExternalProject_add_step(${gtest_NAME} install_includes
    DEPENDEES   build
    COMMAND     ${CMAKE_COMMAND} -E copy_directory 
        ${gtest_SRC_DIR}/include/gtest ${BUILDEM_DIR}/include/gtest
    COMMENT     "Placed gtest include files in ${BUILDEM_DIR}include"
)

ExternalProject_add_step(${gtest_NAME} install_library
    DEPENDEES   install_includes
    COMMAND     ${CMAKE_COMMAND} -E copy ${gtest_SRC_DIR}/libgtest.a ${BUILDEM_DIR}/lib
    COMMENT     "Placed libgtest.a in ${BUILDEM_DIR}/lib"
)

ExternalProject_add_step(${gtest_NAME} install_library2
    DEPENDEES   install_includes
    COMMAND     ${CMAKE_COMMAND} -E copy ${gtest_SRC_DIR}/libgtest_main.a ${BUILDEM_DIR}/lib
    COMMENT     "Placed libgtest_main.a in ${BUILDEM_DIR}/lib"
)

set (gtest_STATIC_LIBRARIES ${BUILDEM_LIB_DIR}/libgtest.a ${BUILDEM_LIB_DIR}/libgtest_main.a)

set_target_properties(${gtest_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT gtest_NAME)