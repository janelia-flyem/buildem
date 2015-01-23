# Builds SQLite, which Python uses to implement the standard library module
# sqlite3 ( https://docs.python.org/2/library/sqlite3.html ).

if (NOT sqlite_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)
include (PatchSupport)


external_source (sqlite
    3.8.5
    sqlite-autoconf-3080500.tar.gz
    0544ef6d7afd8ca797935ccc2685a9ed
    http://www.sqlite.org/2014/)

message ("Installing ${sqlite_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${sqlite_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${sqlite_URL}
    URL_MD5             ${sqlite_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ${BUILDEM_ENV_STRING} ${sqlite_SRC_DIR}/configure
        --prefix=${BUILDEM_DIR}
        LDFLAGS=${BUILDEM_LDFLAGS}
        CPPFLAGS=-I${BUILDEM_DIR}/include
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} $(MAKE)
    BUILD_IN_SOURCE     1
    TEST_COMMAND        ""
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} $(MAKE) install
)

set_target_properties(${sqlite_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT sqlite_NAME)