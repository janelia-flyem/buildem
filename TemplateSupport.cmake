# Set templating variables if not already set.
#
# Sets the following variable:
#   TEMPLATE_DIR   Directory with templates for any FlyEM supported packages
#   TEMPLATE_EXE   Executable that creates templated files given a list of parameters

if (NOT TEMPLATE_DIR)

if (NOT BUILDEM_DIR)
    message (FATAL_ERROR "ERROR: FlyEM build directory (for all downloads & builds) should be specified via -DBUILDEM_DIR=<path> on cmake command line.")
endif ()

set (TEMPLATE_DIR ${BUILDEM_REPO_DIR}/templates)
set (TEMPLATE_EXE ${BUILDEM_REPO_DIR}/templates/do_template.py)

endif (NOT TEMPLATE_DIR)

