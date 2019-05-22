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

The ANOVA acts as a sanity check to ensure that fMRI data and subjects are behaving as expected (activation in temporal lobe for sounds, etc). ANOVA results in line with expectation, stronger bilateral activation for sinewave tokens, however greater activation for endpoints than boundary tokens.

***LME***

Linear mixed effects model (`3dLME`) serves as compliment to ANOVA but allows for us to use covariates from behavioral data to constrain results.

Contrasts:
<p>
`VowelvsSine-accuracy` - looking at what brain regions show greater activation for vowels after accounting for accuracy at level 3 in session 3's training.

`VowelvsSine-dprime` - looking at what brain regions show greater activation for vowels after accounting for peak d' score from that participant.

`BoundaryVsEndpoint_vowel-accuracy`- looking at what brain regions show greater activation for vowel boundary tokens (steps 3 & 5) than endpoint tokens (steps 1 & 3) after accounting for accuracy at level 3 in session 3's training.

`BoundaryVsEndpoint_sine-accuracy`- looking at what brain regions show greater activation for sine boundary tokens (steps 3 & 5) than endpoint tokens (steps 1 & 3) after accounting for accuracy at level 3 in session 3's training.

Contrasts holding covariates fixed did not end up being very informative.

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
3. **Paired T-test: AvsB Vowel-Sine** - looks for regions that can significanly discriminate between category A vs B irrespective of sound type.

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

Use mixed effects model (`glmer`) to look at how phonetic categorization changes over the course of the three sessions.

```
PC.model1 <- glmer(resp1 ~ step*session + 
(step:session||subject2) + 
(step||subject2) + (session||subject2)                 
```
*step* - continuous variable that codes for continuum step
*session* - categorixal variable that codes for session number

### Training

**Mixed effects model on % accuracy for training tasks:**

`glmer(correct_response ~ block*session*trial_num + (block:session|subject2)`

*block* - within-subjects variable that codes for which level of training

*session* - within-subjects variable that codes for session number




	
	