#!/bin/tcsh -f

set top_dir = /Volumes/netapp/MyersLab/Dave/Cthulhu/data 

foreach subj (1)
set anat_dir = $top_dir/cth${subj}/briks
set epi_dir = $top_dir/cth${subj}/briks	

afni_proc.py -subj_id $subj \
-script proc.cth${subj}_mvpa \
-out_dir cth${subj}.preproc_mvpa \
-blocks align volreg mask scale \
-copy_anat ${anat_dir}/cth${subj}_MP_DO \
-dsets \
$epi_dir/cth${subj}_EP1_DO+orig.HEAD \
$epi_dir/cth${subj}_EP2_DO+orig.HEAD \
$epi_dir/cth${subj}_EP3_DO+orig.HEAD \
$epi_dir/cth${subj}_EP4_DO+orig.HEAD \
$epi_dir/cth${subj}_EP5_DO+orig.HEAD \
$epi_dir/cth${subj}_EP6_DO+orig.HEAD \
$epi_dir/cth${subj}_EP7_DO+orig.HEAD \
$epi_dir/cth${subj}_EP8_DO+orig.HEAD \
$epi_dir/cth${subj}_EP9_DO+orig.HEAD \
$epi_dir/cth${subj}_EP10_DO+orig.HEAD \
-volreg_align_to first \
-volreg_align_e2a \
-execute
end