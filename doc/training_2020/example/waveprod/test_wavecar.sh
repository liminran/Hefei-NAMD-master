#!/bin/bash
cd run
ls -l {0001..2000}/WAVECAR | awk '{print $5}' | uniq -c

