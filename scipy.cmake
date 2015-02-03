#
# Install scipy from source
#

if (NOT scipy_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)
include (FortranSupport)

include (python)
include (numpy)
include (nose)
include (blas)

external_source (scipy
    0.14.0
    scipy-0.14.0.tar.gz
    d7c7f4ccf8b07b08d6fe49d5cd51f85d
    https://pypi.python.org/packages/source/s/scipy)

# Select FORTRAN ABI
if (Fortran_COMPILER_NAME STREQUAL "gfortran")
    set (fortran_abi "gnu95")
elseif (Fortran_COMPILER_NAME STREQUAL "g77")
    set (fortran_abi "gnu")
else ()
    message (FATAL_ERROR "Unable to set FORTRAN ABI for scipy.  Does not support ${Fortran_COMPILER_NAME}!")
endif ()

if(NOT WITH_ATLAS)
    set(NUMPY_NO_ATLAS "ATLAS=None")
endif()

# Download and install scipy
message ("Installing ${scipy_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${scipy_NAME}
    DEPENDS             ${python_NAME} ${numpy_NAME} ${nose_NAME} ${blas_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${scipy_URL}
    URL_MD5             ${scipy_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${NUMPY_NO_ATLAS} ${PYTHON_EXE} setup.py build --fcompiler=${fortran_abi}
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
)

set_target_properties(${scipy_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT scipy_NAME)
