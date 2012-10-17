#
# Install scikit-image library from source
#

if (NOT scikit-image_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

include (python)
include (cython)
include (numpy)
include (scipy)

external_source (scikit-image
    0.7.2
    scikit-image-0.7.2.tar.gz
    80eb9862fa09c7e06eda6e2a9fc4042f
    http://pypi.python.org/packages/source/s/scikit-image)

message ("Installing ${scikit-image_NAME} into FlyEM build area: ${FLYEM_BUILD_DIR} ...")
ExternalProject_Add(${scikit-image_NAME}
    DEPENDS             ${python_NAME} ${cython_NAME} ${numpy_NAME} ${scipy_NAME} 
    PREFIX              ${FLYEM_BUILD_DIR}
    URL                 ${scikit-image_URL}
    URL_MD5             ${scikit-image_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${FLYEM_ENV_STRING} ${PYTHON_EXE} setup.py install
    BUILD_IN_SOURCE     1
    TEST_COMMAND        ""
    INSTALL_COMMAND     ""
)

endif (NOT scikit-image_NAME)
