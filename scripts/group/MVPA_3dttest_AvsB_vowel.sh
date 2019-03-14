#!/bin/tcsh -f

set top_dir = /Volumes/netapp/Myerslab/Dave/Cthulhu/data

foreach subj (1 2 3 6 8 9 10 11 12 14 15 16 17 18 20 21 22 24 25 26 27 28 30 31 32)
	adwarp \
	-apar $top_dir/cth${subj}/cth${subj}.preproc/anat_final.${subj}+tlrc \
	-dpar $top_dir/cth${subj}/cth${subj}.preproc_mvpa/searchlight/AvsB_vowel/res_accuracy_minus_chance+orig \
	-dxyz 2 \
	-prefix $top_dir/group/MVPA/AvsB_vowel/res_accuracy_minus_chance_cth${subj}
end

3dttest++ -setA $top_dir/group/MVPA/AvsB_vowel/res_accuracy_minus_chance*	-prefix $top_dir/group/MVPA/AvsB_vowel/AvsB_vowel_ttest