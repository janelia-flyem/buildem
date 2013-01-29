#
# Install the scons package
#

if (NOT scons_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

include (python)

external_source (scons 
    2.2.0 
    scons-2.2.0.tar.gz
    f737f474a02d08156c821bd2d4d4b632
    http://downloads.sourceforge.net/project/scons/scons/2.2.0)


message ("Installing scons...")
ExternalProject_Add(${scons_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${scons_URL}
    URL_MD5             ${scons_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ""
    INSTALL_COMMAND     ""
)

set_target_properties(${scons_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT scons_NAME)