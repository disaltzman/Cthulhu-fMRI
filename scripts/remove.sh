#!/bin/tcsh -f

set top_dir = /Volumes/netapp/MyersLab/Dave/Cthulhu/data 

foreach subj (1)

cd $top_dir/cth${subj}
rm -r cth${subj}.preproc_mvpa

end
