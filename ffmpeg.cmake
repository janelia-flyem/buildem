#
# Install ffmpeg from source.
# Provides support for audio and video.
#

if (NOT ffmpeg_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

external_source (ffmpeg
    2.4.3
    ffmpeg-2.4.3.tar.bz2
    8da635baff57d7ab704b1daca5a99b47
    http://www.ffmpeg.org/releases/
    FORCE)

message ("Installing ${ffmpeg_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${ffmpeg_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${ffmpeg_URL}
    URL_MD5             ${ffmpeg_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ${BUILDEM_ENV_STRING} ${ffmpeg_SRC_DIR}/configure
        --prefix=${BUILDEM_DIR}
        --disable-yasm
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} $(MAKE)
    BUILD_IN_SOURCE     1
    TEST_COMMAND        ${BUILDEM_ENV_STRING} $(MAKE) check
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} $(MAKE) install
)

set_target_properties(${ffmpeg_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT ffmpeg_NAME)
