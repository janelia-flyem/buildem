#
# Install atlas from source
#

#
# Note: The ATLAS build process uses timing tests to determine the best implementation to build for your system.
#       These timing tests cannot function properly if CPU throttling is enabled on your machine.
#       If the ATLAS build script detects CPU throttling on your machine, it will fail with an error like this:
#         
#         It appears you have cpu throttling enabled, which makes timings
#         unreliable and an ATLAS install nonsensical. Aborting.
#
#       If you get this error, you must temporarily disable CPU throttling (or "Turbo Boost") while ATLAS is built.
#       You can do this by changing the BIOS to disable SpeedStep / Turbo Boost, which prevents the OS from
#       changing CPU frequencies on the fly.
#
#       On Fedora, this can be done via the cpupower command:
#
#         $ cpupower frequency-info # Check current settings...
#         $ sudo cpupower frequency-set -g performance
#
#         See cpupower help frequency-set for more info.
#
#       cpupower is contained in kernel-tools package for Fedora 17+ and in cpufrequtils for Fedora 16.

if (NOT atlas_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)
include (FortranSupport)

external_source (lapack
    3.4.2
    lapack-3.4.2.tgz
    61bf1a8a4469d4bdb7604f5897179478
    http://www.netlib.org/lapack)

message ("Downloading ${lapack_NAME} tarball into FlyEM build area: ${BUILDEM_DIR} ...")

ExternalProject_Add(${lapack_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${lapack_URL}
    URL_MD5             ${lapack_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   "" 
    BUILD_COMMAND       ""
    INSTALL_COMMAND     ""
)

set_target_properties(${lapack_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

external_source (atlas
    3.10.0
    atlas3.10.0.tar.bz2
    2030aa079b8d040b93de7018eae90e2b
    http://downloads.sourceforge.net/project/math-atlas/Stable/3.10.0)

message ("Installing ${atlas_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${atlas_NAME}
    DEPENDS             ${lapack_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${atlas_URL}
    URL_MD5             ${atlas_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ${BUILDEM_ENV_STRING} ${atlas_SRC_DIR}/configure
        -C if ${CMAKE_Fortran_COMPILER}
        -F if ${CMAKE_Fortran_FLAGS_RELEASE}
        -b 64 
        --shared 
        --prefix=${BUILDEM_DIR} 
        --with-netlib-lapack-tarfile=${lapack_FILE}
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} $(MAKE)
    TEST_COMMAND        ${BUILDEM_ENV_STRING} $(MAKE) check
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} $(MAKE) install
)

MESSAGE( STATUS " ${atlas_SRC_DIR}-build/lib:         " ${atlas_SRC_DIR}-build/lib ${CMAKE_BINARY_DIR} )

# Want to also provide shared libraries for everything. So, we make them before we install.
# They will automatically be installed as all of lib's contents will get copied over.
ExternalProject_Add_Step(${atlas_NAME} shared
    COMMAND             ${BUILDEM_ENV_STRING} $(MAKE) shared_all #cshared ptshared #cptshared
    DEPENDERS           install
    WORKING_DIRECTORY   ${atlas_SRC_DIR}-build/lib
)


set (ENV{ATLAS} ${BUILDEM_DIR}/lib:${BUILDEM_DIR}/lib/libtatlas.so:${BUILDEM_DIR}/lib/libsatlas.so)

set_target_properties(${atlas_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT atlas_NAME)
