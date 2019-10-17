#!/bin/tcsh -f

set top_dir = /Volumes/netapp/MyersLab/Dave/Cthulhu/data 

foreach subj (34)
	cd $top_dir/cth${subj}
	mkdir mvpa.timing
	foreach stimulus (catch sinestep1 sinestep3 sinestep5 sinestep7 vowelstep1 vowelstep3 vowelstep5 vowelstep7 zfalsealarm)
		foreach run (01 02 03 04 05 06 07 08 09 10)
			awk NR==${run} ${stimulus}_timing_subj${subj}.txt > mvpa.timing/${stimulus}_timing_subj${subj}_run${run}.txt
		end
	end
end