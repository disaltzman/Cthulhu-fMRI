#!/bin/tcsh -f

set top_dir = /Volumes/netapp/Research/MyersLab/Dave/Cthulhu/data 

foreach subj (8 9 10 11 12 14 16 17 18 20 21 22 24 25)
	rm -r $top_dir/cth${subj}/cth${subj}.preproc_mvpa
end
