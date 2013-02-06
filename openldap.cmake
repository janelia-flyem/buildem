#
# Install openldap from source
#

if (NOT openldap_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport) 

include (openssl) 

external_source (openldap
    2.4.33
    openldap-2.4.33.tgz
    5adae44897647c15ce5abbff313bc85a
    ftp://ftp.openldap.org/pub/OpenLDAP/openldap-release)

message ("Installing ${openldap_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${openldap_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${openldap_URL}
    URL_MD5             ${openldap_MD5}
    UPDATE_COMMAND      ""
    CONFIGURE_COMMAND   ${BUILDEM_ENV_STRING} ./configure 
        --prefix=${BUILDEM_DIR} 
        --enable-shared
        --disable-backends
        --disable-slapd
        LDFLAGS=${BUILDEM_LDFLAGS}
        CPPFLAGS=-I${BUILDEM_DIR}/include
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} make depend
    BUILD_IN_SOURCE     1
    TEST_COMMAND        ${BUILDEM_ENV_STRING} make 
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} make install
)

set_target_properties(${openldap_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT openldap_NAME)