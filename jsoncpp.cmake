#
# Install the JsonCpp program into an OS-specific build directory
#

if (NOT jsoncpp_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)
include (PatchSupport)

include (python)

external_source (scons_embeded 
    1.2.0 
    scons-local-1.2.0.tar.gz
    aa92aff8b285ad992c2bf436dae72536
    http://downloads.sourceforge.net/project/scons/scons-local/1.2.0)

external_source (jsoncpp
    0.5.0
    jsoncpp-src-0.5.0.tar.gz
    24482b67c1cb17aac1ed1814288a3a8f
    http://downloads.sourceforge.net/project/jsoncpp/jsoncpp/0.5.0)

# Copy script will take a string pattern and copy all matches into a destination directory.
# Surprisingly, this is hard to do within ExternalProject_Add due to lack of wildcard expansion?
# TODO -- Find some CMake equivalent although initial attempts have been unsuccessful.
set (COPY_SCRIPT ${BUILDEM_REPO_DIR}/scripts/copy.py)

# Download required scons local package
message ("Installing scons-local 1.2.0 needed to build jsoncpp...")
ExternalProject_Add(${scons_embeded_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${scons_embeded_URL}
    URL_MD5             ${scons_embeded_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ""
    INSTALL_COMMAND     ""
)

set_target_properties(${scons_embeded_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

if (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
    set (jsoncpp_PATCH ${BUILDEM_ENV_STRING} ${PATCH_EXE} 
        ${jsoncpp_SRC_DIR}/SConstruct ${PATCH_DIR}/jsoncpp-SConstruct-mac.patch )
else()
    set (jsoncpp_PATCH ${BUILDEM_ENV_STRING} ${PATCH_EXE} 
        ${jsoncpp_SRC_DIR}/SConstruct ${PATCH_DIR}/jsoncpp-SConstruct-linux.patch)
endif()

# Download jsoncpp and build it.
message ("Installing ${jsoncpp_NAME} ...")
ExternalProject_Add(${jsoncpp_NAME}
    PREFIX              ${BUILDEM_DIR}
    DEPENDS             ${scons_embeded_NAME} ${python_NAME}
    URL                 ${jsoncpp_URL}
    URL_MD5             ${jsoncpp_MD5}
    UPDATE_COMMAND      ${BUILDEM_ENV_STRING} ${PYTHON_EXE} 
        ${COPY_SCRIPT} "${scons_SRC_DIR}/*" ${jsoncpp_SRC_DIR}
    PATCH_COMMAND       ${jsoncpp_PATCH}
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} scons.py platform=linux-gcc
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ""
)

set_target_properties(${jsoncpp_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

add_custom_command (TARGET ${jsoncpp_NAME}
                    POST_BUILD
                    COMMAND ${CMAKE_COMMAND} -E copy 
                        ${jsoncpp_SRC_DIR}/libs/linux-gcc-*/libjson_linux-gcc-*_libmt.so 
                        ${BUILDEM_DIR}/lib/libjsoncpp.so
                    COMMAND python ${COPY_SCRIPT} 
                        "${jsoncpp_SRC_DIR}/include/*" 
                        ${BUILDEM_DIR}/include
                    COMMENT "Copied jsoncpp library and include files to ${BUILDEM_DIR}")
set (json_LIB ${BUILDEM_DIR}/lib/libjsoncpp.so)
set (json_INCLUDES ${BUILDEM_DIR}/include)

message ("Including JSON include files from here: ${json_INCLUDES}")

endif (NOT jsoncpp_NAME)