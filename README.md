# Cthulhu fMRI Subject Processing Pipeline

## Univariate
### Step 1

Download DICOM files from BIRC server

### Step 2

Rename files, create _MP_ and _briks_ folders, and run `cthulhu_pre_preprocessing.sh`

### Step 3

Take `.csv` output from fMRI OpenSesame file and add a column called _timing_. Fill this column in with starting at the first run with the time _1.285_ continuing to _319.285_. Repeat for each block.

### Step 4

Use the `condensend_timing_script.R` to create timing files for the subject. It should create ten `.txt` files in total.

Then run `create_individ_run_timing.sh` to create individual run timing files for each of the 10 regressors. These will get used in the MVPA preprocessing.

### Step 5

Run the script `cthulhu_preprocessing_with_FA.sh` to complete univariate preprocessing for the subject. 

## MVPA

### Step 1
Using the timing files created in Step 4 of the univariate preprocessing, run the script `cthulhu_mvpa_preprocessing_Mumford.sh` to complete MVPA preprocessing using `3dLSS` instead of `3dDeconvolve` to estimate beta weights.

### Step 2
Using `MATLAB`, run various TDT decoding scripts (e.g., `decoding_cthulhu_mumford`) to get subject-level classsification maps. Nothing should need to be changed in these scripts other than the subject number.