#
# Install pyqt4 libraries from source
#

if (NOT pyqt4_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)
#include (PatchSupport)

include (python)
include (qt4)
include (sip)

message ("Installing ${pyqt4_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")

if (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
    external_source (pyqt4
        4.9.5
        PyQt-mac-gpl-4.9.5.tar.gz
        855f9d9e10821c0f79a7dc956a9a14ec    
        http://iweb.dl.sourceforge.net/project/pyqt/PyQt4/PyQt-4.9.5)

    set (EXTRA_PYQT4_CONFIG_FLAGS
        --use-arch=x86_64)
elseif (${WIN32})
    external_source (pyqt4
        4.9.5
        PyQt-win-gpl-4.9.5.zip
        0ebc1b0c27b49c22492a3145f5f1ee47
        http://sourceforge.net/projects/pyqt/files/PyQt4/PyQt-4.9.5)
elseif (${UNIX})
    external_source (pyqt4
        4.9.5
        PyQt-x11-gpl-4.9.5.tar.gz
        e4cdd6619c63655f7510efb4df8462fb    
        http://iweb.dl.sourceforge.net/project/pyqt/PyQt4/PyQt-4.9.5)
else ()
    message (FATAL_ERROR "ERROR: Cannot detect valid system in pyqt4 cmake file")
endif()

ExternalProject_Add(${pyqt4_NAME}
    DEPENDS             ${python_NAME} ${sip_NAME} ${qt4_NAME}             
    PREFIX              ${BUILDEM_DIR}
    URL                 ${pyqt4_URL}
    URL_MD5             ${pyqt4_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ${BUILDEM_ENV_STRING} ${PATCH_EXE}
        ${pyqt4_SRC_DIR}/configure.py ${PATCH_DIR}/pyqt4.patch # For some reason, the configure script wants to build pyqt phonon support even if qt was built without it.  This patch simply comments out phonon support.
    CONFIGURE_COMMAND   ${BUILDEM_ENV_STRING} ${PYTHON_EXE} ${pyqt4_SRC_DIR}/configure.py 
        --confirm-license
        -q "${BUILDEM_DIR}/bin/qmake"
        ${EXTRA_PYQT4_CONFIG_FLAGS}
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} make
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} make install
    BUILD_IN_SOURCE 1
)

set_target_properties(${pyqt4_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT pyqt4_NAME)

