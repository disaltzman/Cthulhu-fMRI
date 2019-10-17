#!/bin/tcsh -f

set top_dir = /Volumes/netapp/Research/Myerslab/Dave/Cthulhu/data

# AvsB Vowel 0.025 - 3 clusters
# AvsB Vowel 0.01 - 2 clusters

# # # group level
# foreach clust (1 2)
# 	echo "Average values for Cluster ${clust}" >>! $top_dir/group/MVPA/AvsB_vowel/AvsB_vowel_0.01_ave.txt
# 	3dmaskave -mask $top_dir/group/MVPA/AvsB_vowel/VowelAvsB_0.01_73vox_Corr_0.05_mask+tlrc -quiet \
# 	-mrange ${clust} ${clust} $top_dir/group/MVPA/AvsB_vowel/AvsB_vowel_ttest+tlrc'[0]' \
# 	>>! $top_dir/group/MVPA/AvsB_vowel/AvsB_vowel_0.01_ave.txt
# end

# touch $top_dir/group/MVPA/AvsB_vowel/AvsB_vowel_0.025_ave.txt

# foreach clust (1 2 3)
# 	echo "Average values for Cluster ${clust}" >>! $top_dir/group/MVPA/AvsB_vowel/AvsB_vowel_0.025_ave.txt
# 	3dmaskave -mask $top_dir/group/MVPA/AvsB_vowel/VowelAvsB_0.025_149_Corr_0.05_mask+tlrc -quiet \
# 	-mrange ${clust} ${clust} $top_dir/group/MVPA/AvsB_vowel/AvsB_vowel_ttest+tlrc'[0]' \
# 	>>! $top_dir/group/MVPA/AvsB_vowel/AvsB_vowel_0.025_ave.txt
# end

# # # subject level
# foreach subj (1 2 3 6 8 9 10 11 12 14 15 16 17 18 20 21 22 24 25 26 27 28 30 31 32 34)
# 	foreach clust (1 2)
# 		echo "Average values for Cluster ${clust}" >>! $top_dir/group/MVPA/AvsB_vowel/AvsB_vowel_0.01_ave_subj${subj}.txt
# 		3dmaskave -mask $top_dir/group/MVPA/AvsB_vowel/VowelAvsB_0.01_73vox_Corr_0.05_mask+tlrc -quiet \
# 		-mrange ${clust} ${clust} $top_dir/group/MVPA/AvsB_vowel/res_accuracy_minus_chance_cth${subj}_blurred+tlrc \
# 		>>! $top_dir/group/MVPA/AvsB_vowel/AvsB_vowel_0.01_ave_subj${subj}.txt
# 	end
# end

mkdir $top_dir/group/MVPA/AvsB_vowel/subj_ave_0.025/

foreach subj (01 02 03 06 08 09 10 11 12 14 15 16 17 18 20 21 22 24 25 26 27 28 30 31 32 34)
	touch $top_dir/group/MVPA/AvsB_vowel/subj_ave_0.025/AvsB_vowel_0.025_ave_subj${subj}.txt 
	foreach clust (1 2 3)
		echo "Average values for Cluster ${clust}" >>! $top_dir/group/MVPA/AvsB_vowel/subj_ave_0.025/AvsB_vowel_0.025_ave_subj${subj}.txt
		3dmaskave -mask $top_dir/group/MVPA/AvsB_vowel/VowelAvsB_0.025_149_Corr_0.05_mask+tlrc -quiet \
		-mrange ${clust} ${clust} $top_dir/group/MVPA/AvsB_vowel/res_accuracy_minus_chance_cth${subj}_blurred+tlrc \
		>>! $top_dir/group/MVPA/AvsB_vowel/subj_ave_0.025/AvsB_vowel_0.025_ave_subj${subj}.txt
	end
end

# # AvsB-sine 0.025 - 2 clusters

# # group level
# foreach clust (1 2)
# 	echo "Average values for Cluster ${clust}" >>! $top_dir/group/MVPA/AvsB_sine/AvsB_sine_0.025_ave.txt
# 	3dmaskave -mask $top_dir/group/MVPA/AvsB_sine/SineAvsB_0.025_73vox_UNCORR_mask+tlrc -quiet \
# 	-mrange ${clust} ${clust} $top_dir/group/MVPA/AvsB_sine/AvsB_sine_ttest+tlrc'[1]' \
# 	>>! $top_dir/group/MVPA/AvsB_sine/AvsB_sine_0.025_ave.txt
# end


# # subject level
# foreach subj (1 2 3 6 8 9 10 11 12 14 15 16 17 18 20 21 22 24 25 26 27 28 30 31 32 34)
# 	foreach clust (1 2)
# 		echo "Average values for Cluster ${clust}" >>! $top_dir/group/MVPA/AvsB_sine/AvsB_sine_0.025_ave_subj${subj}.txt
# 		3dmaskave -mask $top_dir/group/MVPA/AvsB_sine/SineAvsB_0.025_73vox_UNCORR_mask+tlrc -quiet \
# 		-mrange ${clust} ${clust} $top_dir/group/MVPA/AvsB_sine/res_accuracy_minus_chance_cth${subj}_blurred+tlrc \
# 		>>! $top_dir/group/MVPA/AvsB_sine/AvsB_sine_0.025_ave_subj${subj}.txt
# 	end
# end



# # AvsB-paired 0.025 - 8
# # AvsB-paired 0.01 - 6

# # group level

# foreach clust (1 2 3 4 5 6)
# 	echo "Average values for Cluster ${clust}" >>! $top_dir/group/MVPA/pairedTtest/AvsB_paired_0.01_ave.txt
# 	3dmaskave -mask $top_dir/group/MVPA/pairedTtest/AvsB_paired_0.01_73vox_corr_0.05_mask_mask+tlrc -quiet \
# 	-mrange ${clust} ${clust} $top_dir/group/MVPA/pairedTtest/pairedAvsB+tlrc'[1]' >>! $top_dir/group/MVPA/pairedTtest/AvsB_paired_0.01_ave.txt
# end

# foreach clust (1 2 3 4 5 6 7 8)
# 	echo "Average values for Cluster ${clust}" >>! $top_dir/group/MVPA/pairedTtest/AvsB_paired_0.025_ave.txt
# 	3dmaskave -mask $top_dir/group/MVPA/pairedTtest/AvsB_paired_0.025_149vox_corr_0.05_mask_mask+tlrc -quiet \
# 	-mrange ${clust} ${clust} $top_dir/group/MVPA/pairedTtest/pairedAvsB+tlrc'[1]' >>! $top_dir/group/MVPA/pairedTtest/AvsB_paired_0.025_ave.txt
# end

# Avs-ROI - 0.025 - 3

# # group level

# foreach clust (1 2 3)
# 	echo "Average values for Cluster ${clust}" >>! $top_dir/group/MVPA/AvsB_vowel-ROI/AvsB_vowel-ROI_0.025_ave.txt
# 	3dmaskave -mask $top_dir/group/MVPA/AvsB_vowel-ROI/AvsB_vowel-ROI_0.025_149vox_corr_0.05_mask+tlrc -quiet \
# 	-mrange ${clust} ${clust} $top_dir/group/MVPA/AvsB_vowel-ROI/AvsB_vowel-ROI_ttest+tlrc'[1]' >>! $top_dir/group/MVPA/AvsB_vowel-ROI/AvsB_vowel-ROI_0.025_ave.txt
# end

