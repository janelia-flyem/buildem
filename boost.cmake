#
# Install boost libraries from source
#

if (NOT boost_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (SetBuildDir)
include (CacheDownload)

# Make sure we've done "include (python)" to download/build python before boost
if (NOT python_NAME)
    message (FATAL_ERROR "Before including boost, you must include python!")
endif ()

set (boost_RELEASE  1_51_0)
set (boost_NAME     "boost_${boost_RELEASE}")
cache_init (boost ${boost_NAME}.tar.gz http://downloads.sourceforge.net/project/boost/boost/1.51.0)

message ("Installing ${boost_NAME} into FlyEM build area: ${FLYEM_BUILD_DIR} ...")
set_src_dir (boost ${boost_NAME})

ExternalProject_Add(${boost_NAME}
    PREFIX ${FLYEM_BUILD_DIR}
    URL ${boost_URL}
    UPDATE_COMMAND ""
    PATCH_COMMAND ""
    CONFIGURE_COMMAND ./bootstrap.sh --with-python=${PYTHON_EXE} --prefix=${FLYEM_BUILD_DIR}
    BUILD_COMMAND ./b2 install
    BUILD_IN_SOURCE 1
    INSTALL_COMMAND ""
)
cache_download (boost)

endif (NOT boost_NAME)
