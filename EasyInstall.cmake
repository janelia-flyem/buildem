# Macro support for python easy_install modules.

if (NOT easy_install)


if (NOT FLYEM_BUILD_DIR)
    message (FATAL_ERROR "ERROR: FlyEM build directory (for all downloads & builds) should be specified via -DFLYEM_BUILD_DIR=<path> on cmake command line.")
endif ()

macro (easy_install PKG_NAME)

    include (python)
    include (setuptools)

    if (NOT python-${PKG_NAME})

        set (python-${PKG_NAME} TRUE)
        add_custom_target (${PKG_NAME} ALL 
            DEPENDS ${python_NAME} ${setuptools_NAME}
            COMMAND ${FLYEM_ENV_STRING}  easy_install ${PKG_NAME}
            COMMENT "Installing ${PKG_NAME} via easy_install")

    endif ()

endmacro (easy_install)


endif (NOT easy_install)

