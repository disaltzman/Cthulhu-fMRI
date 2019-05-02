#!/bin/tcsh -f

#  for sine, "[4]=sinestep1; "[7]=sinestep3; "[10]=sinestep5; "[13]=sinestep7;
#  for vowel, "[16]=vowelstep1; "[19]=vowelstep3; "[22]=vowelstep5; "[25]=vowelstep7;


set top_dir = /Volumes/netapp/Myerslab/Dave/Cthulhu/data 
cd top_dir

3dLME \
-prefix $top_dir/group/LME/Cthulhu_LME \
-mask $top_dir/group/group_mask+tlrc \
-model "SoundType*Step*Day3Accuracy*peak.discrim" \
-qVars "Day3Accuracy,peak.discrim" \
-ranEff "~1" \
-jobs 3 \
-num_glt 4 \
-gltLabel 1 "VowelvsSine-accuracy" \
-gltCode 1 'SoundType : 1*Vowel -1*Sine Day3Accuracy :' \
-gltLabel 2 "BoundaryVsEndpoint_vowel-accuracy" \
-gltCode 2 'Step : 0.5*step1 -0.5*step3 -0.5*step5 0.5*step7 SoundType : 1*Vowel Day3Accuracy :' \
-gltLabel 3 "BoundaryVsEndpoint_sine-accuracy" \
-gltCode 3 'Step : 0.5*step1 -0.5*step3 -0.5*step5 0.5*step7 SoundType : 1*Sine Day3Accuracy :' \
-gltLabel 4 "VowelvsSine-dprime" \
-gltCode 4 'SoundType : 1*Vowel -1*Sine peak.discrim :' \
-dataTable \
Subj	peak.discrim	Day3Accuracy	SoundType	Step	InputFile \
cth1	3.400560772	1	Vowel	step1	cth1/cth1.preproc/'stats.1+tlrc[16]' \
cth1	3.400560772	1	Vowel	step3	cth1/cth1.preproc/'stats.1+tlrc[19]' \
cth1	3.400560772	1	Vowel	step5	cth1/cth1.preproc/'stats.1+tlrc[22]' \
cth1	3.400560772	1	Vowel	step7	cth1/cth1.preproc/'stats.1+tlrc[25]' \
cth1	3.400560772	1	Sine	step1	cth1/cth1.preproc/'stats.1+tlrc[4]' \
cth1	3.400560772	1	Sine	step3	cth1/cth1.preproc/'stats.1+tlrc[7]' \
cth1	3.400560772	1	Sine	step5	cth1/cth1.preproc/'stats.1+tlrc[10]' \
cth1	3.400560772	1	Sine	step7	cth1/cth1.preproc/'stats.1+tlrc[13]' \
cth10	0.697511391	0.5801105	Vowel	step1	cth10/cth10.preproc/'stats.10+tlrc[16]' \
cth10	0.697511391	0.5801105	Vowel	step3	cth10/cth10.preproc/'stats.10+tlrc[19]' \
cth10	0.697511391	0.5801105	Vowel	step5	cth10/cth10.preproc/'stats.10+tlrc[22]' \
cth10	0.697511391	0.5801105	Vowel	step7	cth10/cth10.preproc/'stats.10+tlrc[25]' \
cth10	0.697511391	0.5801105	Sine	step1	cth10/cth10.preproc/'stats.10+tlrc[4]' \
cth10	0.697511391	0.5801105	Sine	step3	cth10/cth10.preproc/'stats.10+tlrc[7]' \
cth10	0.697511391	0.5801105	Sine	step5	cth10/cth10.preproc/'stats.10+tlrc[10]' \
cth10	0.697511391	0.5801105	Sine	step7	cth10/cth10.preproc/'stats.10+tlrc[13]' \
cth11	4.652695748	0.9833333	Vowel	step1	cth11/cth11.preproc/'stats.11+tlrc[16]' \
cth11	4.652695748	0.9833333	Vowel	step3	cth11/cth11.preproc/'stats.11+tlrc[19]' \
cth11	4.652695748	0.9833333	Vowel	step5	cth11/cth11.preproc/'stats.11+tlrc[22]' \
cth11	4.652695748	0.9833333	Vowel	step7	cth11/cth11.preproc/'stats.11+tlrc[25]' \
cth11	4.652695748	0.9833333	Sine	step1	cth11/cth11.preproc/'stats.11+tlrc[4]' \
cth11	4.652695748	0.9833333	Sine	step3	cth11/cth11.preproc/'stats.11+tlrc[7]' \
cth11	4.652695748	0.9833333	Sine	step5	cth11/cth11.preproc/'stats.11+tlrc[10]' \
cth11	4.652695748	0.9833333	Sine	step7	cth11/cth11.preproc/'stats.11+tlrc[13]' \
cth12	1.105293619	0.8181818	Vowel	step1	cth12/cth12.preproc/'stats.12+tlrc[16]' \
cth12	1.105293619	0.8181818	Vowel	step3	cth12/cth12.preproc/'stats.12+tlrc[19]' \
cth12	1.105293619	0.8181818	Vowel	step5	cth12/cth12.preproc/'stats.12+tlrc[22]' \
cth12	1.105293619	0.8181818	Vowel	step7	cth12/cth12.preproc/'stats.12+tlrc[25]' \
cth12	1.105293619	0.8181818	Sine	step1	cth12/cth12.preproc/'stats.12+tlrc[4]' \
cth12	1.105293619	0.8181818	Sine	step3	cth12/cth12.preproc/'stats.12+tlrc[7]' \
cth12	1.105293619	0.8181818	Sine	step5	cth12/cth12.preproc/'stats.12+tlrc[10]' \
cth12	1.105293619	0.8181818	Sine	step7	cth12/cth12.preproc/'stats.12+tlrc[13]' \
cth14	1.565061854	0.875	Vowel	step1	cth14/cth14.preproc/'stats.14+tlrc[16]' \
cth14	1.565061854	0.875	Vowel	step3	cth14/cth14.preproc/'stats.14+tlrc[19]' \
cth14	1.565061854	0.875	Vowel	step5	cth14/cth14.preproc/'stats.14+tlrc[22]' \
cth14	1.565061854	0.875	Vowel	step7	cth14/cth14.preproc/'stats.14+tlrc[25]' \
cth14	1.565061854	0.875	Sine	step1	cth14/cth14.preproc/'stats.14+tlrc[4]' \
cth14	1.565061854	0.875	Sine	step3	cth14/cth14.preproc/'stats.14+tlrc[7]' \
cth14	1.565061854	0.875	Sine	step5	cth14/cth14.preproc/'stats.14+tlrc[10]' \
cth14	1.565061854	0.875	Sine	step7	cth14/cth14.preproc/'stats.14+tlrc[13]' \
cth15	0.624014441	0.7348066	Vowel	step1	cth15/cth15.preproc/'stats.15+tlrc[16]' \
cth15	0.624014441	0.7348066	Vowel	step3	cth15/cth15.preproc/'stats.15+tlrc[19]' \
cth15	0.624014441	0.7348066	Vowel	step5	cth15/cth15.preproc/'stats.15+tlrc[22]' \
cth15	0.624014441	0.7348066	Vowel	step7	cth15/cth15.preproc/'stats.15+tlrc[25]' \
cth15	0.624014441	0.7348066	Sine	step1	cth15/cth15.preproc/'stats.15+tlrc[4]' \
cth15	0.624014441	0.7348066	Sine	step3	cth15/cth15.preproc/'stats.15+tlrc[7]' \
cth15	0.624014441	0.7348066	Sine	step5	cth15/cth15.preproc/'stats.15+tlrc[10]' \
cth15	0.624014441	0.7348066	Sine	step7	cth15/cth15.preproc/'stats.15+tlrc[13]' \
cth16	2.440533168	1	Vowel	step1	cth16/cth16.preproc/'stats.16+tlrc[16]' \
cth16	2.440533168	1	Vowel	step3	cth16/cth16.preproc/'stats.16+tlrc[19]' \
cth16	2.440533168	1	Vowel	step5	cth16/cth16.preproc/'stats.16+tlrc[22]' \
cth16	2.440533168	1	Vowel	step7	cth16/cth16.preproc/'stats.16+tlrc[25]' \
cth16	2.440533168	1	Sine	step1	cth16/cth16.preproc/'stats.16+tlrc[4]' \
cth16	2.440533168	1	Sine	step3	cth16/cth16.preproc/'stats.16+tlrc[7]' \
cth16	2.440533168	1	Sine	step5	cth16/cth16.preproc/'stats.16+tlrc[10]' \
cth16	2.440533168	1	Sine	step7	cth16/cth16.preproc/'stats.16+tlrc[13]' \
cth17	2.930933221	0.875	Vowel	step1	cth17/cth17.preproc/'stats.17+tlrc[16]' \
cth17	2.930933221	0.875	Vowel	step3	cth17/cth17.preproc/'stats.17+tlrc[19]' \
cth17	2.930933221	0.875	Vowel	step5	cth17/cth17.preproc/'stats.17+tlrc[22]' \
cth17	2.930933221	0.875	Vowel	step7	cth17/cth17.preproc/'stats.17+tlrc[25]' \
cth17	2.930933221	0.875	Sine	step1	cth17/cth17.preproc/'stats.17+tlrc[4]' \
cth17	2.930933221	0.875	Sine	step3	cth17/cth17.preproc/'stats.17+tlrc[7]' \
cth17	2.930933221	0.875	Sine	step5	cth17/cth17.preproc/'stats.17+tlrc[10]' \
cth17	2.930933221	0.875	Sine	step7	cth17/cth17.preproc/'stats.17+tlrc[13]' \
cth18	1.807966857	0.8232044	Vowel	step1	cth18/cth18.preproc/'stats.18+tlrc[16]' \
cth18	1.807966857	0.8232044	Vowel	step3	cth18/cth18.preproc/'stats.18+tlrc[19]' \
cth18	1.807966857	0.8232044	Vowel	step5	cth18/cth18.preproc/'stats.18+tlrc[22]' \
cth18	1.807966857	0.8232044	Vowel	step7	cth18/cth18.preproc/'stats.18+tlrc[25]' \
cth18	1.807966857	0.8232044	Sine	step1	cth18/cth18.preproc/'stats.18+tlrc[4]' \
cth18	1.807966857	0.8232044	Sine	step3	cth18/cth18.preproc/'stats.18+tlrc[7]' \
cth18	1.807966857	0.8232044	Sine	step5	cth18/cth18.preproc/'stats.18+tlrc[10]' \
cth18	1.807966857	0.8232044	Sine	step7	cth18/cth18.preproc/'stats.18+tlrc[13]' \
cth2	2.431981298	0.8066298	Vowel	step1	cth2/cth2.preproc/'stats.2+tlrc[16]' \
cth2	2.431981298	0.8066298	Vowel	step3	cth2/cth2.preproc/'stats.2+tlrc[19]' \
cth2	2.431981298	0.8066298	Vowel	step5	cth2/cth2.preproc/'stats.2+tlrc[22]' \
cth2	2.431981298	0.8066298	Vowel	step7	cth2/cth2.preproc/'stats.2+tlrc[25]' \
cth2	2.431981298	0.8066298	Sine	step1	cth2/cth2.preproc/'stats.2+tlrc[4]' \
cth2	2.431981298	0.8066298	Sine	step3	cth2/cth2.preproc/'stats.2+tlrc[7]' \
cth2	2.431981298	0.8066298	Sine	step5	cth2/cth2.preproc/'stats.2+tlrc[10]' \
cth2	2.431981298	0.8066298	Sine	step7	cth2/cth2.preproc/'stats.2+tlrc[13]' \
cth20	2.67510357	0.9166667	Vowel	step1	cth20/cth20.preproc/'stats.20+tlrc[16]' \
cth20	2.67510357	0.9166667	Vowel	step3	cth20/cth20.preproc/'stats.20+tlrc[19]' \
cth20	2.67510357	0.9166667	Vowel	step5	cth20/cth20.preproc/'stats.20+tlrc[22]' \
cth20	2.67510357	0.9166667	Vowel	step7	cth20/cth20.preproc/'stats.20+tlrc[25]' \
cth20	2.67510357	0.9166667	Sine	step1	cth20/cth20.preproc/'stats.20+tlrc[4]' \
cth20	2.67510357	0.9166667	Sine	step3	cth20/cth20.preproc/'stats.20+tlrc[7]' \
cth20	2.67510357	0.9166667	Sine	step5	cth20/cth20.preproc/'stats.20+tlrc[10]' \
cth20	2.67510357	0.9166667	Sine	step7	cth20/cth20.preproc/'stats.20+tlrc[13]' \
cth21	3.234805743	0.9666667	Vowel	step1	cth21/cth21.preproc/'stats.21+tlrc[16]' \
cth21	3.234805743	0.9666667	Vowel	step3	cth21/cth21.preproc/'stats.21+tlrc[19]' \
cth21	3.234805743	0.9666667	Vowel	step5	cth21/cth21.preproc/'stats.21+tlrc[22]' \
cth21	3.234805743	0.9666667	Vowel	step7	cth21/cth21.preproc/'stats.21+tlrc[25]' \
cth21	3.234805743	0.9666667	Sine	step1	cth21/cth21.preproc/'stats.21+tlrc[4]' \
cth21	3.234805743	0.9666667	Sine	step3	cth21/cth21.preproc/'stats.21+tlrc[7]' \
cth21	3.234805743	0.9666667	Sine	step5	cth21/cth21.preproc/'stats.21+tlrc[10]' \
cth21	3.234805743	0.9666667	Sine	step7	cth21/cth21.preproc/'stats.21+tlrc[13]' \
cth22	1.754647546	0.7900552	Vowel	step1	cth22/cth22.preproc/'stats.22+tlrc[16]' \
cth22	1.754647546	0.7900552	Vowel	step3	cth22/cth22.preproc/'stats.22+tlrc[19]' \
cth22	1.754647546	0.7900552	Vowel	step5	cth22/cth22.preproc/'stats.22+tlrc[22]' \
cth22	1.754647546	0.7900552	Vowel	step7	cth22/cth22.preproc/'stats.22+tlrc[25]' \
cth22	1.754647546	0.7900552	Sine	step1	cth22/cth22.preproc/'stats.22+tlrc[4]' \
cth22	1.754647546	0.7900552	Sine	step3	cth22/cth22.preproc/'stats.22+tlrc[7]' \
cth22	1.754647546	0.7900552	Sine	step5	cth22/cth22.preproc/'stats.22+tlrc[10]' \
cth22	1.754647546	0.7900552	Sine	step7	cth22/cth22.preproc/'stats.22+tlrc[13]' \
cth24	0.718770641	0.5359116	Vowel	step1	cth24/cth24.preproc/'stats.24+tlrc[16]' \
cth24	0.718770641	0.5359116	Vowel	step3	cth24/cth24.preproc/'stats.24+tlrc[19]' \
cth24	0.718770641	0.5359116	Vowel	step5	cth24/cth24.preproc/'stats.24+tlrc[22]' \
cth24	0.718770641	0.5359116	Vowel	step7	cth24/cth24.preproc/'stats.24+tlrc[25]' \
cth24	0.718770641	0.5359116	Sine	step1	cth24/cth24.preproc/'stats.24+tlrc[4]' \
cth24	0.718770641	0.5359116	Sine	step3	cth24/cth24.preproc/'stats.24+tlrc[7]' \
cth24	0.718770641	0.5359116	Sine	step5	cth24/cth24.preproc/'stats.24+tlrc[10]' \
cth24	0.718770641	0.5359116	Sine	step7	cth24/cth24.preproc/'stats.24+tlrc[13]' \
cth25	2.995840936	0.6850829	Vowel	step1	cth25/cth25.preproc/'stats.25+tlrc[16]' \
cth25	2.995840936	0.6850829	Vowel	step3	cth25/cth25.preproc/'stats.25+tlrc[19]' \
cth25	2.995840936	0.6850829	Vowel	step5	cth25/cth25.preproc/'stats.25+tlrc[22]' \
cth25	2.995840936	0.6850829	Vowel	step7	cth25/cth25.preproc/'stats.25+tlrc[25]' \
cth25	2.995840936	0.6850829	Sine	step1	cth25/cth25.preproc/'stats.25+tlrc[4]' \
cth25	2.995840936	0.6850829	Sine	step3	cth25/cth25.preproc/'stats.25+tlrc[7]' \
cth25	2.995840936	0.6850829	Sine	step5	cth25/cth25.preproc/'stats.25+tlrc[10]' \
cth25	2.995840936	0.6850829	Sine	step7	cth25/cth25.preproc/'stats.25+tlrc[13]' \
cth3	2.402022869	0.968254	Vowel	step1	cth3/cth3.preproc/'stats.3+tlrc[16]' \
cth3	2.402022869	0.968254	Vowel	step3	cth3/cth3.preproc/'stats.3+tlrc[19]' \
cth3	2.402022869	0.968254	Vowel	step5	cth3/cth3.preproc/'stats.3+tlrc[22]' \
cth3	2.402022869	0.968254	Vowel	step7	cth3/cth3.preproc/'stats.3+tlrc[25]' \
cth3	2.402022869	0.968254	Sine	step1	cth3/cth3.preproc/'stats.3+tlrc[4]' \
cth3	2.402022869	0.968254	Sine	step3	cth3/cth3.preproc/'stats.3+tlrc[7]' \
cth3	2.402022869	0.968254	Sine	step5	cth3/cth3.preproc/'stats.3+tlrc[10]' \
cth3	2.402022869	0.968254	Sine	step7	cth3/cth3.preproc/'stats.3+tlrc[13]' \
cth6	1.535103424	0.852459	Vowel	step1	cth6/cth6.preproc/'stats.6+tlrc[16]' \
cth6	1.535103424	0.852459	Vowel	step3	cth6/cth6.preproc/'stats.6+tlrc[19]' \
cth6	1.535103424	0.852459	Vowel	step5	cth6/cth6.preproc/'stats.6+tlrc[22]' \
cth6	1.535103424	0.852459	Vowel	step7	cth6/cth6.preproc/'stats.6+tlrc[25]' \
cth6	1.535103424	0.852459	Sine	step1	cth6/cth6.preproc/'stats.6+tlrc[4]' \
cth6	1.535103424	0.852459	Sine	step3	cth6/cth6.preproc/'stats.6+tlrc[7]' \
cth6	1.535103424	0.852459	Sine	step5	cth6/cth6.preproc/'stats.6+tlrc[10]' \
cth6	1.535103424	0.852459	Sine	step7	cth6/cth6.preproc/'stats.6+tlrc[13]' \
cth8	3.966810126	0.8153846	Vowel	step1	cth8/cth8.preproc/'stats.8+tlrc[16]' \
cth8	3.966810126	0.8153846	Vowel	step3	cth8/cth8.preproc/'stats.8+tlrc[19]' \
cth8	3.966810126	0.8153846	Vowel	step5	cth8/cth8.preproc/'stats.8+tlrc[22]' \
cth8	3.966810126	0.8153846	Vowel	step7	cth8/cth8.preproc/'stats.8+tlrc[25]' \
cth8	3.966810126	0.8153846	Sine	step1	cth8/cth8.preproc/'stats.8+tlrc[4]' \
cth8	3.966810126	0.8153846	Sine	step3	cth8/cth8.preproc/'stats.8+tlrc[7]' \
cth8	3.966810126	0.8153846	Sine	step5	cth8/cth8.preproc/'stats.8+tlrc[10]' \
cth8	3.966810126	0.8153846	Sine	step7	cth8/cth8.preproc/'stats.8+tlrc[13]' \
cth9	3.074206469	0.9193548	Vowel	step1	cth9/cth9.preproc/'stats.9+tlrc[16]' \
cth9	3.074206469	0.9193548	Vowel	step3	cth9/cth9.preproc/'stats.9+tlrc[19]' \
cth9	3.074206469	0.9193548	Vowel	step5	cth9/cth9.preproc/'stats.9+tlrc[22]' \
cth9	3.074206469	0.9193548	Vowel	step7	cth9/cth9.preproc/'stats.9+tlrc[25]' \
cth9	3.074206469	0.9193548	Sine	step1	cth9/cth9.preproc/'stats.9+tlrc[4]' \
cth9	3.074206469	0.9193548	Sine	step3	cth9/cth9.preproc/'stats.9+tlrc[7]' \
cth9	3.074206469	0.9193548	Sine	step5	cth9/cth9.preproc/'stats.9+tlrc[10]' \
cth9	3.074206469	0.9193548	Sine	step7	cth9/cth9.preproc/'stats.9+tlrc[13]' \
cth26	2.764834528	0.9180328	Vowel	step1	cth26/cth26.preproc/'stats.26+tlrc[16]' \
cth26	2.764834528	0.9180328	Vowel	step3	cth26/cth26.preproc/'stats.26+tlrc[19]' \
cth26	2.764834528	0.9180328	Vowel	step5	cth26/cth26.preproc/'stats.26+tlrc[22]' \
cth26	2.764834528	0.9180328	Vowel	step7	cth26/cth26.preproc/'stats.26+tlrc[25]' \
cth26	2.764834528	0.9180328	Sine	step1	cth26/cth26.preproc/'stats.26+tlrc[4]' \
cth26	2.764834528	0.9180328	Sine	step3	cth26/cth26.preproc/'stats.26+tlrc[7]' \
cth26	2.764834528	0.9180328	Sine	step5	cth26/cth26.preproc/'stats.26+tlrc[10]' \
cth26	2.764834528	0.9180328	Sine	step7	cth26/cth26.preproc/'stats.26+tlrc[13]' \
cth27	2.163410751	0.877193	Vowel	step1	cth27/cth27.preproc/'stats.27+tlrc[16]' \
cth27	2.163410751	0.877193	Vowel	step3	cth27/cth27.preproc/'stats.27+tlrc[19]' \
cth27	2.163410751	0.877193	Vowel	step5	cth27/cth27.preproc/'stats.27+tlrc[22]' \
cth27	2.163410751	0.877193	Vowel	step7	cth27/cth27.preproc/'stats.27+tlrc[25]' \
cth27	2.163410751	0.877193	Sine	step1	cth27/cth27.preproc/'stats.27+tlrc[4]' \
cth27	2.163410751	0.877193	Sine	step3	cth27/cth27.preproc/'stats.27+tlrc[7]' \
cth27	2.163410751	0.877193	Sine	step5	cth27/cth27.preproc/'stats.27+tlrc[10]' \
cth27	2.163410751	0.877193	Sine	step7	cth27/cth27.preproc/'stats.27+tlrc[13]' \
cth28	1.077374468	0.828125	Vowel	step1	cth28/cth28.preproc/'stats.28+tlrc[16]' \
cth28	1.077374468	0.828125	Vowel	step3	cth28/cth28.preproc/'stats.28+tlrc[19]' \
cth28	1.077374468	0.828125	Vowel	step5	cth28/cth28.preproc/'stats.28+tlrc[22]' \
cth28	1.077374468	0.828125	Vowel	step7	cth28/cth28.preproc/'stats.28+tlrc[25]' \
cth28	1.077374468	0.828125	Sine	step1	cth28/cth28.preproc/'stats.28+tlrc[4]' \
cth28	1.077374468	0.828125	Sine	step3	cth28/cth28.preproc/'stats.28+tlrc[7]' \
cth28	1.077374468	0.828125	Sine	step5	cth28/cth28.preproc/'stats.28+tlrc[10]' \
cth28	1.077374468	0.828125	Sine	step7	cth28/cth28.preproc/'stats.28+tlrc[13]' \
cth30	4.652695748	0.9833333	Vowel	step1	cth30/cth30.preproc/'stats.30+tlrc[16]' \
cth30	4.652695748	0.9833333	Vowel	step3	cth30/cth30.preproc/'stats.30+tlrc[19]' \
cth30	4.652695748	0.9833333	Vowel	step5	cth30/cth30.preproc/'stats.30+tlrc[22]' \
cth30	4.652695748	0.9833333	Vowel	step7	cth30/cth30.preproc/'stats.30+tlrc[25]' \
cth30	4.652695748	0.9833333	Sine	step1	cth30/cth30.preproc/'stats.30+tlrc[4]' \
cth30	4.652695748	0.9833333	Sine	step3	cth30/cth30.preproc/'stats.30+tlrc[7]' \
cth30	4.652695748	0.9833333	Sine	step5	cth30/cth30.preproc/'stats.30+tlrc[10]' \
cth30	4.652695748	0.9833333	Sine	step7	cth30/cth30.preproc/'stats.30+tlrc[13]' \
cth31	3.423151436	0.9833333	Vowel	step1	cth31/cth31.preproc/'stats.31+tlrc[16]' \
cth31	3.423151436	0.9833333	Vowel	step3	cth31/cth31.preproc/'stats.31+tlrc[19]' \
cth31	3.423151436	0.9833333	Vowel	step5	cth31/cth31.preproc/'stats.31+tlrc[22]' \
cth31	3.423151436	0.9833333	Vowel	step7	cth31/cth31.preproc/'stats.31+tlrc[25]' \
cth31	3.423151436	0.9833333	Sine	step1	cth31/cth31.preproc/'stats.31+tlrc[4]' \
cth31	3.423151436	0.9833333	Sine	step3	cth31/cth31.preproc/'stats.31+tlrc[7]' \
cth31	3.423151436	0.9833333	Sine	step5	cth31/cth31.preproc/'stats.31+tlrc[10]' \
cth31	3.423151436	0.9833333	Sine	step7	cth31/cth31.preproc/'stats.31+tlrc[13]' \
cth32	0.559702173	0.6961326	Vowel	step1	cth32/cth32.preproc/'stats.32+tlrc[16]' \
cth32	0.559702173	0.6961326	Vowel	step3	cth32/cth32.preproc/'stats.32+tlrc[19]' \
cth32	0.559702173	0.6961326	Vowel	step5	cth32/cth32.preproc/'stats.32+tlrc[22]' \
cth32	0.559702173	0.6961326	Vowel	step7	cth32/cth32.preproc/'stats.32+tlrc[25]' \
cth32	0.559702173	0.6961326	Sine	step1	cth32/cth32.preproc/'stats.32+tlrc[4]' \
cth32	0.559702173	0.6961326	Sine	step3	cth32/cth32.preproc/'stats.32+tlrc[7]' \
cth32	0.559702173	0.6961326	Sine	step5	cth32/cth32.preproc/'stats.32+tlrc[10]' \
cth32	0.559702173	0.6961326	Sine	step7	cth32/cth32.preproc/'stats.32+tlrc[13]' \
cth34	1.096803562	0.7458564	Vowel	step1	cth34/cth34.preproc/'stats.34+tlrc[16]' \
cth34	1.096803562	0.7458564	Vowel	step3	cth34/cth34.preproc/'stats.34+tlrc[19]' \
cth34	1.096803562	0.7458564	Vowel	step5	cth34/cth34.preproc/'stats.34+tlrc[22]' \
cth34	1.096803562	0.7458564	Vowel	step7	cth34/cth34.preproc/'stats.34+tlrc[25]' \
cth34	1.096803562	0.7458564	Sine	step1	cth34/cth34.preproc/'stats.34+tlrc[4]' \
cth34	1.096803562	0.7458564	Sine	step3	cth34/cth34.preproc/'stats.34+tlrc[7]' \
cth34	1.096803562	0.7458564	Sine	step5	cth34/cth34.preproc/'stats.34+tlrc[10]' \
cth34	1.096803562	0.7458564	Sine	step7	cth34/cth34.preproc/'stats.34+tlrc[13]' 