#!/usr/bin/env python

import os
from ase.io import read, write

# This may take a little while, since OUTCAR may be large for long MD run.
# CONFIGS = read('/path/to/OUTCAR', format='vasp-out', index=':')

################################################################################
# or you can read positions from XDATCAR, which is faster since it only contains
# the coordinates.  You may have to process the XDATCAR beforehand when VASP
# forget to write some lines. Executing the following line on shell prompt.
################################################################################
# for vasp version < 5.4, please execute the following command before the script
# sed -i 's/^\s*$/Direct configuration=/' XDATCAR
################################################################################
CONFIGS = read('example/nve/XDATCAR', format='vasp-xdatcar', index=':')

NSW    = len(CONFIGS)               # The number of ionic steps
NSCF   = 2000                       # Choose last NSCF steps for SCF calculations
NDIGIT = len("{:d}".format(NSCF))   #
PREFIX = 'example/waveprod/run/'    # run directories
DFORM  = "/%%0%dd" % NDIGIT         # run dirctories format
for ii in range(NSCF):              # write POSCARs
    p = CONFIGS[ii - NSCF]
    r = (PREFIX + DFORM) % (ii + 1)
    if not os.path.isdir(r): os.makedirs(r)
    write('{:s}/POSCAR'.format(r), p, vasp5=True, direct=True)
    print("this is :" + str(ii))