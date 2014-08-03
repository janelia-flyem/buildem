# Builds julia.

if (NOT julia_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

# Need to use v0.3.0-rc1 as there is a build error in the lower versions where julia is not properly installed in ${BUILDEM_DIR}/bin. Attempts to install it there or links to the actual executable resulted in mismatches between runtime and linking libraries. Using this version resolves these problems.
external_git_repo(julia
	v0.3.0-rc1 # 3737cc28bc3116b21fb2502cdccbbeef5fbcd1b3
	https://github.com/JuliaLang/julia)

message ("Installing ${julia_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${julia_NAME}
    DEPENDS             ""
    PREFIX              ${BUILDEM_DIR}
    GIT_REPOSITORY	${julia_URL}
    GIT_TAG             ${julia_TAG}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    # Julia builds its own dependencies. Trying to get it to share was not straightforward. It builds its own OpenBLAS. So, can suffer from the same problems that OpenBLAS does. Add OPENBLAS_TARGET_ARCH=xxx (where xxx is an architecture) to the BUILD_COMMAND to optimize and/or avoid particular build errors. See README_openblas.txt for details.
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} $(MAKE) 
    BUILD_IN_SOURCE     1
    TEST_COMMAND        ${BUILDEM_ENV_STRING} $(MAKE) testall 
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} $(MAKE) install prefix=${BUILDEM_DIR}
)

set_target_properties(${julia_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT julia_NAME)