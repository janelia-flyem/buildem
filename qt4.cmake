#
# Install qt4 libraries from source
#

if (NOT qt4_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)
include (PatchSupport)  # Using PATCH_EXE so this include should be here.

include(zlib)
include(libpng)
include(libjpeg)
include(libtiff)
include(freetype2)

external_git_repo(qt4
    4.8 #682ed9df439481e1f8e8651c4aa06f1b455a2080
    https://github.com/qtproject/qt)

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
    GIT_REPOSITORY  ${qt4_URL}
    GIT_TAG         4.8
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ${BUILDEM_ENV_STRING} ${PATCH_EXE}
            # This patch fixes ilastik crashes on OSX due to an ill-shaped ellipse
            ${qt4_SRC_DIR}/src/gui/painting/qpaintengine_mac.cpp ${PATCH_DIR}/qt4-osx-draw-ellipse.patch
            # This patch fixes removes Xarch_x86_64 flags from the Qt4 configure file. These flags are not appropriate for Mavericks and cause Qt4 to fail building.
            ${qt4_SRC_DIR}/configure ${PATCH_DIR}/qt4-osx-mavericks-configure.patch
            # This patch fixes removes Xarch_x86_64 flags from the Qt4 gui.pro file. These flags are not appropriate for Mavericks and cause Qt4 to fail building.
            ${qt4_SRC_DIR}/src/gui/gui.pro ${PATCH_DIR}/qt4-osx-mavericks-gui-pro.patch
    CONFIGURE_COMMAND   ${BUILDEM_ENV_STRING} env CXXFLAGS=${BUILDEM_ADDITIONAL_CXX_FLAGS} echo "yes" | ${qt4_SRC_DIR}/configure # pipe "yes" to stdin to accept the license.
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
        -no-accessibility # Must include accessibility because PySide tries to build wrappers for it. 
        -release 
        -shared
        -fontconfig
        -system-zlib
        -system-libpng
        -system-libjpeg
        -system-libtiff
        -I${BUILDEM_DIR}/include -I${BUILDEM_DIR}/include/freetype2
        -L${BUILDEM_DIR}/lib
        ${EXTRA_QT4_CONFIG_FLAGS}
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} $(MAKE)
    TEST_COMMAND        ${BUILDEM_ENV_STRING} $(MAKE) check
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} $(MAKE) install
)

if (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
    ExternalProject_Add_Step(${qt4_NAME} ${qt4_NAME}-create-symlinks
       COMMAND bash ${PATCH_DIR}/qt4-create-symlinks.sh ${BUILDEM_DIR}
       DEPENDEES install
    )
endif()

set_target_properties(${qt4_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT qt4_NAME)
