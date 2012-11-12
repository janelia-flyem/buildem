#
# Install qt4 libraries from source
#

if (NOT qt4_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)
#include (PatchSupport)

external_source (qt4
    4.8.1
    qt-everywhere-opensource-src-4.8.1.tar.gz
    7960ba8e18ca31f0c6e4895a312f92ff
    http://download.qt.nokia.com/qt/source)

message ("Installing ${qt4_NAME} into FlyEM build area: ${FLYEM_BUILD_DIR} ...")

if (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
    set (EXTRA_QT4_CONFIG_FLAGS 
        -cocoa
        -L/usr/X11/lib
        -I/usr/X11/include )
else()
    set (EXTRA_QT4_CONFIG_FLAGS "")
endif()

#
# This build script builds a SUBSET of QT.
# We intentionally avoid building a lot of non-UI stuff, just to minimize our build time and minimize the odds of build system failures.
# (This builds everything that ilastik needs.)

ExternalProject_Add(${qt4_NAME}
    #DEPENDS             
    PREFIX              ${FLYEM_BUILD_DIR}
    URL                 ${qt4_URL}
    URL_MD5             ${qt4_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ${FLYEM_ENV_STRING} echo "yes" | ${qt4_SRC_DIR}/configure # pipe "yes" to stdin to accept the license.
        --prefix=${FLYEM_BUILD_DIR}
        -opensource
        -arch x86_64
        -optimized-qmake 
        -nomake examples 
        -nomake demos 
        -nomake docs
        -nomake translations 
        -no-multimedia 
        -no-webkit # Apparently clang segfaults when building webkit...
        -no-audio-backend 
        -no-phonon 
        -no-phonon-backend 
        -no-sql-sqlite 
        -no-sql-sqlite2 
        -no-sql-psql 
        -no-sql-db2 
        -no-sql-ibase 
        -no-sql-mysql 
        -no-sql-oci 
        -no-sql-odbc
        -no-sql-sqlite_symbian 
        -no-sql-tds 
        -no-pch 
        -no-dbus
        -no-cups
        -no-nis
        -qt-libpng 
        -release 
        -shared
        -no-accessibility 
        ${EXTRA_QT4_CONFIG_FLAGS}
    BUILD_COMMAND       ${FLYEM_ENV_STRING} make
    TEST_COMMAND        ${FLYEM_ENV_STRING} make check
    INSTALL_COMMAND     ${FLYEM_ENV_STRING} make install
)

endif (NOT qt4_NAME)

