#
# Install qt4 libraries from source
#

if (NOT qt4_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)
#include (PatchSupport)

include(zlib)
include(libpng)
include(libjpeg)
include(libtiff)
include(freetype2)

external_source (qt4
    4.8.3
    qt-everywhere-opensource-src-4.8.3.tar.gz
    a663b6c875f8d7caa8ac9c30e4a4ec3b
    http://download.qt-project.org/official_releases/qt/4.8/4.8.3)

message ("Installing ${qt4_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")

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
    DEPENDS             ${freetype2_NAME} ${zlib_NAME} ${libpng_NAME} ${libjpeg_NAME} ${libtiff_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${qt4_URL}
    URL_MD5             ${qt4_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ${BUILDEM_ENV_STRING} echo "yes" | ${qt4_SRC_DIR}/configure # pipe "yes" to stdin to accept the license.
        --prefix=${BUILDEM_DIR}
        -opensource
        -arch x86_64
        -optimized-qmake
        #-no-framework # Intentionally omitted.
                       # On Mac, Qt is built as a "framework" by default.  It would be nice if we could build it as a non-framework,
                       # since other cross-platform packages (e.g. qimage2ndarray) usually assume a non-framework directory tree. 
                       # Unfortunately, we must build as a framework.
                       # Normally when OSX finds two versions of the same .dylib on the system, it loads only one of them and ignores the other.
                       # However, OSX doesn't seem to recognize that two dylibs with the SAME NAME shouldn't be loaded simultaneously if one of them is part of a framework and the other isn't.
                       # This means that if the user already has a QT framework installation on his system somewhere, then installing a non-framework build on his system will lead to weirdness.
                       # If we just build QT as a framework, then OSX knows not to load both sets of dylibs. 
        -nomake examples 
        -nomake demos 
        -nomake docs
        -nomake translations 
        -no-declarative # caused a build issue on Linux. easier to just disable for now.
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
        -no-accessibility # accessibility causes PyQt build issues on Ubuntu and Mavericks, but PySide can't build without it.
        -release 
        -shared
        -fontconfig
        -system-zlib
        -system-libpng
        -system-libjpeg
        -system-libtiff
        -I${BUILDEM_DIR}/include
        -L${BUILDEM_DIR}/lib
        ${EXTRA_QT4_CONFIG_FLAGS}
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} $(MAKE)
    TEST_COMMAND        ${BUILDEM_ENV_STRING} $(MAKE) check
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} $(MAKE) install
)

set_target_properties(${qt4_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT qt4_NAME)

