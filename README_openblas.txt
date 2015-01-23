If you are having trouble building OpenBLAS out of the box, you may need to specify your CPU Architecture.
Common architecture options include SandyBridge and Haswell. Even if your build worked correctly, it may
not be optimal. The default architecture, if not specified, is Nehalem, which is probably not the ideal
choice unless using an older computer.

To specify the architecture simply use the TARGET flag. For example, TARGET=SANDYBRIDGE will build for
the SandyBridge architecture. Similarly, TARGET=HASWELL will target the Haswell (or Crystalwell)
architecture(s). To do this simply modify the BUILD_COMMAND to include this flag ____after____ the call
to $(MAKE) as it must be an argument to make. It is recommend the same be done for the INSTALL_COMMAND
as well.

More information can be found on the OpenBLAS GitHub webpage ( https://github.com/xianyi/OpenBLAS/ ). A list
of architectures supported can be found here ( https://github.com/xianyi/OpenBLAS/blob/develop/TargetList.txt ).
Note that at the time of writing this READNME, the list has not been updated in about a year; so, it does not
list HASWELL even though it is supported by the version we are using.