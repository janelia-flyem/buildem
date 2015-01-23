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
include (libtiff)
include (libjpeg)
include (libpng)
include (openexr)
include (ffmpeg)
include (qt4)
include (python)
include (numpy)
include (sphinx)

external_source (opencv
    2.4.8.3
    2.4.8.3.tar.gz
    a64feba01bd74c36ddf04d560d9cafd3
    https://github.com/Itseez/opencv/archive/
    )

set (opencv_LIBS     ${BUILDEM_LIB_DIR}/libopencv_ml.so ${BUILDEM_LIB_DIR}/libopencv_core.so)

message ("Installing ${opencv_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${opencv_NAME}
    DEPENDS                 ${zlib_NAME} ${libjpeg_NAME} ${libpng_NAME} ${libtiff_NAME} ${openexr_NAME} ${ffmpeg_NAME} ${qt4_NAME} ${python_NAME} ${numpy_NAME} ${sphinx_NAME}
    PREFIX                  ${BUILDEM_DIR}
    URL                     ${opencv_URL}
    URL_MD5                 ${opencv_MD5}
    UPDATE_COMMAND          ""
    PATCH_COMMAND           ""
    CONFIGURE_COMMAND       ${BUILDEM_ENV_STRING} ${CMAKE_COMMAND} ${opencv_SRC_DIR} -DPYTHON_EXECUTABLE=${PYTHON_EXE} -DPYTHON_LIBRARY=${PYTHON_LIBRARY_FILE} -DPYTHON_INCLUDE_DIR=${PYTHON_INCLUDE_PATH} -DPYTHON_PACKAGES_PATH=${PYTHON_PREFIX}/lib/python2.7/site-packages
        -DCMAKE_INSTALL_PREFIX=${BUILDEM_DIR}
        -DCMAKE_PREFIX_PATH=${BUILDEM_DIR}
        "-DCMAKE_CXX_FLAGS=${BUILDEM_ADDITIONAL_CXX_FLAGS} -liconv -L${BUILDEM_LIB_DIR} -lswresample"
    BUILD_COMMAND           ${BUILDEM_ENV_STRING} $(MAKE)
#    TEST_COMMAND            ${BUILDEM_ENV_STRING} $(MAKE) check
    INSTALL_COMMAND         ${BUILDEM_ENV_STRING} $(MAKE) install
)

set_target_properties(${opencv_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT opencv_NAME)
