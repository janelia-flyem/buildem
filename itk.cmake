#
# Install itk libraries from source
#

if (NOT itk_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)
#include (PatchSupport)

include (hdf5)
include (libpng)
include (libjpeg)
include (libtiff)
include (zlib)

external_source (itk
    4.6.1
    InsightToolkit-4.6.1.tar.gz
    2c84eae50ab2452cdad32aaadced3c37
    http://superb-dca3.dl.sourceforge.net/project/itk/itk/4.6)

message ("Installing ${itk_NAME} into build area: ${BUILDEM_DIR} ...")

# update paths if a new version of itk is used!
set (itk_LIBPATH ${BUILDEM_DIR}/lib/itk-4.6)
include_directories (${BUILDEM_DIR}/include/itk-4.6)

##
## For now, we do not bother building the python bindings...
##
ExternalProject_Add(${itk_NAME}
    DEPENDS             ${hdf5_NAME} ${libpng_NAME} ${libjpeg_NAME} ${libtiff_NAME} ${zlib_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${itk_URL}
    URL_MD5             ${itk_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ${BUILDEM_ENV_STRING} ${CMAKE_COMMAND} ${itk_SRC_DIR}
        -DCMAKE_INSTALL_PREFIX=${BUILDEM_DIR}
        -DBUILD_SHARED_LIBS:BOOL=ON
        -DCMAKE_CXX_FLAGS=-I${BUILDEM_DIR}/include
        -DCMAKE_C_FLAGS=-I${BUILDEM_DIR}/include
    
    # hdf5
    -DITK_USE_SYSTEM_HDF5=ON
    -DHDF5_C_LIBRARY=${BUILDEM_LIB_DIR}/libhdf5.so.1.8.9
    -DHDF5_DIR=${BUILDEM_DIR}/share/cmake/hdf5
    # libpng
    -DITK_USE_SYSTEM_PNG=ON
    -DPNG_PNG_INCLUDE_DIR=${BUILDEM_INCLUDE_DIR} # PNG_PNG looks wrong, but that's what the variable is named.
    -DPNG_LIBRARY=${BUILDEM_LIB_DIR}/libpng.${BUILDEM_PLATFORM_DYLIB_EXTENSION}
    # libjpeg
    -DITK_USE_SYSTEM_JPEG=ON
    -DJPEG_INCLUDE_DIR=${BUILDEM_INCLUDE_DIR}
    -DJPEG_LIBRARY=${BUILDEM_LIB_DIR}/libjpeg.${BUILDEM_PLATFORM_DYLIB_EXTENSION}
    # libtiff
    -DITK_USE_SYSTEM_TIFF=ON
    -DTIFF_INCLUDE_DIR=${BUILDEM_INCLUDE_DIR}
    -DTIFF_LIBRARY=${BUILDEM_LIB_DIR}/libtiff.${BUILDEM_PLATFORM_DYLIB_EXTENSION}    
    # zlib
    -DITK_USE_SYSTEM_ZLIB=ON
    -DZLIB_INCLUDE_DIR=${BUILDEM_INCLUDE_DIR}
    -DZLIB_LIBRARY=${BUILDEM_LIB_DIR}/libz.${BUILDEM_PLATFORM_DYLIB_EXTENSION}
    
    
	# We want itk to be built in parallel if possible.
	# Therefore we use $(MAKE) instead of 'make', which somehow enables sub-make files to use the jobserver correctly.
	# See: http://stackoverflow.com/questions/2942465/cmake-and-parallel-building-with-make-jn
	# And: http://www.cmake.org/pipermail/cmake/2011-April/043720.html
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} $(MAKE)
    #TEST_COMMAND        ${BUILDEM_ENV_STRING} $(MAKE) check
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} $(MAKE) install
)

set_target_properties(${itk_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT itk_NAME)
