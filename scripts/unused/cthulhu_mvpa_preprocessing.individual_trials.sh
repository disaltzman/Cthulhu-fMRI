#!/bin/tcsh -f

set top_dir = /Volumes/netapp/MyersLab/Dave/Cthulhu/data 

foreach subj (24)
set anat_dir = $top_dir/cth${subj}/briks
set epi_dir = $top_dir/cth${subj}/briks	

# afni_proc.py -subj_id $subj \
# -script $top_dir/cth${subj}/proc.cth${subj}_mvpa \
# -out_dir $top_dir/cth${subj}/cth${subj}.preproc_mvpa \
# -blocks align volreg mask scale \
# -copy_anat ${anat_dir}/cth${subj}_MP_DO \
# -dsets \
# $epi_dir/cth${subj}_EP1_DO+orig.HEAD \
# $epi_dir/cth${subj}_EP2_DO+orig.HEAD \
# $epi_dir/cth${subj}_EP3_DO+orig.HEAD \
# $epi_dir/cth${subj}_EP4_DO+orig.HEAD \
# $epi_dir/cth${subj}_EP5_DO+orig.HEAD \
# $epi_dir/cth${subj}_EP6_DO+orig.HEAD \
# $epi_dir/cth${subj}_EP7_DO+orig.HEAD \
# $epi_dir/cth${subj}_EP8_DO+orig.HEAD \
# $epi_dir/cth${subj}_EP9_DO+orig.HEAD \
# $epi_dir/cth${subj}_EP10_DO+orig.HEAD \
# -volreg_align_to first \
# -volreg_align_e2a \
# -execute 

3dDeconvolve -input $top_dir/cth${subj}/cth${subj}.preproc_mvpa/pb02.${subj}.*.BRIK \
-local_times \
-num_stimts 10 \
-stim_times_IM 1 $top_dir/cth${subj}/catch_timing_subj${subj}.txt 'GAM' -stim_label 1 catch \
-stim_times_IM 2 $top_dir/cth${subj}/sinestep1_timing_subj${subj}.txt 'GAM' -stim_label 2 sinestep1 \
-stim_times_IM 3 $top_dir/cth${subj}/sinestep3_timing_subj${subj}.txt 'GAM' -stim_label 3 sinestep3 \
-stim_times_IM 4 $top_dir/cth${subj}/sinestep5_timing_subj${subj}.txt 'GAM' -stim_label 4 sinestep5 \
-stim_times_IM 5 $top_dir/cth${subj}/sinestep7_timing_subj${subj}.txt 'GAM' -stim_label 5 sinestep7 \
-stim_times_IM 6 $top_dir/cth${subj}/vowelstep1_timing_subj${subj}.txt 'GAM' -stim_label 6 vowelstep1 \
-stim_times_IM 7 $top_dir/cth${subj}/vowelstep3_timing_subj${subj}.txt 'GAM' -stim_label 7 vowelstep3 \
-stim_times_IM 8 $top_dir/cth${subj}/vowelstep5_timing_subj${subj}.txt 'GAM' -stim_label 8 vowelstep5 \
-stim_times_IM 9 $top_dir/cth${subj}/vowelstep7_timing_subj${subj}.txt 'GAM' -stim_label 9 vowelstep7 \
-stim_times_IM 10 $top_dir/cth${subj}/zfalsealarm_timing_subj${subj}.txt 'GAM' -stim_label 10 zfalsealarm \
-allzero_OK \
-jobs 3 \
-GOFORIT 20 \
-bucket MVPA.BLOCK 


#cd $top_dir/cth${subj}/cth${subj}.preproc_mvpa
#3dLSS -verb -nodata -matrix X.xmat.1D -prefix cth${subj}_LSS -save1D  X.LSS.1D

end
