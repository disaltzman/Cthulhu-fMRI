#!/bin/tcsh -f

set top_dir = /Volumes/netapp/MyersLab/Dave/Cthulhu/data 

foreach subj (16 17)
set anat_dir = $top_dir/cth${subj}/briks
set epi_dir = $top_dir/cth${subj}/briks	

afni_proc.py -subj_id $subj \
-script proc.cth${subj} \
-out_dir cth${subj}.preproc \
-blocks align tlrc volreg blur mask scale regress \
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
-volreg_tlrc_warp \
-blur_size 4 \
-regress_stim_times \
$top_dir/cth${subj}/catch_timing_subj${subj}.txt \
$top_dir/cth${subj}/sinestep1_timing_subj${subj}.txt \
$top_dir/cth${subj}/sinestep3_timing_subj${subj}.txt \
$top_dir/cth${subj}/sinestep5_timing_subj${subj}.txt \
$top_dir/cth${subj}/sinestep7_timing_subj${subj}.txt \
$top_dir/cth${subj}/vowelstep1_timing_subj${subj}.txt \
$top_dir/cth${subj}/vowelstep3_timing_subj${subj}.txt \
$top_dir/cth${subj}/vowelstep5_timing_subj${subj}.txt \
$top_dir/cth${subj}/vowelstep7_timing_subj${subj}.txt \
-regress_stim_labels \
catch sinestep1 sinestep3 sinestep5 sinestep7 vowelstep1 vowelstep3 vowelstep5 vowelstep7 \
-regress_local_times \
-regress_basis GAM \
-regress_censor_motion 0.3 \
-regress_censor_outliers 0.1 \
-regress_censor_first_trs 2 \
-regress_est_blur_epits \
-regress_est_blur_errts \
-regress_make_cbucket yes \
-execute
end