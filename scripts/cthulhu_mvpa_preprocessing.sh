#!/bin/tcsh -f

set top_dir = /Volumes/netapp/MyersLab/Dave/Cthulhu/data 

foreach subj (1)
set anat_dir = $top_dir/cth${subj}/briks
set epi_dir = $top_dir/cth${subj}/cth${subj}.preproc_mvpa	

3dDeconvolve -input $epi_dir/pb*.tcat+orig.HEAD \
-censor censor file from motion correction \
-polort 5 \
-local_times \
-num_stimts 16 \
-stim_times_IM \
-stim_file 1 $top_dir/cth${subj}/catch_timing_subj${subj}.txt \
-stim_label 1 catch \
-stim_file 2 $top_dir/cth${subj}/sinestep1_timing_subj${subj}.txt \
-stim_label 2 sinestep1 \
-stim_file 3 $top_dir/cth${subj}/sinestep3_timing_subj${subj}.txt \
-stim_label 3 sinestep3 \
-stim_file 4 $top_dir/cth${subj}/sinestep5_timing_subj${subj}.txt \
-stim_label 4 sinestep5 \
-stim_file 5 $top_dir/cth${subj}/sinestep7_timing_subj${subj}.txt \
-stim_label 5 sinestep7 \
-stim_file 6 $top_dir/cth${subj}/vowelstep1_timing_subj${subj}.txt \
-stim_label 6 vowelstep1 \
-stim_file 7 $top_dir/cth${subj}/vowelstep3_timing_subj${subj}.txt \
-stim_label 7 vowelstep3 \
-stim_file 8 $top_dir/cth${subj}/vowelstep5_timing_subj${subj}.txt \
-stim_label 8 vowelstep5 \
-stim_file 9 $top_dir/cth${subj}/vowelstep7_timing_subj${subj}.txt \
-stim_label 9 vowelstep7 \
-stim_file 10 $top_dir/cth${subj}/zfalsealarm_timing_subj${subj}.txt \
-stim_label 10 zfalsealarm \
-stim_file 11 $top_dir/cth${subj}/dfile_rall.1D[] \

-fout -tout -rout -bout -x1D X.xmat.1D -xjpeg X.jpg \
-fitts fitts.$subj \
-errts errts.$subj \
-cbucket all_betas.$subj \
-bucket stats.$subj 
 
3dLSS -verb -nodata -matrix X.xmat.1D -prefix testLSS -save1D  X.LSS.1D
