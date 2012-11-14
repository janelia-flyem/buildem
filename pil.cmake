# Install PIL (python imaging library) from source
#
# Note: tkinter, freetype2, and littlecms support has not been added.
#       jpeg and zlib support is active.

if (NOT pil_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

include (python)
include (zlib)
include (libjpeg)
include (libpng)

external_source (pil
    1.17
    Imaging-1.1.7.tar.gz
    fc14a54e1ce02a0225be8854bfba478e
    http://effbot.org/downloads)


# Download and install pil
message ("Installing ${pil_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")

ExternalProject_Add(${pil_NAME}
    DEPENDS             ${python_NAME} ${zlib_NAME} ${libjpeg_NAME} ${libpng_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${pil_URL}
    URL_MD5             ${pil_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ""
)

endif (NOT pil_NAME)