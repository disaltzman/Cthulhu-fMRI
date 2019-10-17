#!/bin/tcsh -f

set top_dir = /Volumes/netapp/MyersLab/Dave/Cthulhu/data 

# main loop - over subjects
foreach subj (1)
	set anat_dir = $top_dir/cth${subj}/briks
	set epi_dir = $top_dir/cth${subj}/briks	

	# run proc.py to do minimal preprocessing of data
	afni_proc.py -subj_id $subj \
	-script $top_dir/cth${subj}/proc.cth${subj}_mvpa \
	-out_dir $top_dir/cth${subj}/cth${subj}.preproc_mvpa \
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

	# # create directory to store betas
	mkdir $top_dir/cth${subj}/cth${subj}.preproc_mvpa/readyforMVPA_Mumford

	# # loop over runs
	foreach runNum (01 02 03 04 05 06 07 08 09 10)

		# get matrices for each predictor for each run
		3dDeconvolve -input $top_dir/cth${subj}/cth${subj}.preproc_mvpa/pb02.${subj}.r${runNum}.*.BRIK \
		-local_times \
		-num_stimts 10 \
		-stim_times 1 $top_dir/cth${subj}/mvpa.timing/catch_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 1 catch \
		-stim_times_IM 2 $top_dir/cth${subj}/mvpa.timing/sinestep1_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 2 sinestep1 \
		-stim_times 3 $top_dir/cth${subj}/mvpa.timing/sinestep3_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 3 sinestep3 \
		-stim_times 4 $top_dir/cth${subj}/mvpa.timing/sinestep5_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 4 sinestep5 \
		-stim_times 5 $top_dir/cth${subj}/mvpa.timing/sinestep7_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 5 sinestep7 \
		-stim_times 6 $top_dir/cth${subj}/mvpa.timing/vowelstep1_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 6 vowelstep1 \
		-stim_times 7 $top_dir/cth${subj}/mvpa.timing/vowelstep3_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 7 vowelstep3 \
		-stim_times 8 $top_dir/cth${subj}/mvpa.timing/vowelstep5_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 8 vowelstep5 \
		-stim_times 9 $top_dir/cth${subj}/mvpa.timing/vowelstep7_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 9 vowelstep7 \
		-stim_times 10 $top_dir/cth${subj}/mvpa.timing/zfalsealarm_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 10 zfalsealarm \
		-allzero_OK \
		-jobs 3 \
		-GOFORIT 20 \
		-x1D $top_dir/cth${subj}/cth${subj}.preproc_mvpa/sinestep1.r${runNum}.mat.1D \
		-x1D_stop

		3dDeconvolve -input $top_dir/cth${subj}/cth${subj}.preproc_mvpa/pb02.${subj}.r${runNum}.*.BRIK \
		-local_times \
		-num_stimts 10 \
		-stim_times 1 $top_dir/cth${subj}/mvpa.timing/catch_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 1 catch \
		-stim_times 2 $top_dir/cth${subj}/mvpa.timing/sinestep1_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 2 sinestep1 \
		-stim_times_IM 3 $top_dir/cth${subj}/mvpa.timing/sinestep3_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 3 sinestep3 \
		-stim_times 4 $top_dir/cth${subj}/mvpa.timing/sinestep5_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 4 sinestep5 \
		-stim_times 5 $top_dir/cth${subj}/mvpa.timing/sinestep7_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 5 sinestep7 \
		-stim_times 6 $top_dir/cth${subj}/mvpa.timing/vowelstep1_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 6 vowelstep1 \
		-stim_times 7 $top_dir/cth${subj}/mvpa.timing/vowelstep3_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 7 vowelstep3 \
		-stim_times 8 $top_dir/cth${subj}/mvpa.timing/vowelstep5_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 8 vowelstep5 \
		-stim_times 9 $top_dir/cth${subj}/mvpa.timing/vowelstep7_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 9 vowelstep7 \
		-stim_times 10 $top_dir/cth${subj}/mvpa.timing/zfalsealarm_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 10 zfalsealarm \
		-allzero_OK \
		-jobs 3 \
		-GOFORIT 20 \
		-x1D $top_dir/cth${subj}/cth${subj}.preproc_mvpa/sinestep3.r${runNum}.mat.1D \
		-x1D_stop

		3dDeconvolve -input $top_dir/cth${subj}/cth${subj}.preproc_mvpa/pb02.${subj}.r${runNum}.*.BRIK \
		-local_times \
		-num_stimts 10 \
		-stim_times 1 $top_dir/cth${subj}/mvpa.timing/catch_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 1 catch \
		-stim_times 2 $top_dir/cth${subj}/mvpa.timing/sinestep1_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 2 sinestep1 \
		-stim_times 3 $top_dir/cth${subj}/mvpa.timing/sinestep3_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 3 sinestep3 \
		-stim_times_IM 4 $top_dir/cth${subj}/mvpa.timing/sinestep5_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 4 sinestep5 \
		-stim_times 5 $top_dir/cth${subj}/mvpa.timing/sinestep7_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 5 sinestep7 \
		-stim_times 6 $top_dir/cth${subj}/mvpa.timing/vowelstep1_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 6 vowelstep1 \
		-stim_times 7 $top_dir/cth${subj}/mvpa.timing/vowelstep3_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 7 vowelstep3 \
		-stim_times 8 $top_dir/cth${subj}/mvpa.timing/vowelstep5_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 8 vowelstep5 \
		-stim_times 9 $top_dir/cth${subj}/mvpa.timing/vowelstep7_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 9 vowelstep7 \
		-stim_times 10 $top_dir/cth${subj}/mvpa.timing/zfalsealarm_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 10 zfalsealarm \
		-allzero_OK \
		-jobs 3 \
		-GOFORIT 20 \
		-x1D $top_dir/cth${subj}/cth${subj}.preproc_mvpa/sinestep5.r${runNum}.mat.1D \
		-x1D_stop

		3dDeconvolve -input $top_dir/cth${subj}/cth${subj}.preproc_mvpa/pb02.${subj}.r${runNum}.*.BRIK \
		-local_times \
		-num_stimts 10 \
		-stim_times 1 $top_dir/cth${subj}/mvpa.timing/catch_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 1 catch \
		-stim_times 2 $top_dir/cth${subj}/mvpa.timing/sinestep1_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 2 sinestep1 \
		-stim_times 3 $top_dir/cth${subj}/mvpa.timing/sinestep3_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 3 sinestep3 \
		-stim_times 4 $top_dir/cth${subj}/mvpa.timing/sinestep5_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 4 sinestep5 \
		-stim_times_IM 5 $top_dir/cth${subj}/mvpa.timing/sinestep7_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 5 sinestep7 \
		-stim_times 6 $top_dir/cth${subj}/mvpa.timing/vowelstep1_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 6 vowelstep1 \
		-stim_times 7 $top_dir/cth${subj}/mvpa.timing/vowelstep3_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 7 vowelstep3 \
		-stim_times 8 $top_dir/cth${subj}/mvpa.timing/vowelstep5_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 8 vowelstep5 \
		-stim_times 9 $top_dir/cth${subj}/mvpa.timing/vowelstep7_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 9 vowelstep7 \
		-stim_times 10 $top_dir/cth${subj}/mvpa.timing/zfalsealarm_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 10 zfalsealarm \
		-allzero_OK \
		-jobs 3 \
		-GOFORIT 20 \
		-x1D $top_dir/cth${subj}/cth${subj}.preproc_mvpa/sinestep7.r${runNum}.mat.1D \
		-x1D_stop

		3dDeconvolve -input $top_dir/cth${subj}/cth${subj}.preproc_mvpa/pb02.${subj}.r${runNum}.*.BRIK \
		-local_times \
		-num_stimts 10 \
		-stim_times 1 $top_dir/cth${subj}/mvpa.timing/catch_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 1 catch \
		-stim_times 2 $top_dir/cth${subj}/mvpa.timing/sinestep1_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 2 sinestep1 \
		-stim_times 3 $top_dir/cth${subj}/mvpa.timing/sinestep3_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 3 sinestep3 \
		-stim_times 4 $top_dir/cth${subj}/mvpa.timing/sinestep5_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 4 sinestep5 \
		-stim_times 5 $top_dir/cth${subj}/mvpa.timing/sinestep7_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 5 sinestep7 \
		-stim_times_IM 6 $top_dir/cth${subj}/mvpa.timing/vowelstep1_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 6 vowelstep1 \
		-stim_times 7 $top_dir/cth${subj}/mvpa.timing/vowelstep3_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 7 vowelstep3 \
		-stim_times 8 $top_dir/cth${subj}/mvpa.timing/vowelstep5_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 8 vowelstep5 \
		-stim_times 9 $top_dir/cth${subj}/mvpa.timing/vowelstep7_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 9 vowelstep7 \
		-stim_times 10 $top_dir/cth${subj}/mvpa.timing/zfalsealarm_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 10 zfalsealarm \
		-allzero_OK \
		-jobs 3 \
		-GOFORIT 20 \
		-x1D $top_dir/cth${subj}/cth${subj}.preproc_mvpa/vowelstep1.r${runNum}.mat.1D \
		-x1D_stop

		3dDeconvolve -input $top_dir/cth${subj}/cth${subj}.preproc_mvpa/pb02.${subj}.r${runNum}.*.BRIK \
		-local_times \
		-num_stimts 10 \
		-stim_times 1 $top_dir/cth${subj}/mvpa.timing/catch_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 1 catch \
		-stim_times 2 $top_dir/cth${subj}/mvpa.timing/sinestep1_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 2 sinestep1 \
		-stim_times 3 $top_dir/cth${subj}/mvpa.timing/sinestep3_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 3 sinestep3 \
		-stim_times 4 $top_dir/cth${subj}/mvpa.timing/sinestep5_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 4 sinestep5 \
		-stim_times 5 $top_dir/cth${subj}/mvpa.timing/sinestep7_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 5 sinestep7 \
		-stim_times 6 $top_dir/cth${subj}/mvpa.timing/vowelstep1_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 6 vowelstep1 \
		-stim_times_IM 7 $top_dir/cth${subj}/mvpa.timing/vowelstep3_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 7 vowelstep3 \
		-stim_times 8 $top_dir/cth${subj}/mvpa.timing/vowelstep5_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 8 vowelstep5 \
		-stim_times 9 $top_dir/cth${subj}/mvpa.timing/vowelstep7_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 9 vowelstep7 \
		-stim_times 10 $top_dir/cth${subj}/mvpa.timing/zfalsealarm_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 10 zfalsealarm \
		-allzero_OK \
		-jobs 3 \
		-GOFORIT 20 \
		-x1D $top_dir/cth${subj}/cth${subj}.preproc_mvpa/vowelstep3.r${runNum}.mat.1D \
		-x1D_stop

		3dDeconvolve -input $top_dir/cth${subj}/cth${subj}.preproc_mvpa/pb02.${subj}.r${runNum}.*.BRIK \
		-local_times \
		-num_stimts 10 \
		-stim_times 1 $top_dir/cth${subj}/mvpa.timing/catch_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 1 catch \
		-stim_times 2 $top_dir/cth${subj}/mvpa.timing/sinestep1_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 2 sinestep1 \
		-stim_times 3 $top_dir/cth${subj}/mvpa.timing/sinestep3_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 3 sinestep3 \
		-stim_times 4 $top_dir/cth${subj}/mvpa.timing/sinestep5_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 4 sinestep5 \
		-stim_times 5 $top_dir/cth${subj}/mvpa.timing/sinestep7_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 5 sinestep7 \
		-stim_times 6 $top_dir/cth${subj}/mvpa.timing/vowelstep1_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 6 vowelstep1 \
		-stim_times 7 $top_dir/cth${subj}/mvpa.timing/vowelstep3_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 7 vowelstep3 \
		-stim_times_IM 8 $top_dir/cth${subj}/mvpa.timing/vowelstep5_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 8 vowelstep5 \
		-stim_times 9 $top_dir/cth${subj}/mvpa.timing/vowelstep7_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 9 vowelstep7 \
		-stim_times 10 $top_dir/cth${subj}/mvpa.timing/zfalsealarm_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 10 zfalsealarm \
		-allzero_OK \
		-jobs 3 \
		-GOFORIT 20 \
		-x1D $top_dir/cth${subj}/cth${subj}.preproc_mvpa/vowelstep5.r${runNum}.mat.1D \
		-x1D_stop

		3dDeconvolve -input $top_dir/cth${subj}/cth${subj}.preproc_mvpa/pb02.${subj}.r${runNum}.*.BRIK \
		-local_times \
		-num_stimts 10 \
		-stim_times 1 $top_dir/cth${subj}/mvpa.timing/catch_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 1 catch \
		-stim_times 2 $top_dir/cth${subj}/mvpa.timing/sinestep1_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 2 sinestep1 \
		-stim_times 3 $top_dir/cth${subj}/mvpa.timing/sinestep3_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 3 sinestep3 \
		-stim_times 4 $top_dir/cth${subj}/mvpa.timing/sinestep5_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 4 sinestep5 \
		-stim_times 5 $top_dir/cth${subj}/mvpa.timing/sinestep7_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 5 sinestep7 \
		-stim_times 6 $top_dir/cth${subj}/mvpa.timing/vowelstep1_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 6 vowelstep1 \
		-stim_times 7 $top_dir/cth${subj}/mvpa.timing/vowelstep3_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 7 vowelstep3 \
		-stim_times 8 $top_dir/cth${subj}/mvpa.timing/vowelstep5_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 8 vowelstep5 \
		-stim_times_IM 9 $top_dir/cth${subj}/mvpa.timing/vowelstep7_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 9 vowelstep7 \
		-stim_times 10 $top_dir/cth${subj}/mvpa.timing/zfalsealarm_timing_subj${subj}_run${runNum}.txt 'GAM' -stim_label 10 zfalsealarm \
		-allzero_OK \
		-jobs 3 \
		-GOFORIT 20 \
		-x1D $top_dir/cth${subj}/cth${subj}.preproc_mvpa/vowelstep7.r${runNum}.mat.1D \
		-x1D_stop

		# run 3dLSS by run to get betas for each event type
 		foreach event (sinestep1 sinestep3 sinestep5 sinestep7 vowelstep1 vowelstep3 vowelstep5 vowelstep7)
 			3dLSS -verb -matrix $top_dir/cth${subj}/cth${subj}.preproc_mvpa/${event}.r${runNum}.mat.1D \
 			-input $top_dir/cth${subj}/cth${subj}.preproc_mvpa/pb02.${subj}.r${runNum}.*.BRIK \
 			-prefix $top_dir/cth${subj}/cth${subj}.preproc_mvpa/${event}_r${runNum}_LSS \
 			-save1D $top_dir/cth${subj}/cth${subj}.preproc_mvpa/${event}.r${runNum}.LSS.1D
 		end	

 		# combine LSS output for each stimulus by run into one file for each run
 		3dTcat -prefix $top_dir/cth${subj}/cth${subj}.preproc_mvpa/readyforMVPA_Mumford/cth${subj}_betas_run${runNum} \
 		$top_dir/cth${subj}/cth${subj}.preproc_mvpa/*_r${runNum}_LSS+orig.BRIK
 	end
end	
