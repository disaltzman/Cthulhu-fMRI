# Cthulhu fMRI Analysis Log

## Univariate

**2/1/19**
	
All univariate analyses implemented programmatically and confirmed to work (`3dLME` and `3dANOVA`)

## Multivariate

**2/1/19**
	
Preprocessing pipeline using `3dLSS` (per Mumford et al. 2012) is in place and works. Subjects without false alarms can be run through TDT pipeline for decoding.

**Issue: dealing with false alarms**
	
1.	*Preprocessing* – preprocessing script assembles betas from `3dLSS` into runs based on assumption that there are 15 trials per stimulus type. If false alarms are separated out, runs are not reassembled properly. 
2.	*Decoding* – Not getting the right betas because run 10 is always the one missing events 

**Solutions:**

1. *Use individual trials* – Extract each sub-brick and make it a separate BRIK/HEAD file.

	* Way too computationally intensive (10 hours per subject to extract betas using `3dTcat`)

	* TDT bugs – Got the regressor names correct by modifying the `get_design_afni.m` file, but does not load data properly. Will probably be too computationally intensive as well

2.	*Leave false alarms in during preprocessing, then remove them by hand after*
	* Easy to implement preprocessing, but room for error
	* TDT extracted wrong number of regressor names – probably can fix this

3. **Redo preprocessing altogether doing everything (including 3dLSS) by run, so that runs never need to be reassembled**

**2/5/19**

Modified preprocessing script to do `3dLSS` by run, confirmed working with subject 2. 

Encountered issue in TDT in which the script to extract regressor names, `design_from_afni.m`, is onlly designed to work with runs with identical regressor names. Participants with false alarms caused an issue as some trials are missing from certain runs. Wrote a new MAATLAB script `design_from_afni_custom.m` that instead looks through each run and extracts the labels, instead of extrapolating from the first run. 



