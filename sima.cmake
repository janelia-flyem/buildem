#
# For use in the analysis of time-series imaging data arising from fluorescence microscopy.
#

if (NOT sima_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

include (python)
include (numpy)
include (scipy)
include (matplotlib)
include (scikit-image)
include (shapely)
include (h5py)
include (opencv)


external_source (sima
    0.3.1
    sima-0.3.1.tar.gz
    5910ea2c8c1bbcd7deb001ce64a5a9f4
    http://pypi.python.org/packages/source/s/sima/)


# Download and install sima
message ("Installing ${sima_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")

ExternalProject_Add(${sima_NAME}
    DEPENDS             ${python_NAME} ${numpy_NAME} ${scipy_NAME} ${matplotlib_NAME} ${scikit-image_NAME} ${shapely_NAME} ${h5py_NAME} ${opencv_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${sima_URL}
    URL_MD5             ${sima_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ${BUILDEM_ENV_STRING} ${PATCH_EXE}
                        # Turns off test that is known failure on Mac.
                        ${sima_SRC_DIR}/sima/extract.py ${PATCH_DIR}/sima-extract.py.patch
                        ${sima_SRC_DIR}/sima/misc/__init__.py ${PATCH_DIR}/sima-misc-__init__.py.patch
                        ${sima_SRC_DIR}/sima/normcut.py ${PATCH_DIR}/sima-normcut.py.patch
                        ${sima_SRC_DIR}/sima/segment.py ${PATCH_DIR}/sima-segment.py.patch
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py build
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
)

set_target_properties(${sima_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT sima_NAME)
