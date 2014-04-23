If you are having trouble building OpenBLAS out of the box, you may need to specify your CPU Architecture.
Common architecture options include SandyBridge and Haswell. They can be specified by using the TARGET flag.
For example, TARGET=SANDYBRIDGE will build for the SandyBridge architecture. Similarly, TARGET=HASWELL will
target the Haswell (or Crystalwell) architecture(s). More information can be found on the OpenBLAS GitHub
webpage located ( https://github.com/xianyi/OpenBLAS/ ) here. To do this simply modify the BUILD_COMMAND to
include this flag ____after____ the call to $(MAKE) as it must be an argument to make. It is recommend the
same be done for the INSTALL_COMMAND as well.