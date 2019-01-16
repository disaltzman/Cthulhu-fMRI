#!/bin/tcsh -f

set top_dir = /Volumes/netapp/MyersLab/Dave/Cthulhu/data 

foreach subj (2 3 6 8 9 10 11 12 14 15 16 17 18 19 20 21 22 24 25)
set anat_dir = $top_dir/cth${subj}/briks
set epi_dir = $top_dir/cth${subj}/briks	

afni_proc.py -subj_id $subj \
-script $top_dir/cth${subj}/proc.cth${subj}_mvpa \
-out_dir $top_dir/cth${subj}/cth${subj}.preproc_mvpa \
-blocks align volreg mask scale regress \
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
-regress_stim_times \
$top_dir/cth${subj}/IM_timing_subj${subj}.txt \
-regress_stim_types IM \
-regress_local_times \
-regress_basis GAM \
-regress_opts_3dD -allzero_OK -jobs 3 -GOFORIT 15 \
-regress_censor_motion 0.3 \
-regress_censor_outliers 0.1 \
-regress_est_blur_epits \
-regress_est_blur_errts \
-regress_make_cbucket yes \
-execute 

#cd $top_dir/cth${subj}/cth${subj}.preproc_mvpa

#3dLSS -verb -nodata -matrix X.xmat.1D -prefix cth${subj}_LSS -save1D  X.LSS.1D

end
