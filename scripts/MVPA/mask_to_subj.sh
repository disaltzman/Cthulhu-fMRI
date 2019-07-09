#!/bin/csh 

set top_dir = /Volumes/netapp/Myerslab/Dave/Cthulhu/data

foreach subj (1 2 3 6 8 9 10 11 12 14 15 16 17 18 20 21 22 24 25 26 27 28 30 31 32 34)	
	# 3dfractionize \
	# -template $top_dir/cth${subj}/cth${subj}.preproc_mvpa/anat_final.${subj}+orig \
	# -input $top_dir/group/MVPA/AvsB_vowel/VowelAvsB_0.025_149_Corr_0.05_mask+tlrc \
	# -warp $top_dir/cth${subj}/cth${subj}.preproc/anat_final.${subj}+tlrc \
	# -preserve \
	# -prefix $top_dir/cth${subj}/cth${subj}.preproc_mvpa/AvsB_vowel_0_025_clust_mask_cth${subj}
	
	3dresample \
	-dxyz 2 2 2 \
	-input $top_dir/cth${subj}/cth${subj}.preproc_mvpa/AvsB_vowel_0_025_clust_mask_cth${subj}+orig \
	-prefix $top_dir/cth${subj}/cth${subj}.preproc_mvpa/AvsB_vowel_0_025_clust_mask_cth${subj}_resampled
end
