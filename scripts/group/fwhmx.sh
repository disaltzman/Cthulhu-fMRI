#!/bin/csh -f

#HOW TO RUN SCRIPT
# use terminal
# first copy foreach line
# then copy bulk of script (just not "end")
# then type "end"

set top_dir = /Volumes/netapp/Myerslab/Dave/Cthulhu/data
mkdir $top_dir/group/fhwmx
foreach subj (1 2 3 6 8 9 10 11 12 14 15 16 17 18 20 21 22 24 25 26 27 28 30 31 32 34)
	3dFWHMx -ACF -mask $top_dir/cth${subj}/cth${subj}.preproc/full_mask.${subj}+tlrc \
	$top_dir/cth${subj}/cth${subj}.preproc/errts.${subj}+tlrc > $top_dir/group/fhwmx/fwhmx.${subj}.acf.txt
end

cd $top_dir/group/fwhmx/
cat fwhmx.*.acf.txt > fwhmx_acf_all.txt