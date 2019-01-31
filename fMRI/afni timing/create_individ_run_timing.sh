#!/bin/tcsh -f

set top_dir = /Volumes/netapp/MyersLab/Dave/Cthulhu/data 

foreach subj (1 2 3 6 8 9 10 11 12 14 16 17 18 20 21 22 24 25)
	cd $top_dir/cth${subj}
	mkdir mvpa.timing
		foreach stimulus (sinestep1 sinestep3 sinestep5 sinestep7 vowelstep1 vowelstep3 vowelstep5 vowelstep7)
			foreach run (01 02 03 04 05 06 07 08 09 10)
				awk NR==${run} ${stimulus}_timing_subj${subj}.txt > mvpa.timing/${stimulus}_timing_${subj}_run${run}.txt
				end
			end
end