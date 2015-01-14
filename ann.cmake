#
# Install ann from source
#

if (NOT ann_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)
include (PatchSupport)

external_source (ann
    1.1.2
    ann_1.1.2.tar.gz
    7ffaacc7ea79ca39d4958a6378071365
    http://www.cs.umd.edu/~mount/ANN/Files/1.1.2/
    FORCE)

message ("Installing ${ann_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${ann_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${ann_URL}
    URL_MD5             ${ann_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ${BUILDEM_ENV_STRING} cp ${PATCH_DIR}/ann.patch ${ann_SRC_DIR}/CMakeLists.txt
        #${BUILDEM_ENV_STRING} ${PATCH_EXE}
    	#${ann_SRC_DIR}/CMakeLists.txt ${PATCH_DIR}/ann.patch

    CONFIGURE_COMMAND   ${BUILDEM_ENV_STRING} ${CMAKE_COMMAND} ${ann_SRC_DIR} 
        -DBUILD_SHARED_LIBS=ON
        -DCMAKE_INSTALL_PREFIX=${BUILDEM_DIR}
        -DCMAKE_PREFIX_PATH=${BUILDEM_DIR}


    BUILD_COMMAND       ${BUILDEM_ENV_STRING} $(MAKE)
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} $(MAKE) install
    TEST_COMMAND        "" # ${BUILDEM_ENV_STRING} $(MAKE) check
)

set_target_properties(${ann_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT ann_NAME)

