#
# Install vigra libraries from source
#

if (NOT vigra_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)
include (PatchSupport)

include (libjpeg)
include (libtiff)
include (libpng)
include (openexr)
include (libfftw)
include (hdf5)
include (python)
include (boost)
include (numpy)

# Use FlyEM-packaged vigra based off 1.8.0 github
#external_source (vigra
#    1.8.0
#    vigra-flyem-1.8.0.tar.gz
#    587d49c4e04dbf63535c970b4e681df7)

external_source (vigra
    1.9.0
    vigra-1.9.0-src.tar.gz
    b6155afe1ea967917d2be16d98a85404
    http://hci.iwr.uni-heidelberg.de/vigra)

# Don't use the released tarball since it needs additional patching that's in git HEAD

#external_source (vigra
#    1.8.0
#    vigra-1.8.0-src.tar.gz
#    15c5544448e529ee60020758ab6be264
#    http://hci.iwr.uni-heidelberg.de/vigra)

#external_source (vigra
#    flyem-1.7.1
#    vigra-flyem-1.7.1.tar.gz
#    7325a6fed78383807fd553fc5ee30190)

set (vigra_PATCH ${BUILDEM_ENV_STRING} ${PATCH_EXE}
    # The vigra 1.9.0 release assumes all mac builds are "Framework" builds.
    # This patch allows us to build vigra against non-Framework builds, too.
    # (The mac build patch has no effect for non-Mac platforms.)
    # NOTE: This issue will be fixed in vigra-HEAD on github soon, so this patch 
    #       won't be necessary soon.  The patch may fail to apply when you upgrade
    #       vigra beyond 1.9.0.
    ${vigra_SRC_DIR}/config/FindVIGRANUMPY_DEPENDENCIES.cmake ${PATCH_DIR}/vigra.patch 
    # Add second patch to fix RandomForest importing from hdf5 (should open in read-only mode)
    ${vigra_SRC_DIR}/include/vigra/random_forest_hdf5_impex.hxx ${PATCH_DIR}/vigra-2.patch )

message ("Installing ${vigra_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${vigra_NAME}
    DEPENDS             ${libjpeg_NAME} ${libtiff_NAME} ${libpng_NAME} ${openexr_NAME} ${libfftw_NAME}
                        ${hdf5_NAME} ${python_NAME} ${boost_NAME} ${numpy_NAME} 
    PREFIX              ${BUILDEM_DIR}
    URL                 ${vigra_URL}
    URL_MD5             ${vigra_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ${vigra_PATCH}       
    LIST_SEPARATOR      ^^
    CONFIGURE_COMMAND   ${BUILDEM_ENV_STRING} ${CMAKE_COMMAND} ${vigra_SRC_DIR} 
        -DCMAKE_INSTALL_PREFIX=${BUILDEM_DIR}
        -DCMAKE_PREFIX_PATH=${BUILDEM_DIR}
        -DCMAKE_EXE_LINKER_FLAGS=${BUILDEM_LDFLAGS}
        -DDEPENDENCY_SEARCH_PREFIX=${BUILDEM_DIR}
        -DBoost_LIBRARY_DIRS=${BUILDEM_DIR}/lib
 #       -DBoost_PYTHON_LIBRARY=${BUILDEM_DIR}/lib/libboost_python-mt.${BUILDEM_PLATFORM_DYLIB_EXTENSION}
 #       -DBoost_PYTHON_LIBRARY_RELEASE=${BUILDEM_DIR}/lib/libboost_python-mt.${BUILDEM_PLATFORM_DYLIB_EXTENSION}
 #       -DBoost_PYTHON_LIBRARY_DEBUG=${BUILDEM_DIR}/lib/libboost_python-mt.${BUILDEM_PLATFORM_DYLIB_EXTENSION}
 #       -DVIGRANUMPY_LIBRARIES=${BUILDEM_DIR}/lib/libpython2.7.${BUILDEM_PLATFORM_DYLIB_EXTENSION}^^${BUILDEM_DIR}/lib/libboost_python.${BUILDEM_PLATFORM_DYLIB_EXTENSION}
        -DJPEG_INCLUDE_DIR=${BUILDEM_DIR}/include
        -DJPEG_LIBRARY=${BUILDEM_DIR}/lib/libjpeg.${BUILDEM_PLATFORM_DYLIB_EXTENSION}
        -DHDF5_CORE_LIBRARY=${BUILDEM_DIR}/lib/libhdf5.${BUILDEM_PLATFORM_DYLIB_EXTENSION}
        -DHDF5_HL_LIBRARY=${BUILDEM_DIR}/lib/libhdf5_hl.${BUILDEM_PLATFORM_DYLIB_EXTENSION}
        -DHDF5_INCLUDE_DIR=${BUILDEM_DIR}/include
        -DFFTW3F_INCLUDE_DIR=
        -DFFTW3F_LIBRARY=
        -DFFTW3_INCLUDE_DIR=${BUILDEM_DIR}/include
        -DFFTW3_LIBRARY=${BUILDEM_DIR}/lib/libfftw3.${BUILDEM_PLATFORM_DYLIB_EXTENSION}
        -DCMAKE_CXX_FLAGS=-pthread
        -DCMAKE_CXX_LINK_FLAGS=-pthread
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} make
    TEST_COMMAND        ${BUILDEM_ENV_STRING} make check
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} make install
)

set_target_properties(${vigra_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT vigra_NAME)

