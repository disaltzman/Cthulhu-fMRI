#!/bin/tcsh -f

set top_dir = /Volumes/netapp/Myerslab/Dave/Cthulhu/data

foreach subj (1 2 3 6 8 9 10 11 12 14 15 16 17 18 20 21 22 24 25 26 27 28 30 31 32 34)
	adwarp \
	-apar $top_dir/cth${subj}/cth${subj}.preproc/anat_final.${subj}+tlrc \
	-dpar $top_dir/cth${subj}/cth${subj}.preproc_mvpa/searchlight/AvsB_vowel-ROI/res_accuracy_minus_chance_multiroi+orig \
	-dxyz 2 \
	-prefix $top_dir/group/MVPA/AvsB_vowel-ROI/res_accuracy_minus_chance_multiroi_cth${subj}

	3dBlurToFWHM -FWHM 4 \
	-prefix $top_dir/group/MVPA/AvsB_vowel-ROI/res_accuracy_minus_chance_multiroi_cth${subj}_blurred \
	-input $top_dir/group/MVPA/AvsB_vowel-ROI/res_accuracy_minus_chance_multiroi_cth${subj}+tlrc
end

3dttest++ -setA AvsB_vowel-ROI \
cth1	$top_dir/group/MVPA/AvsB_vowel-ROI/res_accuracy_minus_chance_multiroi_cth1_blurred+tlrc'[0]' \
cth2	$top_dir/group/MVPA/AvsB_vowel-ROI/res_accuracy_minus_chance_multiroi_cth2_blurred+tlrc'[0]' \
cth3	$top_dir/group/MVPA/AvsB_vowel-ROI/res_accuracy_minus_chance_multiroi_cth3_blurred+tlrc'[0]' \
cth6	$top_dir/group/MVPA/AvsB_vowel-ROI/res_accuracy_minus_chance_multiroi_cth6_blurred+tlrc'[0]' \
cth8	$top_dir/group/MVPA/AvsB_vowel-ROI/res_accuracy_minus_chance_multiroi_cth8_blurred+tlrc'[0]' \
cth9	$top_dir/group/MVPA/AvsB_vowel-ROI/res_accuracy_minus_chance_multiroi_cth9_blurred+tlrc'[0]' \
cth10	$top_dir/group/MVPA/AvsB_vowel-ROI/res_accuracy_minus_chance_multiroi_cth10_blurred+tlrc'[0]' \
cth11	$top_dir/group/MVPA/AvsB_vowel-ROI/res_accuracy_minus_chance_multiroi_cth11_blurred+tlrc'[0]' \
cth12	$top_dir/group/MVPA/AvsB_vowel-ROI/res_accuracy_minus_chance_multiroi_cth12_blurred+tlrc'[0]' \
cth14	$top_dir/group/MVPA/AvsB_vowel-ROI/res_accuracy_minus_chance_multiroi_cth14_blurred+tlrc'[0]' \
cth15	$top_dir/group/MVPA/AvsB_vowel-ROI/res_accuracy_minus_chance_multiroi_cth15_blurred+tlrc'[0]' \
cth16	$top_dir/group/MVPA/AvsB_vowel-ROI/res_accuracy_minus_chance_multiroi_cth16_blurred+tlrc'[0]' \
cth17	$top_dir/group/MVPA/AvsB_vowel-ROI/res_accuracy_minus_chance_multiroi_cth17_blurred+tlrc'[0]' \
cth18	$top_dir/group/MVPA/AvsB_vowel-ROI/res_accuracy_minus_chance_multiroi_cth18_blurred+tlrc'[0]' \
cth20	$top_dir/group/MVPA/AvsB_vowel-ROI/res_accuracy_minus_chance_multiroi_cth20_blurred+tlrc'[0]' \
cth21	$top_dir/group/MVPA/AvsB_vowel-ROI/res_accuracy_minus_chance_multiroi_cth21_blurred+tlrc'[0]' \
cth22	$top_dir/group/MVPA/AvsB_vowel-ROI/res_accuracy_minus_chance_multiroi_cth22_blurred+tlrc'[0]' \
cth24	$top_dir/group/MVPA/AvsB_vowel-ROI/res_accuracy_minus_chance_multiroi_cth24_blurred+tlrc'[0]' \
cth25	$top_dir/group/MVPA/AvsB_vowel-ROI/res_accuracy_minus_chance_multiroi_cth25_blurred+tlrc'[0]' \
cth26	$top_dir/group/MVPA/AvsB_vowel-ROI/res_accuracy_minus_chance_multiroi_cth26_blurred+tlrc'[0]' \
cth27	$top_dir/group/MVPA/AvsB_vowel-ROI/res_accuracy_minus_chance_multiroi_cth27_blurred+tlrc'[0]' \
cth28	$top_dir/group/MVPA/AvsB_vowel-ROI/res_accuracy_minus_chance_multiroi_cth28_blurred+tlrc'[0]' \
cth30	$top_dir/group/MVPA/AvsB_vowel-ROI/res_accuracy_minus_chance_multiroi_cth30_blurred+tlrc'[0]' \
cth31	$top_dir/group/MVPA/AvsB_vowel-ROI/res_accuracy_minus_chance_multiroi_cth31_blurred+tlrc'[0]' \
cth32	$top_dir/group/MVPA/AvsB_vowel-ROI/res_accuracy_minus_chance_multiroi_cth32_blurred+tlrc'[0]' \
cth34	$top_dir/group/MVPA/AvsB_vowel-ROI/res_accuracy_minus_chance_multiroi_cth34_blurred+tlrc'[0]' \
-prefix $top_dir/group/MVPA/AvsB_vowel-ROI/AvsB_vowel-ROI_ttest \
-mask $top_dir/group/group_mask+tlrc -covariates mvpa_covariates.txt
