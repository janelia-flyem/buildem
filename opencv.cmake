#
# Install opencv library from source
#

if (NOT opencv_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8.6)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)
include (PatchSupport)

include (zlib)
include (openexr)
include (libtiff)
include (libjpeg)
include (libpng)

external_source (opencv
    2.4.5
    opencv-2.4.5.tar.gz
    8eac87462c7bec8b89021b723207c623 
    http://downloads.sourceforge.net/project/opencvlibrary/opencv-unix/2.4.5/
    )

set (opencv_LIBS     ${BUILDEM_LIB_DIR}/libopencv_ml.so ${BUILDEM_LIB_DIR}/libopencv_core.so)

message ("Installing ${opencv_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${opencv_NAME}
    DEPENDS                 ${zlib_NAME} ${libjpeg_NAME} ${libpng_NAME} ${libtiff_NAME} ${openexr_NAME}
    PREFIX                  ${BUILDEM_DIR}
    URL                     ${opencv_URL}
    URL_MD5                 ${opencv_MD5}
    UPDATE_COMMAND          ""
    PATCH_COMMAND           ""
    CONFIGURE_COMMAND       ${BUILDEM_ENV_STRING} ${CMAKE_COMMAND} ${opencv_SRC_DIR} 
        -DCMAKE_INSTALL_PREFIX=${BUILDEM_DIR}
        -DCMAKE_PREFIX_PATH=${BUILDEM_DIR}
        BUILD_COMMAND           ${BUILDEM_ENV_STRING} $(MAKE)
#    TEST_COMMAND        ${BUILDEM_ENV_STRING} make check
    INSTALL_COMMAND         ${BUILDEM_ENV_STRING} make install
)

set_target_properties(${opencv_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT opencv_NAME)
