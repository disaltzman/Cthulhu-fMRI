#!/bin/tcsh -f

# set directory
set top_dir = /Volumes/netapp/Myerslab/Dave/Cthulhu/data

foreach subj (2)
	# paired T-test between AvsB vowel and AvsB sine
	3dttest++ -setA $top_dir/cth${subj}/cth${subj}.preproc_mvpa/searchlight/AvsB_vowel/res_accuracy_minus_chance+orig* \
	-setB $top_dir/cth${subj}/cth${subj}.preproc_mvpa/searchlight/AvsB_vowel-relative/res_accuracy_minus_chance+orig* \
	-prefix $top_dir/cth${subj}/cth${subj}.preproc_mvpa/searchlight/pairedAvsB_cth${subj} -paired
end
