#!/bin/tcsh -f

set top_dir = /Volumes/netapp/MyersLab/Dave/Cthulhu/data 

foreach subj (2)
	set anat_dir = $top_dir/cth${subj}/briks
	set epi_dir = $top_dir/cth${subj}/briks	

	cd $top_dir/cth${subj}/cth${subj}.preproc_MVPA
	mkdir trial_betas

	foreach event (sinestep1 sinestep3 sinestep5 sinestep7 vowelstep1 vowelstep3 vowelstep5 vowelstep7)
			set numBriks = `3dinfo -nv ${event}_LSS+orig.HEAD`
			set numBriksPython = `expr $numBriks - 1`
				foreach trial (`seq 0 $numBriksPython`)
					echo "extracting ${event} beta for trial ${trial}"
					3dTcat -prefix trial_betas/${event}_trial${trial} ${event}_LSS+orig"[${trial}]"
					echo "beta for ${event} trial ${trial} extracted"
					end
				end
			end		
