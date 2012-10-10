# Set patching variables if not already set.
#
# Sets the following variable:
#   PATCH_DIR   Directory with patches for any FlyEM supported packages
#   PATCH_EXE   Executable that applies patches to any number of files:  file1 patch1 [file2 patch2 ...]

if (NOT PATCH_DIR)

if (NOT FLYEM_BUILD_DIR)
    message (FATAL_ERROR "ERROR: FlyEM build directory (for all downloads & builds) should be specified via -DFLYEM_BUILD_DIR=<path> on cmake command line.")
endif ()

set (PATCH_DIR ${FLYEM_BUILD_REPO_DIR}/patches)
set (PATCH_EXE ${FLYEM_BUILD_REPO_DIR}/patches/do_patch.py)

endif (NOT PATCH_DIR)

