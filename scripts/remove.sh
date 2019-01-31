#!/bin/tcsh -f

set top_dir = /Volumes/netapp/MyersLab/Dave/Cthulhu/data 

foreach subj (1 2 3 6 8 9 10 11 12 14 16 17 18 20 21 22 24 25)
	cd $top_dir/cth${subj}/cth${subj}.preproc_mvpa
	rm -r searchlight
end
