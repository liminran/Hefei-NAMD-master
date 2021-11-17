#!/bin/bash
for ii in {0001..2000}
do
cd run
cd ${ii}
ln -sf ../../INCAR
ln -sf ../../KPOINTS
ln -sf ../../POTCAR
cd ../../
done
