#
# Install cppunit from source
#

if (NOT cppunit_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

external_source (cppunit
    1.12.1
    cppunit-1.12.1.tar.gz
    bd30e9cf5523cdfc019b94f5e1d7fd19
    http://downloads.sourceforge.net/project/cppunit/cppunit/1.12.1)

message ("Installing ${cppunit_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${cppunit_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${cppunit_URL}
    URL_MD5             ${cppunit_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ${BUILDEM_ENV_STRING} ./configure 
        --prefix ${BUILDEM_DIR}
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} make
    BUILD_IN_SOURCE     1
    TEST_COMMAND        make check
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} make install
)

set_target_properties(${cppunit_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT cppunit_NAME)