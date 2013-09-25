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
include (TemplateSupport)
include (PatchSupport)

include (python)
include (nose)
include (blas)

external_source (numpy
    1.7.0 # When we upgrade to 1.8, patch step 2 is no longer needed (see below). Remove it.
    numpy-1.7.0.tar.gz
    4fa54e40b6a243416f0248123b6ec332
    http://downloads.sourceforge.net/project/numpy/NumPy/1.7.0)

# Select FORTRAN ABI
if (Fortran_COMPILER_NAME STREQUAL "gfortran")
    set (fortran_abi "gnu95")
elseif (Fortran_COMPILER_NAME STREQUAL "g77")
    set (fortran_abi "gnu")
else ()
    message (FATAL_ERROR "Unable to set FORTRAN ABI for numpy.  Does not support ${Fortran_COMPILER_NAME}!")
endif ()

if(NOT WITH_ATLAS)
    set(NUMPY_NO_ATLAS "ATLAS=None")
endif()

# Download and install numpy
message ("Installing ${numpy_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${numpy_NAME}
    DEPENDS             ${python_NAME} ${nose_NAME} ${blas_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${numpy_URL}
    URL_MD5             ${numpy_MD5}
    UPDATE_COMMAND      ""
    # Two "patch" steps:
    # (1) Create a site.cfg (from a template) to ensure that the correct library search paths are provided.
    #     (On OS X, this is required because the only default path is Frameworks/Python.framework/Versions/2.7/lib)
    # (2) Patch numpy/distutils/system_info.py for a Mac OS X fix (don't let built-in Accelerate library shadow ATLAS).
    #     (This patch will not be needed after we upgrade to 1.8, which is not released at the time of this writing.)
    PATCH_COMMAND       ${BUILDEM_ENV_STRING}
                        ${TEMPLATE_EXE} ${TEMPLATE_DIR}/numpy_site.cfg.template ${numpy_SRC_DIR}/site.cfg ${BUILDEM_DIR}
                        && ${PATCH_EXE} ${numpy_SRC_DIR}/numpy/distutils/system_info.py ${PATCH_DIR}/numpy.patch
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${NUMPY_NO_ATLAS} ${PYTHON_EXE} setup.py build --fcompiler=${fortran_abi}
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
)

set_target_properties(${numpy_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT numpy_NAME)
