#!/bin/tcsh -f

set top_dir = /Volumes/netapp/MyersLab/Dave/Cthulhu/data

foreach subj (17 18 20 21 22 24 25)
	mv *subj${subj}.txt $top_dir/cth${subj}/mvpa.timing
end
