#
# Install scipy from source
#

if (NOT scipy_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)
include (FortranSupport)
include (EasyInstall)

include (python)
include (atlas)

easy_install (nose)

external_source (scipy
    0.11.0
    scipy-0.11.0.tar.gz
    842c81d35fd63579c41a8ca21a2419b9
    http://downloads.sourceforge.net/project/scipy/scipy/0.11.0/scipy-0.11.0.tar.gz)

# Select FORTRAN ABI
if (Fortran_COMPILER_NAME STREQUAL "gfortran")
    set (fortran_abi "gnu95")
elseif (Fortran_COMPILER_NAME STREQUAL "g77")
    set (fortran_abi "gnu")
else ()
    message (FATAL_ERROR "Unable to set FORTRAN ABI for scipy.  Does not support ${Fortran_COMPILER_NAME}!")
endif ()

set (ENV{ATLAS} ${FLYEM_BUILD_DIR}/lib/libtatlas.so:${FLYEM_BUILD_DIR}/lib/libsatlas.so)

# Download and install scipy
message ("Installing ${scipy_NAME} into FlyEM build area: ${FLYEM_BUILD_DIR} ...")
ExternalProject_Add(${scipy_NAME}
    DEPENDS             ${python_NAME} ${atlas_NAME} python-nose
    PREFIX              ${FLYEM_BUILD_DIR}
    URL                 ${scipy_URL}
    URL_MD5             ${scipy_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${FLYEM_ENV_STRING} ${PYTHON_EXE} setup.py build --fcompiler=${fortran_abi}
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ${FLYEM_ENV_STRING} ${PYTHON_EXE} setup.py install --prefix=${FLYEM_BUILD_DIR}
)

endif (NOT scipy_NAME)