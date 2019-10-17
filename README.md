## Overview

This repository contains the behavioral training data, fMRI behavioral task data, and scripts used to conduct all of the analyses found in the manuscript of *"Articulatory vs. abstract category representations for speech in the dorsal stream"*. 

Given the technical challeneges associated with hosting an fMRI dataset like this, all imaging data will be made available upon request. 

### Behavioral Data & Analyses

In the directory **behavioral-training**, you will find the raw data from all of the 26 participants included in the study. 

The naming scheme works as follows: *subject-A0B.csv*, where *A* is the participant's ID and *B* is the testing session (e.g., 101 indicates participant 1, session 1). Each participant has a CSV file that is named *subject-SX03.csv*, which indicates the data from the sine-wave training.

The R script `cthulhu_manuscript_analyses.R` is commented and will allow you to perform each of the analyses in the manuscript, as well as generate figures 3 & 4. 

### fMRI Catch Task Data

In the directory **fMRI-behavioral**, you will find the output from OpenSesame showing the stimuli presented and participants responses during the task. In addition, you will find the scripts used to create the timing files (which will be included pre-generated with the fMRI data) that were used in the fMRI preprocessing.

### fMRI Analysis Scripts

Though we do not have the fMRI data itself available here, we have made our preprocessing, MVPA, and group level analysis scripts available in the directory **fMRI-scripts**. 