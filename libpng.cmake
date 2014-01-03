#
# Install libpng from source
#

if (NOT libpng_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

# Note: 'libpng-1.5 removed direct access to png_struct and png_info'.

external_source (libpng
    1.5.13
    libpng-1.5.13.tar.gz
    9c5a584d4eb5fe40d0f1bc2090112c65
    http://downloads.sourceforge.net/project/libpng/libpng15/1.5.13)

#external_source (libpng
#   1.4.12
#    libpng-1.4.12.tar.gz
#    72e4447061af5b781cd4057c4d449d80
#    http://downloads.sourceforge.net/project/libpng/libpng14/1.4.12)



message ("Installing ${libpng_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${libpng_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${libpng_URL}
    URL_MD5             ${libpng_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ${BUILDEM_ENV_STRING} ${CMAKE_COMMAND} ${libpng_SRC_DIR} 
        -DCMAKE_INSTALL_PREFIX=${BUILDEM_DIR}
        -DCMAKE_PREFIX_PATH=${BUILDEM_DIR}
        BUILD_COMMAND       ${BUILDEM_ENV_STRING} $(MAKE)
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} $(MAKE) install
)

set_target_properties(${libpng_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT libpng_NAME)
