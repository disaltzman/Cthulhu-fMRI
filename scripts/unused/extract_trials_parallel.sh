#!/bin/bash -f

top_dir=/Volumes/netapp/MyersLab/Dave/Cthulhu/data

task(){
	# make folder to store betas
	mkdir trial_betas
	# loop over stimulus types and extract betas
	for event in sinestep1 sinestep3 sinestep5 sinestep7 vowelstep1 vowelstep3 vowelstep5 vowelstep7; do
		numBriks=`3dinfo -nv $top_dir/cth${subj}/cth${subj}.preproc_MVPA/${event}_LSS+orig.HEAD`
		numBriksPython=`expr $numBriks - 1`
		for trial in `seq 0 $numBriksPython`; do
				echo "extracting subject ${subj} ${event} beta for trial ${trial}"
				3dTcat -prefix $top_dir/cth${subj}/cth${subj}.preproc_MVPA/trial_betas/${event}_trial${trial} \
				$top_dir/cth${subj}/cth${subj}.preproc_MVPA/${event}_LSS+orig"[${trial}]"
				echo "subject ${subj} beta for ${event} trial ${trial} extracted"
		done
	done
}

for subj in 3 6 8; do
	task "$subj" &
done		
