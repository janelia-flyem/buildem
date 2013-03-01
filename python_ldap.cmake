#
# Install python_ldap library from source
#

if (NOT python_ldap_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)
include (TemplateSupport)

include (python)
include (openldap)

external_source (python_ldap
    2.4.10
    python-ldap-2.4.10.tar.gz
    a15827ca13c90e9101e5e9405c1d83be
    http://pypi.python.org/packages/source/p/python-ldap)

message ("Installing ${python_ldap_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${python_ldap_NAME}
    DEPENDS             ${python_NAME} ${openldap_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${python_ldap_URL}
    URL_MD5             ${python_ldap_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py build
    BUILD_IN_SOURCE     1
    TEST_COMMAND        ""
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
)

set_target_properties(${python_ldap_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT python_ldap_NAME)
