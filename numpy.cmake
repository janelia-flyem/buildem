#
# Install numpy from source
#

if (NOT numpy_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)
include (FortranSupport)
include (EasyInstall)

include (python)
include (nose)
include (atlas)

external_source (numpy
    1.6.2
    numpy-1.6.2.tar.gz
    95ed6c9dcc94af1fc1642ea2a33c1bba
    http://downloads.sourceforge.net/project/numpy/NumPy/1.6.2)

# Select FORTRAN ABI
if (Fortran_COMPILER_NAME STREQUAL "gfortran")
    set (fortran_abi "gnu95")
elseif (Fortran_COMPILER_NAME STREQUAL "g77")
    set (fortran_abi "gnu")
else ()
    message (FATAL_ERROR "Unable to set FORTRAN ABI for numpy.  Does not support ${Fortran_COMPILER_NAME}!")
endif ()

set (ENV{ATLAS} ${BUILDEM_DIR}/lib/libtatlas.so:${BUILDEM_DIR}/lib/libsatlas.so)

# Download and install numpy
message ("Installing ${numpy_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${numpy_NAME}
    DEPENDS             ${python_NAME} ${nose_NAME} ${atlas_NAME} 
    PREFIX              ${BUILDEM_DIR}
    URL                 ${numpy_URL}
    URL_MD5             ${numpy_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py build --fcompiler=${fortran_abi}
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
)

set_target_properties(${numpy_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT numpy_NAME)
