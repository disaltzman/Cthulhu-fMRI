#!/bin/tcsh -f

set top_dir = /Volumes/netapp/MyersLab/Dave/Cthulhu/data 

foreach subj (16)
	set anat_dir = $top_dir/cth${subj}/briks
	set epi_dir = $top_dir/cth${subj}/briks	

	# run proc.py to do minimal preprocessing of data
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

	# concatenate runs into one file for 3dLSS
	cd $top_dir/cth${subj}/cth${subj}.preproc_MVPA
	mkdir readyforMVPA_Mumford
	mkdir conditionXrun_betas
	3dTcat -prefix all_runs_LSS $top_dir/cth${subj}/cth${subj}.preproc_MVPA/pb02.${subj}.r*.BRIK

	# get matrices for each predictor
	3dDeconvolve -input $top_dir/cth${subj}/cth${subj}.preproc_mvpa/pb02.${subj}.*.BRIK \
	-local_times \
	-num_stimts 10 \
	-stim_times 1 $top_dir/cth${subj}/catch_timing_subj${subj}.txt 'GAM' -stim_label 1 catch \
	-stim_times_IM 2 $top_dir/cth${subj}/sinestep1_timing_subj${subj}.txt 'GAM' -stim_label 2 sinestep1 \
	-stim_times 3 $top_dir/cth${subj}/sinestep3_timing_subj${subj}.txt 'GAM' -stim_label 3 sinestep3 \
	-stim_times 4 $top_dir/cth${subj}/sinestep5_timing_subj${subj}.txt 'GAM' -stim_label 4 sinestep5 \
	-stim_times 5 $top_dir/cth${subj}/sinestep7_timing_subj${subj}.txt 'GAM' -stim_label 5 sinestep7 \
	-stim_times 6 $top_dir/cth${subj}/vowelstep1_timing_subj${subj}.txt 'GAM' -stim_label 6 vowelstep1 \
	-stim_times 7 $top_dir/cth${subj}/vowelstep3_timing_subj${subj}.txt 'GAM' -stim_label 7 vowelstep3 \
	-stim_times 8 $top_dir/cth${subj}/vowelstep5_timing_subj${subj}.txt 'GAM' -stim_label 8 vowelstep5 \
	-stim_times 9 $top_dir/cth${subj}/vowelstep7_timing_subj${subj}.txt 'GAM' -stim_label 9 vowelstep7 \
	-stim_times 10 $top_dir/cth${subj}/zfalsealarm_timing_subj${subj}.txt 'GAM' -stim_label 10 zfalsealarm \
	-allzero_OK \
	-jobs 3 \
	-GOFORIT 20 \
	-x1D sinestep1.mat.1D \
	-x1D_stop

	3dDeconvolve -input $top_dir/cth${subj}/cth${subj}.preproc_mvpa/pb02.${subj}.*.BRIK \
	-local_times \
	-num_stimts 10 \
	-stim_times 1 $top_dir/cth${subj}/catch_timing_subj${subj}.txt 'GAM' -stim_label 1 catch \
	-stim_times 2 $top_dir/cth${subj}/sinestep1_timing_subj${subj}.txt 'GAM' -stim_label 2 sinestep1 \
	-stim_times_IM 3 $top_dir/cth${subj}/sinestep3_timing_subj${subj}.txt 'GAM' -stim_label 3 sinestep3 \
	-stim_times 4 $top_dir/cth${subj}/sinestep5_timing_subj${subj}.txt 'GAM' -stim_label 4 sinestep5 \
	-stim_times 5 $top_dir/cth${subj}/sinestep7_timing_subj${subj}.txt 'GAM' -stim_label 5 sinestep7 \
	-stim_times 6 $top_dir/cth${subj}/vowelstep1_timing_subj${subj}.txt 'GAM' -stim_label 6 vowelstep1 \
	-stim_times 7 $top_dir/cth${subj}/vowelstep3_timing_subj${subj}.txt 'GAM' -stim_label 7 vowelstep3 \
	-stim_times 8 $top_dir/cth${subj}/vowelstep5_timing_subj${subj}.txt 'GAM' -stim_label 8 vowelstep5 \
	-stim_times 9 $top_dir/cth${subj}/vowelstep7_timing_subj${subj}.txt 'GAM' -stim_label 9 vowelstep7 \
	-stim_times 10 $top_dir/cth${subj}/zfalsealarm_timing_subj${subj}.txt 'GAM' -stim_label 10 zfalsealarm \
	-allzero_OK \
	-jobs 3 \
	-GOFORIT 20 \
	-x1D sinestep3.mat.1D \
	-x1D_stop

	3dDeconvolve -input $top_dir/cth${subj}/cth${subj}.preproc_mvpa/pb02.${subj}.*.BRIK \
	-local_times \
	-num_stimts 10 \
	-stim_times 1 $top_dir/cth${subj}/catch_timing_subj${subj}.txt 'GAM' -stim_label 1 catch \
	-stim_times 2 $top_dir/cth${subj}/sinestep1_timing_subj${subj}.txt 'GAM' -stim_label 2 sinestep1 \
	-stim_times 3 $top_dir/cth${subj}/sinestep3_timing_subj${subj}.txt 'GAM' -stim_label 3 sinestep3 \
	-stim_times_IM 4 $top_dir/cth${subj}/sinestep5_timing_subj${subj}.txt 'GAM' -stim_label 4 sinestep5 \
	-stim_times 5 $top_dir/cth${subj}/sinestep7_timing_subj${subj}.txt 'GAM' -stim_label 5 sinestep7 \
	-stim_times 6 $top_dir/cth${subj}/vowelstep1_timing_subj${subj}.txt 'GAM' -stim_label 6 vowelstep1 \
	-stim_times 7 $top_dir/cth${subj}/vowelstep3_timing_subj${subj}.txt 'GAM' -stim_label 7 vowelstep3 \
	-stim_times 8 $top_dir/cth${subj}/vowelstep5_timing_subj${subj}.txt 'GAM' -stim_label 8 vowelstep5 \
	-stim_times 9 $top_dir/cth${subj}/vowelstep7_timing_subj${subj}.txt 'GAM' -stim_label 9 vowelstep7 \
	-stim_times 10 $top_dir/cth${subj}/zfalsealarm_timing_subj${subj}.txt 'GAM' -stim_label 10 zfalsealarm \
	-allzero_OK \
	-jobs 3 \
	-GOFORIT 20 \
	-x1D sinestep5.mat.1D \
	-x1D_stop

	3dDeconvolve -input $top_dir/cth${subj}/cth${subj}.preproc_mvpa/pb02.${subj}.*.BRIK \
	-local_times \
	-num_stimts 10 \
	-stim_times 1 $top_dir/cth${subj}/catch_timing_subj${subj}.txt 'GAM' -stim_label 1 catch \
	-stim_times 2 $top_dir/cth${subj}/sinestep1_timing_subj${subj}.txt 'GAM' -stim_label 2 sinestep1 \
	-stim_times 3 $top_dir/cth${subj}/sinestep3_timing_subj${subj}.txt 'GAM' -stim_label 3 sinestep3 \
	-stim_times_IM 4 $top_dir/cth${subj}/sinestep5_timing_subj${subj}.txt 'GAM' -stim_label 4 sinestep5 \
	-stim_times 5 $top_dir/cth${subj}/sinestep7_timing_subj${subj}.txt 'GAM' -stim_label 5 sinestep7 \
	-stim_times 6 $top_dir/cth${subj}/vowelstep1_timing_subj${subj}.txt 'GAM' -stim_label 6 vowelstep1 \
	-stim_times 7 $top_dir/cth${subj}/vowelstep3_timing_subj${subj}.txt 'GAM' -stim_label 7 vowelstep3 \
	-stim_times 8 $top_dir/cth${subj}/vowelstep5_timing_subj${subj}.txt 'GAM' -stim_label 8 vowelstep5 \
	-stim_times 9 $top_dir/cth${subj}/vowelstep7_timing_subj${subj}.txt 'GAM' -stim_label 9 vowelstep7 \
	-stim_times 10 $top_dir/cth${subj}/zfalsealarm_timing_subj${subj}.txt 'GAM' -stim_label 10 zfalsealarm \
	-allzero_OK \
	-jobs 3 \
	-GOFORIT 20 \
	-x1D sinestep5.mat.1D \
	-x1D_stop

	3dDeconvolve -input $top_dir/cth${subj}/cth${subj}.preproc_mvpa/pb02.${subj}.*.BRIK \
	-local_times \
	-num_stimts 10 \
	-stim_times 1 $top_dir/cth${subj}/catch_timing_subj${subj}.txt 'GAM' -stim_label 1 catch \
	-stim_times 2 $top_dir/cth${subj}/sinestep1_timing_subj${subj}.txt 'GAM' -stim_label 2 sinestep1 \
	-stim_times 3 $top_dir/cth${subj}/sinestep3_timing_subj${subj}.txt 'GAM' -stim_label 3 sinestep3 \
	-stim_times 4 $top_dir/cth${subj}/sinestep5_timing_subj${subj}.txt 'GAM' -stim_label 4 sinestep5 \
	-stim_times_IM 5 $top_dir/cth${subj}/sinestep7_timing_subj${subj}.txt 'GAM' -stim_label 5 sinestep7 \
	-stim_times 6 $top_dir/cth${subj}/vowelstep1_timing_subj${subj}.txt 'GAM' -stim_label 6 vowelstep1 \
	-stim_times 7 $top_dir/cth${subj}/vowelstep3_timing_subj${subj}.txt 'GAM' -stim_label 7 vowelstep3 \
	-stim_times 8 $top_dir/cth${subj}/vowelstep5_timing_subj${subj}.txt 'GAM' -stim_label 8 vowelstep5 \
	-stim_times 9 $top_dir/cth${subj}/vowelstep7_timing_subj${subj}.txt 'GAM' -stim_label 9 vowelstep7 \
	-stim_times 10 $top_dir/cth${subj}/zfalsealarm_timing_subj${subj}.txt 'GAM' -stim_label 10 zfalsealarm \
	-allzero_OK \
	-jobs 3 \
	-GOFORIT 20 \
	-x1D sinestep7.mat.1D \
	-x1D_stop

	3dDeconvolve -input $top_dir/cth${subj}/cth${subj}.preproc_mvpa/pb02.${subj}.*.BRIK \
	-local_times \
	-num_stimts 10 \
	-stim_times 1 $top_dir/cth${subj}/catch_timing_subj${subj}.txt 'GAM' -stim_label 1 catch \
	-stim_times 2 $top_dir/cth${subj}/sinestep1_timing_subj${subj}.txt 'GAM' -stim_label 2 sinestep1 \
	-stim_times 3 $top_dir/cth${subj}/sinestep3_timing_subj${subj}.txt 'GAM' -stim_label 3 sinestep3 \
	-stim_times 4 $top_dir/cth${subj}/sinestep5_timing_subj${subj}.txt 'GAM' -stim_label 4 sinestep5 \
	-stim_times 5 $top_dir/cth${subj}/sinestep7_timing_subj${subj}.txt 'GAM' -stim_label 5 sinestep7 \
	-stim_times_IM 6 $top_dir/cth${subj}/vowelstep1_timing_subj${subj}.txt 'GAM' -stim_label 6 vowelstep1 \
	-stim_times 7 $top_dir/cth${subj}/vowelstep3_timing_subj${subj}.txt 'GAM' -stim_label 7 vowelstep3 \
	-stim_times 8 $top_dir/cth${subj}/vowelstep5_timing_subj${subj}.txt 'GAM' -stim_label 8 vowelstep5 \
	-stim_times 9 $top_dir/cth${subj}/vowelstep7_timing_subj${subj}.txt 'GAM' -stim_label 9 vowelstep7 \
	-stim_times 10 $top_dir/cth${subj}/zfalsealarm_timing_subj${subj}.txt 'GAM' -stim_label 10 zfalsealarm \
	-allzero_OK \
	-jobs 3 \
	-GOFORIT 20 \
	-x1D vowelstep1.mat.1D \
	-x1D_stop

	3dDeconvolve -input $top_dir/cth${subj}/cth${subj}.preproc_mvpa/pb02.${subj}.*.BRIK \
	-local_times \
	-num_stimts 10 \
	-stim_times 1 $top_dir/cth${subj}/catch_timing_subj${subj}.txt 'GAM' -stim_label 1 catch \
	-stim_times 2 $top_dir/cth${subj}/sinestep1_timing_subj${subj}.txt 'GAM' -stim_label 2 sinestep1 \
	-stim_times 3 $top_dir/cth${subj}/sinestep3_timing_subj${subj}.txt 'GAM' -stim_label 3 sinestep3 \
	-stim_times 4 $top_dir/cth${subj}/sinestep5_timing_subj${subj}.txt 'GAM' -stim_label 4 sinestep5 \
	-stim_times 5 $top_dir/cth${subj}/sinestep7_timing_subj${subj}.txt 'GAM' -stim_label 5 sinestep7 \
	-stim_times 6 $top_dir/cth${subj}/vowelstep1_timing_subj${subj}.txt 'GAM' -stim_label 6 vowelstep1 \
	-stim_times_IM 7 $top_dir/cth${subj}/vowelstep3_timing_subj${subj}.txt 'GAM' -stim_label 7 vowelstep3 \
	-stim_times 8 $top_dir/cth${subj}/vowelstep5_timing_subj${subj}.txt 'GAM' -stim_label 8 vowelstep5 \
	-stim_times 9 $top_dir/cth${subj}/vowelstep7_timing_subj${subj}.txt 'GAM' -stim_label 9 vowelstep7 \
	-stim_times 10 $top_dir/cth${subj}/zfalsealarm_timing_subj${subj}.txt 'GAM' -stim_label 10 zfalsealarm \
	-allzero_OK \
	-jobs 3 \
	-GOFORIT 20 \
	-x1D vowelstep3.mat.1D \
	-x1D_stop

	3dDeconvolve -input $top_dir/cth${subj}/cth${subj}.preproc_mvpa/pb02.${subj}.*.BRIK \
	-local_times \
	-num_stimts 10 \
	-stim_times 1 $top_dir/cth${subj}/catch_timing_subj${subj}.txt 'GAM' -stim_label 1 catch \
	-stim_times 2 $top_dir/cth${subj}/sinestep1_timing_subj${subj}.txt 'GAM' -stim_label 2 sinestep1 \
	-stim_times 3 $top_dir/cth${subj}/sinestep3_timing_subj${subj}.txt 'GAM' -stim_label 3 sinestep3 \
	-stim_times 4 $top_dir/cth${subj}/sinestep5_timing_subj${subj}.txt 'GAM' -stim_label 4 sinestep5 \
	-stim_times 5 $top_dir/cth${subj}/sinestep7_timing_subj${subj}.txt 'GAM' -stim_label 5 sinestep7 \
	-stim_times 6 $top_dir/cth${subj}/vowelstep1_timing_subj${subj}.txt 'GAM' -stim_label 6 vowelstep1 \
	-stim_times 7 $top_dir/cth${subj}/vowelstep3_timing_subj${subj}.txt 'GAM' -stim_label 7 vowelstep3 \
	-stim_times_IM 8 $top_dir/cth${subj}/vowelstep5_timing_subj${subj}.txt 'GAM' -stim_label 8 vowelstep5 \
	-stim_times 9 $top_dir/cth${subj}/vowelstep7_timing_subj${subj}.txt 'GAM' -stim_label 9 vowelstep7 \
	-stim_times 10 $top_dir/cth${subj}/zfalsealarm_timing_subj${subj}.txt 'GAM' -stim_label 10 zfalsealarm \
	-allzero_OK \
	-jobs 3 \
	-GOFORIT 20 \
	-x1D vowelstep5.mat.1D \
	-x1D_stop

	3dDeconvolve -input $top_dir/cth${subj}/cth${subj}.preproc_mvpa/pb02.${subj}.*.BRIK \
	-local_times \
	-num_stimts 10 \
	-stim_times 1 $top_dir/cth${subj}/catch_timing_subj${subj}.txt 'GAM' -stim_label 1 catch \
	-stim_times 2 $top_dir/cth${subj}/sinestep1_timing_subj${subj}.txt 'GAM' -stim_label 2 sinestep1 \
	-stim_times 3 $top_dir/cth${subj}/sinestep3_timing_subj${subj}.txt 'GAM' -stim_label 3 sinestep3 \
	-stim_times 4 $top_dir/cth${subj}/sinestep5_timing_subj${subj}.txt 'GAM' -stim_label 4 sinestep5 \
	-stim_times 5 $top_dir/cth${subj}/sinestep7_timing_subj${subj}.txt 'GAM' -stim_label 5 sinestep7 \
	-stim_times 6 $top_dir/cth${subj}/vowelstep1_timing_subj${subj}.txt 'GAM' -stim_label 6 vowelstep1 \
	-stim_times 7 $top_dir/cth${subj}/vowelstep3_timing_subj${subj}.txt 'GAM' -stim_label 7 vowelstep3 \
	-stim_times_IM 8 $top_dir/cth${subj}/vowelstep5_timing_subj${subj}.txt 'GAM' -stim_label 8 vowelstep5 \
	-stim_times 9 $top_dir/cth${subj}/vowelstep7_timing_subj${subj}.txt 'GAM' -stim_label 9 vowelstep7 \
	-stim_times 10 $top_dir/cth${subj}/zfalsealarm_timing_subj${subj}.txt 'GAM' -stim_label 10 zfalsealarm \
	-allzero_OK \
	-jobs 3 \
	-GOFORIT 20 \
	-x1D vowelstep5.mat.1D \
	-x1D_stop

	3dDeconvolve -input $top_dir/cth${subj}/cth${subj}.preproc_mvpa/pb02.${subj}.*.BRIK \
	-local_times \
	-num_stimts 10 \
	-stim_times 1 $top_dir/cth${subj}/catch_timing_subj${subj}.txt 'GAM' -stim_label 1 catch \
	-stim_times 2 $top_dir/cth${subj}/sinestep1_timing_subj${subj}.txt 'GAM' -stim_label 2 sinestep1 \
	-stim_times 3 $top_dir/cth${subj}/sinestep3_timing_subj${subj}.txt 'GAM' -stim_label 3 sinestep3 \
	-stim_times 4 $top_dir/cth${subj}/sinestep5_timing_subj${subj}.txt 'GAM' -stim_label 4 sinestep5 \
	-stim_times 5 $top_dir/cth${subj}/sinestep7_timing_subj${subj}.txt 'GAM' -stim_label 5 sinestep7 \
	-stim_times 6 $top_dir/cth${subj}/vowelstep1_timing_subj${subj}.txt 'GAM' -stim_label 6 vowelstep1 \
	-stim_times 7 $top_dir/cth${subj}/vowelstep3_timing_subj${subj}.txt 'GAM' -stim_label 7 vowelstep3 \
	-stim_times 8 $top_dir/cth${subj}/vowelstep5_timing_subj${subj}.txt 'GAM' -stim_label 8 vowelstep5 \
	-stim_times_IM 9 $top_dir/cth${subj}/vowelstep7_timing_subj${subj}.txt 'GAM' -stim_label 9 vowelstep7 \
	-stim_times 10 $top_dir/cth${subj}/zfalsealarm_timing_subj${subj}.txt 'GAM' -stim_label 10 zfalsealarm \
	-allzero_OK \
	-jobs 3 \
	-GOFORIT 20 \
	-x1D vowelstep7.mat.1D \
	-x1D_stop

# run 3dLSS and extract individual trial betas
	foreach event (sinestep1 sinestep3 sinestep5 sinestep7 vowelstep1 vowelstep3 vowelstep5 vowelstep7)
		3dLSS -verb -matrix ${event}.mat.1D -input all_runs_LSS+orig. -prefix ${event}_LSS -save1D ${event}.LSS.1D
		# if you want to resassemble back into runs after
		3dTcat -prefix conditionXrun_betas/${event}_run1 ${event}_LSS+orig'[0..14]'
		3dTcat -prefix conditionXrun_betas/${event}_run2 ${event}_LSS+orig'[15..29]'
		3dTcat -prefix conditionXrun_betas/${event}_run3 ${event}_LSS+orig'[30..44]'
		3dTcat -prefix conditionXrun_betas/${event}_run4 ${event}_LSS+orig'[45..59]'
		3dTcat -prefix conditionXrun_betas/${event}_run5 ${event}_LSS+orig'[60..74]'
		3dTcat -prefix conditionXrun_betas/${event}_run6 ${event}_LSS+orig'[75..89]'
		3dTcat -prefix conditionXrun_betas/${event}_run7 ${event}_LSS+orig'[90..104]'
		3dTcat -prefix conditionXrun_betas/${event}_run8 ${event}_LSS+orig'[105..119]'
		3dTcat -prefix conditionXrun_betas/${event}_run9 ${event}_LSS+orig'[120..134]'
		3dTcat -prefix conditionXrun_betas/${event}_run10 ${event}_LSS+orig'[135..$]'
	end	
end

# reassemble into runs
	foreach runnum (1 2 3 4 5 6 7 8 9 10)
		3dTcat -prefix readyforMVPA_Mumford/cth${subj}_betas_run${runnum} conditionXrun_betas/*_run${runnum}+orig.BRIK
	end
