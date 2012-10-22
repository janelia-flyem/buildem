#!/usr/bin/env python
#
# Copyright 2012 HHMI.  All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
#     * Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above
# copyright notice, this list of conditions and the following disclaimer
# in the documentation and/or other materials provided with the
# distribution.
#     * Neither the name of HHMI nor the names of its
# contributors may be used to endorse or promote products derived from
# this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# Author: katzw@janelia.hhmi.org (Bill Katz)
#  Written as part of the FlyEM Project at Janelia Farm Research Center.
"""
Copyright (c) 2012 HHMI. All rights reserved.

See HELP_USAGE below.
"""

import sys
import urllib

from optparse import OptionParser

HELP_USAGE = """
%prog will try to open a given url and returns 0 if successful, 1 otherwise.

    %prog <url>

"""

def main():
    parser = OptionParser(usage=HELP_USAGE)
    (options, args) = parser.parse_args()

    if len(args) != 1:
        print("\nERROR!! Must specify only a single url to ping\n\n")
        parser.print_help()
        sys.exit(2)

    try:
        urllib.urlopen(args[0])
    except IOError:
        sys.exit(1)

    
if __name__ == '__main__':
    main()

