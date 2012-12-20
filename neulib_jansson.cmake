#
# Install libneurolabi from source
#

if (NOT libneurolabi_NAME)

  include(${BUILDEM_REPO_DIR}/neulib_com.cmake)

  SET(config_args --enable-shared --disable-fftw --disable-fftwf --disable-z --disable-xml --disable-png LIB_SUFFIX=_jansson) 
  SET(depends_args libjansson)
  INSTALL_NEULIB(libneurolabi_jansson "${config_args}" "${depends_args}")

endif (NOT libneurolabi_NAME)
