#!/bin/tcsh -f

set top_dir = /Volumes/netapp/MyersLab/Dave/Cthulhu/data 

foreach subj (2)
	mv *subj${subj}.txt $top_dir/cth${subj}/mvpa.timing
end