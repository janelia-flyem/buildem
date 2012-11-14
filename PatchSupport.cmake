# Set patching variables if not already set.
#
# Sets the following variable:
#   PATCH_DIR   Directory with patches for any FlyEM supported packages
#   PATCH_EXE   Executable that applies patches to any number of files:  file1 patch1 [file2 patch2 ...]

if (NOT PATCH_DIR)

if (NOT BUILDEM_DIR)
    message (FATAL_ERROR "ERROR: FlyEM build directory (for all downloads & builds) should be specified via -DBUILDEM_DIR=<path> on cmake command line.")
endif ()

set (PATCH_DIR ${BUILDEM_REPO_DIR}/patches)
set (PATCH_EXE ${BUILDEM_REPO_DIR}/patches/do_patch.py)

endif (NOT PATCH_DIR)

