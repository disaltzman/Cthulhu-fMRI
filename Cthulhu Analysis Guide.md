#Cthulhu Analysis Guide ##

## Univariate fMRI
	
***ANOVA***
	
ANOVA (`3dANOVA`) compares peak activation at the group level for following conditiions:

1. **Main effect** of continuum step (1, 3, 5, & 7)
2. **Main effect** of sound type (natural vs sine)
3. **Interaction** between continuum step and sound type

Also looks at the following contrasts:

1. **Natural - Sine** - looking at speech sensitive regions
2. **Boundary - Endpoint** - should show greater activation in frontal areas for boundary
2. **Boundary - Endpoint** (vowel)
3. **Boundary - Endpoint** (sine)

The ANOVA acts as a sanity check to ensure that fMRI data and subjects are behaving as expected (activation in temporal lobe for sounds, etc).

***LME***

Linear mixed effects model (`3dLME`) serves as compliment to ANOVA but allows for us to use covariates from behavioral data to contrain results.

*Current LME analysis*:
`VowelvsSine-accuracy` - looking at what brain regions show greater activation for vowels after accounting for accuracy at level 3 in session 3's training.

*Potential LME analyses*:

`VowelvsSine-dprime` - using d' from 	discrimination performance

`BoundaryvsSine-dprime`

`AvsB-dprime`

`AvsB-slope` - using slope of participant's categorization function, more categorical people might show larger separation between categories

## Multivariate fMRI

***Searchlight MVPA decoding***

Leave-one-run-out cross-validated design in `The Decoding Toolbox`, searchlight looks for clusters in the brain where different patterns in activation can above-chance predict which conditon is being presented. Currently looking at the following contrasts:

1. **AvsB - Vowel** - searchlight identifies what patterns of activation classify /i/ vs /y/ WITHOUT accounting for subject-specific category boundaries
2. **AvsB - Sine** - "  " but for sinewave tokens
3. **SvsV** - searchlight identifies which what patterns of activation classify sine tokens from vowel tokens - used as sanity check

***Group level MVPA analysis***

T-test's (`3dttest++`) used to test accuracy-chance maps against 0. Current T-tests:

1. **AvsB - Vowel**
2. **AvsB - Sine**
3. **Paired T-test: AvsB Vowel-Sine** - looks at what regions are responsible for classifying category membership independent of whether it was natural or sine

***Potential MVPA Analyses***

1. Using individual subject boundaries to determine which tokens fit into which categories - step 3 could be an /y/ for some people but an /i/ for others - likely lowering accuracy by not acccounting for this
2. Use various behavioral measures as covariates in `3dttest++`
3. Targeted ROI's?

## Behavioral 

### Discrimination
---
**Mixed effects model on % accuracy for natural discrimination tasks:**

`glmer(correct_response ~ block.session*discrim.token + (1|subject2)`

*correct_response* - binary variable coded as 0 or 1 if subject answered correctly

*block.session* - variable to code each pre-test and post-test seperately to form continuous predictor

```
block.session1 = pre-test session 1 
block.session2 = post-test session 1 
block.session3 = pre-test session 2
block.session4 = post-test session 2
block.session5 = pre-test session 3
block.session6 = post-test session 3 
```

*discrim.token* - variable for each discrimination token

```
discrim.token1 = 1-3
discrim.token2 = 2-4
discrim.token3 = 3-5
discrim.token4 = 4-6
discrim.token5 = 5-7
```

**ANOVA on discrimination d'**

ANOVA to analyze d' scores as mixed effects model can only use by-trial data. Plan to add variables of interest like slope of categorization function as IV as well.

```
dprime_anova <- ezANOVA(
data=dprime.anova.data
, dv = .(dprime)
, wid = .(subject2)
, within = .(session,slope)
)
```

### Phonetic Categorization

### Training

**Mixed effects model on % accuracy for training tasks:**

`glmer(correct_response ~ block*session*trial_num + (level*session|subject2)`

*block* - within-subjects variable that codes for which level of training

*session* - within-subjects variable that codes for session number

*trial_num* - between-subjects continuous variable reflecting how many trials overall the person completed in training




	
	