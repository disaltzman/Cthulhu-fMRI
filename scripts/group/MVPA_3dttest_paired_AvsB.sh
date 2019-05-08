#!/bin/tcsh -f

# set directory
set top_dir = /Volumes/netapp/Myerslab/Dave/Cthulhu/data

# paired T-test between AvsB vowel and AvsB sine
3dttest++ -setA AvsB_vowel \
cth1	$top_dir/group/MVPA/AvsB_vowel/res_accuracy_minus_chance_cth1+tlrc'[0]' \
cth2	$top_dir/group/MVPA/AvsB_vowel/res_accuracy_minus_chance_cth2+tlrc'[0]' \
cth3	$top_dir/group/MVPA/AvsB_vowel/res_accuracy_minus_chance_cth3+tlrc'[0]' \
cth6	$top_dir/group/MVPA/AvsB_vowel/res_accuracy_minus_chance_cth6+tlrc'[0]' \
cth8	$top_dir/group/MVPA/AvsB_vowel/res_accuracy_minus_chance_cth8+tlrc'[0]' \
cth9	$top_dir/group/MVPA/AvsB_vowel/res_accuracy_minus_chance_cth9+tlrc'[0]' \
cth10	$top_dir/group/MVPA/AvsB_vowel/res_accuracy_minus_chance_cth10+tlrc'[0]' \
cth11	$top_dir/group/MVPA/AvsB_vowel/res_accuracy_minus_chance_cth11+tlrc'[0]' \
cth12	$top_dir/group/MVPA/AvsB_vowel/res_accuracy_minus_chance_cth12+tlrc'[0]' \
cth14	$top_dir/group/MVPA/AvsB_vowel/res_accuracy_minus_chance_cth14+tlrc'[0]' \
cth15	$top_dir/group/MVPA/AvsB_vowel/res_accuracy_minus_chance_cth15+tlrc'[0]' \
cth16	$top_dir/group/MVPA/AvsB_vowel/res_accuracy_minus_chance_cth16+tlrc'[0]' \
cth17	$top_dir/group/MVPA/AvsB_vowel/res_accuracy_minus_chance_cth17+tlrc'[0]' \
cth18	$top_dir/group/MVPA/AvsB_vowel/res_accuracy_minus_chance_cth18+tlrc'[0]' \
cth20	$top_dir/group/MVPA/AvsB_vowel/res_accuracy_minus_chance_cth20+tlrc'[0]' \
cth21	$top_dir/group/MVPA/AvsB_vowel/res_accuracy_minus_chance_cth21+tlrc'[0]' \
cth22	$top_dir/group/MVPA/AvsB_vowel/res_accuracy_minus_chance_cth22+tlrc'[0]' \
cth24	$top_dir/group/MVPA/AvsB_vowel/res_accuracy_minus_chance_cth24+tlrc'[0]' \
cth25	$top_dir/group/MVPA/AvsB_vowel/res_accuracy_minus_chance_cth25+tlrc'[0]' \
cth26	$top_dir/group/MVPA/AvsB_vowel/res_accuracy_minus_chance_cth26+tlrc'[0]' \
cth27	$top_dir/group/MVPA/AvsB_vowel/res_accuracy_minus_chance_cth27+tlrc'[0]' \
cth28	$top_dir/group/MVPA/AvsB_vowel/res_accuracy_minus_chance_cth28+tlrc'[0]' \
cth30	$top_dir/group/MVPA/AvsB_vowel/res_accuracy_minus_chance_cth30+tlrc'[0]' \
cth31	$top_dir/group/MVPA/AvsB_vowel/res_accuracy_minus_chance_cth31+tlrc'[0]' \
cth32	$top_dir/group/MVPA/AvsB_vowel/res_accuracy_minus_chance_cth32+tlrc'[0]' \
cth34	$top_dir/group/MVPA/AvsB_vowel/res_accuracy_minus_chance_cth34+tlrc'[0]' \
-setB AvsB_sine \
cth1	$top_dir/group/MVPA/AvsB_sine/res_accuracy_minus_chance_cth1+tlrc'[0]' \
cth2	$top_dir/group/MVPA/AvsB_sine/res_accuracy_minus_chance_cth2+tlrc'[0]' \
cth3	$top_dir/group/MVPA/AvsB_sine/res_accuracy_minus_chance_cth3+tlrc'[0]' \
cth6	$top_dir/group/MVPA/AvsB_sine/res_accuracy_minus_chance_cth6+tlrc'[0]' \
cth8	$top_dir/group/MVPA/AvsB_sine/res_accuracy_minus_chance_cth8+tlrc'[0]' \
cth9	$top_dir/group/MVPA/AvsB_sine/res_accuracy_minus_chance_cth9+tlrc'[0]' \
cth10	$top_dir/group/MVPA/AvsB_sine/res_accuracy_minus_chance_cth10+tlrc'[0]' \
cth11	$top_dir/group/MVPA/AvsB_sine/res_accuracy_minus_chance_cth11+tlrc'[0]' \
cth12	$top_dir/group/MVPA/AvsB_sine/res_accuracy_minus_chance_cth12+tlrc'[0]' \
cth14	$top_dir/group/MVPA/AvsB_sine/res_accuracy_minus_chance_cth14+tlrc'[0]' \
cth15	$top_dir/group/MVPA/AvsB_sine/res_accuracy_minus_chance_cth15+tlrc'[0]' \
cth16	$top_dir/group/MVPA/AvsB_sine/res_accuracy_minus_chance_cth16+tlrc'[0]' \
cth17	$top_dir/group/MVPA/AvsB_sine/res_accuracy_minus_chance_cth17+tlrc'[0]' \
cth18	$top_dir/group/MVPA/AvsB_sine/res_accuracy_minus_chance_cth18+tlrc'[0]' \
cth20	$top_dir/group/MVPA/AvsB_sine/res_accuracy_minus_chance_cth20+tlrc'[0]' \
cth21	$top_dir/group/MVPA/AvsB_sine/res_accuracy_minus_chance_cth21+tlrc'[0]' \
cth22	$top_dir/group/MVPA/AvsB_sine/res_accuracy_minus_chance_cth22+tlrc'[0]' \
cth24	$top_dir/group/MVPA/AvsB_sine/res_accuracy_minus_chance_cth24+tlrc'[0]' \
cth25	$top_dir/group/MVPA/AvsB_sine/res_accuracy_minus_chance_cth25+tlrc'[0]' \
cth26	$top_dir/group/MVPA/AvsB_sine/res_accuracy_minus_chance_cth26+tlrc'[0]' \
cth27	$top_dir/group/MVPA/AvsB_sine/res_accuracy_minus_chance_cth27+tlrc'[0]' \
cth28	$top_dir/group/MVPA/AvsB_sine/res_accuracy_minus_chance_cth28+tlrc'[0]' \
cth30	$top_dir/group/MVPA/AvsB_sine/res_accuracy_minus_chance_cth30+tlrc'[0]' \
cth31	$top_dir/group/MVPA/AvsB_sine/res_accuracy_minus_chance_cth31+tlrc'[0]' \
cth32	$top_dir/group/MVPA/AvsB_sine/res_accuracy_minus_chance_cth32+tlrc'[0]' \
cth34	$top_dir/group/MVPA/AvsB_sine/res_accuracy_minus_chance_cth34+tlrc'[0]' \
-prefix $top_dir/group/MVPA/pairedTtest/pairedAvsB -paired \
-mask $top_dir/group/group_mask+tlrc -covariates mvpa_covariates.txt
