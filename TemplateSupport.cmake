# Set templating variables if not already set.
#
# Sets the following variable:
#   TEMPLATE_DIR   Directory with templates for any FlyEM supported packages
#   TEMPLATE_EXE   Executable that creates templated files given a list of parameters

if (NOT TEMPLATE_DIR)

if (NOT FLYEM_BUILD_DIR)
    message (FATAL_ERROR "ERROR: FlyEM build directory (for all downloads & builds) should be specified via -DFLYEM_BUILD_DIR=<path> on cmake command line.")
endif ()

set (TEMPLATE_DIR ${FLYEM_BUILD_REPO_DIR}/templates)
set (TEMPLATE_EXE ${FLYEM_BUILD_REPO_DIR}/templates/do_template.py)

endif (NOT TEMPLATE_DIR)

