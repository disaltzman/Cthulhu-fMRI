#!/bin/csh -f
set top_dir = /Volumes/netapp/MyersLab/Dave/Cthulhu/data 

# Note: By this point, proc py has created several different masks. We want to use the "full_mask" file, which is the 
# mask created from the smoothed functional data. DO NOT use the "mask_anat" file, which is based on the anatomical
# scans and may give you inappropriate brain coverage.

3dMean -prefix $top_dir/group/group_mean $top_dir/cth*/cth*.preproc/full_mask.*
3dcalc -a $top_dir/group/group_mean+tlrc -expr 'equals(a,1)' -prefix $top_dir/group/group_mask
