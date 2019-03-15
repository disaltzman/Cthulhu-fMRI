#!/bin/tcsh -f

# set directory
set top_dir = /Volumes/netapp/Myerslab/Dave/Cthulhu/data
# paired T-test between AvsB vowel and AvsB sine
3dttest++ -setA $top_dir/group/MVPA/AvsB_vowel/res_accuracy_minus_chance* \
-setB $top_dir/group/MVPA/AvsB_sine/res_accuracy_minus_chance* \
-prefix $top_dir/group/MVPA/pairedTtest/pairedAvsB -paired
