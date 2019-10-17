#!/bin/csh -f

set top_dir = /Volumes/netapp/Myerslab/Dave/Cthulhu/data 

#acf approach
3dClustSim -mask $top_dir/group/group_mask+tlrc \
 -acf 0.694544846 2.843920385 7.518301538 -pthr 0.05 .025 .01 .001 \
 -iter 10000 -quiet > $top_dir/group/fhwmx/clustsim_acf_errts.txt
