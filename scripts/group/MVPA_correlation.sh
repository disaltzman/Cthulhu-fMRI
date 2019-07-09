#!/bin/bash -f

top_dir=/Volumes/netapp/Myerslab/Dave/Cthulhu/data

# vowel

3dbucket -prefix $top_dir/group/MVPA/AvsB_vowel/all_vowel_decodings \
$top_dir/group/MVPA/AvsB_vowel/res_accuracy_minus_chance_cth*_blurred+tlrc.HEAD

3dTcorr1D -mask $top_dir/group/group_mask+tlrc -prefix $top_dir/group/MVPA/AvsB_vowel/corr_vowel_dprime \
$top_dir/group/MVPA/AvsB_vowel/all_vowel_decodings+tlrc \
vowel_correlations.txt[1]{0..$}


3dTcorr1D -mask $top_dir/group/group_mask+tlrc -prefix $top_dir/group/MVPA/AvsB_vowel/corr_vowel_d3training \
$top_dir/group/MVPA/AvsB_vowel/all_vowel_decodings+tlrc \
$top_dir/group/MVPA/AvsB_vowel/vowel_correlations.txt[2]{0..$}

# sine

3dbucket -prefix $top_dir/group/MVPA/AvsB_sine/all_sine_decodings \
$top_dir/group/MVPA/AvsB_sine/res_accuracy_minus_chance_cth*_blurred+tlrc.HEAD