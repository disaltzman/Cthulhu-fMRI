#!/bin/tcsh -f

set top_dir = /Volumes/netapp/MyersLab/Dave/Cthulhu/data 

foreach subj (9 10 11 12 14 15 16 17 18 20 21 22 24 25 26 27 28 30 31 32 34)	
	cd $top_dir/cth${subj}/cth${subj}.preproc_mvpa
	rm -r AvsB*
end
