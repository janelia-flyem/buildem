#
# Install libneurolabi from source
#

if (NOT libneurolabi_NAME)

  include(${BUILDEM_REPO_DIR}/neulib_com.cmake)

  SET(config_args --enable-shared --disable-fftw --disable-fftwf --disable-z --disable-xml --disable-png --disable-jansson LIB_SUFFIX=_min) 
  INSTALL_NEULIB(libneurolabi_min "${config_args}")

endif (NOT libneurolabi_NAME)
