#!/bin/csh -f
# Data reconstruction and housekeeping script
# Creates 3D volume from MP data and a 3d+time volume from EP data, both using to3d
# Deobliques data using 3dWarp
# Algins MP to EP data using align_epi_anat.py

#set dir below to the directory where the data live. 
#Set slices to the number of slices in the EPI volume
#Set volumes to the number of volumes acquired per run
#Set TR to the total length of the TR (scan time PLUS silent time)
#this script assumes that every EP dataset is the same length

set dir = /Volumes/netapp/MyersLab/Dave/Cthulhu/data 
set slices = 52
set volumes = 161
set TR = 2000

foreach subject (cth10 cth11)
foreach run (1 2 3 4 5 6 7 8 9 10)

cd ${dir}/${subject}/MP/

echo "Reconstructing MP data for "${subject}

to3d -prefix ${subject}_MP *

echo "Deobliquing MP data for "${subject}

3dWarp -deoblique -prefix ${subject}_MP_DO ${subject}_MP+orig 

mv ${subject}_MP* ../briks/

cd ${dir}/${subject}/EP${run}

echo "Reconstructing EP data for "${subject} "run" ${run}

to3d -prefix ${subject}_EP${run} -time:zt ${slices} ${volumes} ${TR} alt+z *

echo "Deobliquing EP data for "${subject} "run" ${run}

3dWarp -deoblique -prefix ${subject}_EP${run}_DO ${subject}_EP${run}+orig

mv ${subject}_EP* ../briks/

echo "Aligning MP data to EP data using align_epi_anat.py "

end

cd ${dir}/${subject}/briks

align_epi_anat.py -partial_axial \
-anat ${subject}_MP_DO+orig -epi ${subject}_EP1_DO+orig -epi_base 0 \

end