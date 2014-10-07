#
# Install pyqt4 libraries from source
#

if (NOT pyqt4_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)
include (PatchSupport)

include (python)
include (qt4)
include (sip)

message ("Installing ${pyqt4_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")

if (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
    external_source (pyqt4
        4.10.3
        PyQt-mac-gpl-4.10.3.tar.gz
        4dfb646512dd479cfa7518605eda1f32    
        http://iweb.dl.sourceforge.net/project/pyqt/PyQt4/PyQt-4.10.3)

    set (EXTRA_PYQT4_CONFIG_FLAGS
        --use-arch=x86_64)
elseif (${WIN32})
    external_source (pyqt4
        4.10.3
        PyQt-win-gpl-4.10.3.zip
        14f09b0ed9f04daf8f19f680d3b90e8b
        http://sourceforge.net/projects/pyqt/files/PyQt4/PyQt-4.10.3)
elseif (${UNIX})
    external_source (pyqt4
        4.10.3
        PyQt-x11-gpl-4.10.3.tar.gz
        8b13d2ab64e4d2fd0037b81b7e78c15c    
        http://iweb.dl.sourceforge.net/project/pyqt/PyQt4/PyQt-4.10.3)
else ()
    message (FATAL_ERROR "ERROR: Cannot detect valid system in pyqt4 cmake file")
endif()

ExternalProject_Add(${pyqt4_NAME}
    DEPENDS             ${python_NAME} ${sip_NAME} ${qt4_NAME}             
    PREFIX              ${BUILDEM_DIR}
    URL                 ${pyqt4_URL}
    URL_MD5             ${pyqt4_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ${BUILDEM_ENV_STRING} PYTHONPATH=${BUILDEM_PYTHONPATH} ${PYTHON_EXE} ${pyqt4_SRC_DIR}/configure.py 
        --confirm-license
        --verbose
        -q "${BUILDEM_DIR}/bin/qmake"
        ${EXTRA_PYQT4_CONFIG_FLAGS}
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} $(MAKE)
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} $(MAKE) install
    BUILD_IN_SOURCE 1
)

set_target_properties(${pyqt4_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT pyqt4_NAME)

