#!/bin/tcsh -f

set top_dir = /Volumes/netapp/MyersLab/Dave/Cthulhu/data 

foreach subj (1 2 3 6 8 9 10 11 12 14 16 17 18 20 21 22 24 25)
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

	cd $top_dir/cth${subj}/cth${subj}.preproc_MVPA
	mkdir readyforMVPA_oneperrun

	# get betas for each predictor
	foreach runNum (01 02 03 04 05 06 07 08 09 10)
		3dDeconvolve -input $top_dir/cth${subj}/cth${subj}.preproc_mvpa/pb02.${subj}.r${runNum}*.BRIK \
		-local_times \
		-num_stimts 8 \
		-stim_times 1 $top_dir/cth${subj}/mvpa.timing/sinestep1_timing_${subj}_run${runNum}.txt 'GAM' -stim_label 1 sinestep1 \
		-stim_times 2 $top_dir/cth${subj}/mvpa.timing/sinestep3_timing_${subj}_run${runNum}.txt 'GAM' -stim_label 2 sinestep3 \
		-stim_times 3 $top_dir/cth${subj}/mvpa.timing/sinestep5_timing_${subj}_run${runNum}.txt 'GAM' -stim_label 3 sinestep5 \
		-stim_times 4 $top_dir/cth${subj}/mvpa.timing/sinestep7_timing_${subj}_run${runNum}.txt 'GAM' -stim_label 4 sinestep7 \
		-stim_times 5 $top_dir/cth${subj}/mvpa.timing/vowelstep1_timing_${subj}_run${runNum}.txt 'GAM' -stim_label 5 vowelstep1 \
		-stim_times 6 $top_dir/cth${subj}/mvpa.timing/vowelstep3_timing_${subj}_run${runNum}.txt 'GAM' -stim_label 6 vowelstep3 \
		-stim_times 7 $top_dir/cth${subj}/mvpa.timing/vowelstep5_timing_${subj}_run${runNum}.txt 'GAM' -stim_label 7 vowelstep5 \
		-stim_times 8 $top_dir/cth${subj}/mvpa.timing/vowelstep7_timing_${subj}_run${runNum}.txt 'GAM' -stim_label 8 vowelstep7 \
		-allzero_OK \
		-jobs 3 \
		-GOFORIT 20 \
		-x1D ${runNum}.mat.1D \
		-bucket readyforMVPA_oneperrun/run_${runNum}
	end
end
