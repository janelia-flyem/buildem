#
# Install vtk libraries from source
#

if (NOT vtk_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)
include (PatchSupport)

include (python)
include (qt4)
include (sip)
include (pyqt4)
include (libxml2)
include (libpng)
include (libjpeg)
include (libtiff)
include (zlib)

external_source (vtk
    5.10.1
    vtk-5.10.1.tar.gz
    264b0052e65bd6571a84727113508789
    http://www.vtk.org/files/release/5.10)

message ("Installing ${vtk_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")

# update paths if a new version of vtk is used!
set (vtk_LIBPATH ${BUILDEM_DIR}/lib/vtk-5.10)
include_directories (${BUILDEM_DIR}/include/vtk-5.10)

if (${CMAKE_SYSTEM_NAME} MATCHES "Darwin" AND "${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
    # if we compile on OSX with a non-apple compiler, then we need to remove the apple specific flags "-fpascal-strings"
    SET(VTK_PATCHES ${BUILDEM_ENV_STRING} ${PATCH_EXE} ${vtk_SRC_DIR}/Utilities/ftgl/CMakeLists.txt ${PATCH_DIR}/vtk-gcc-osx-pascal-strings.patch)
endif()

ExternalProject_Add(${vtk_NAME}
    DEPENDS             ${python_NAME} ${qt4_NAME} ${sip_NAME} ${pyqt4_NAME} ${libxml2_NAME} 
                        ${libpng_NAME} ${libjpeg_NAME} ${libtiff_NAME} ${zlib_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${vtk_URL}
    URL_MD5             ${vtk_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ${VTK_PATCHES}
    CONFIGURE_COMMAND   ${BUILDEM_ENV_STRING} ${CMAKE_COMMAND} ${vtk_SRC_DIR}
        -DCMAKE_INSTALL_PREFIX=${BUILDEM_DIR}
        -DBUILD_SHARED_LIBS:BOOL=ON
        # For some reason, this linker search path must be explicitly passed in (on mac, at least).
        # (On Mac, CMake automatically uses -F/bla/bla/bla, but for some of the vtk libraries, we need to use -L/bla/bla)
        -DCMAKE_EXE_LINKER_FLAGS=-L${BUILDEM_LIB_DIR}
        -DCMAKE_MODULE_LINKER_FLAGS=-L${BUILDEM_LIB_DIR}
        -DCMAKE_SHARED_LINKER_FLAGS=-L${BUILDEM_LIB_DIR}
        # These python settings must be manually specified for the mac build (maybe not for linux, but it shouldn't hurt)
        -DVTK_PYTHON_SETUP_ARGS=--prefix=${PYTHON_PREFIX}
        -DPYTHON_INCLUDE_DIR:PATH=${PYTHON_INCLUDE_PATH}
        -DPYTHON_LIBRARY:FILEPATH=${PYTHON_LIBRARY_FILE}
        -DSIP_EXECUTABLE:FILEPATH=${PYTHON_PREFIX}/bin/sip
        -DSIP_INCLUDE_DIR:PATH=${PYTHON_INCLUDE_PATH}
        -DSIP_PYQT_DIR:PATH=${PYTHON_PREFIX}/share/sip/PyQt4
        -DVTK_WRAP_PYTHON:BOOL=ON
        -DVTK_WRAP_PYTHON_SIP:BOOL=ON
        -DVTK_WRAP_TCL:BOOL=OFF
        # ilastik uses QT VTK widgets
        -DVTK_USE_QT:BOOL=ON
        -DVTK_USE_TK:BOOL=OFF
        -DVTK_USE_QVTK_QTOPENGL:BOOL=ON
	-DVTK_USE_TK=OFF
	# NETCDF caused weird errors in vtk's xml
	# libxml2
	-DVTK_USE_SYSTEM_LIBXML2=ON
    -DLIBXML2_INCLUDE_DIR:PATH=${BUILDEM_DIR}/include/libxml2
    -DLIBXML2_LIBRARIES:FILEPATH=${BUILDEM_DIR}/lib/libxml2.${BUILDEM_PLATFORM_DYLIB_EXTENSION}
    # libpng
    -DVTK_USE_SYSTEM_PNG=ON
    -DPNG_PNG_INCLUDE_DIR=${BUILDEM_INCLUDE_DIR} # PNG_PNG looks wrong, but that's what the variable is named.
    -DPNG_LIBRARY=${BUILDEM_LIB_DIR}/libpng.${BUILDEM_PLATFORM_DYLIB_EXTENSION}
    # libjpeg
    -DVTK_USE_SYSTEM_JPEG=ON
    -DJPEG_INCLUDE_DIR=${BUILDEM_INCLUDE_DIR}
    -DJPEG_LIBRARY=${BUILDEM_LIB_DIR}/libjpeg.${BUILDEM_PLATFORM_DYLIB_EXTENSION}
    # libtiff
    -DVTK_USE_SYSTEM_TIFF=ON
    -DTIFF_INCLUDE_DIR=${BUILDEM_INCLUDE_DIR}
    -DTIFF_LIBRARY=${BUILDEM_LIB_DIR}/libtiff.${BUILDEM_PLATFORM_DYLIB_EXTENSION}
    # zlib
    -DVTK_USE_SYSTEM_ZLIB=ON
    -DZLIB_INCLUDE_DIR=${BUILDEM_INCLUDE_DIR}
    -DZLIB_LIBRARY=${BUILDEM_LIB_DIR}/libz.${BUILDEM_PLATFORM_DYLIB_EXTENSION}
    
    
	# We want vtk to be built in parallel if possible.
	# Therefore we use $(MAKE) instead of 'make', which somehow enables sub-make files to use the jobserver correctly.
	# See: http://stackoverflow.com/questions/2942465/cmake-and-parallel-building-with-make-jn
	# And: http://www.cmake.org/pipermail/cmake/2011-April/043720.html
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} $(MAKE)
    #TEST_COMMAND        ${BUILDEM_ENV_STRING} $(MAKE) check
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} $(MAKE) install
)

set_target_properties(${vtk_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT vtk_NAME)
