#!/bin/csh -f

#  for sine, "[4]=sinestep1; "[7]=sinestep3; "[10]=sinestep5; "[13]=sinestep7;
#  for vowel, "[16]=vowelstep1; "[19]=vowelstep3; "[22]=vowelstep5; "[25]=vowelstep7;


set top_dir = /Volumes/netapp/Myerslab/Dave/Cthulhu/data 
cd top_dir

3dMVM \
-prefix $top_dir/group/ANCOVA \
-bsVars "Accuracy" \
-wsVars "SoundType*Step" \
-qVars "Accuracy" \
-jobs 3 \
-num_glt 1 \
-gltLabel 1 VowelvsSine-accuracy -gltCode 1 'SoundType: 1*Vowel -1*Sine Accuracy:' \
-GES \
-dataTable \
Subj	Accuracy	Step	SoundType	InputFile \
cth1	1.000000	1	Vowel	$top_dir/cth1/cth1.preproc/stats.1+tlrc"[16]" \
cth1	1.000000	3	Vowel	$top_dir/cth1/cth1.preproc/stats.1+tlrc"[19]" \
cth1	1.000000	5	Vowel	$top_dir/cth1/cth1.preproc/stats.1+tlrc"[22]" \
cth1	1.000000	7	Vowel	$top_dir/cth1/cth1.preproc/stats.1+tlrc"[25]" \
cth10	0.5801105	1	Vowel	$top_dir/cth10/cth10.preproc/stats.10+tlrc"[16]" \
cth10	0.5801105	3	Vowel	$top_dir/cth10/cth10.preproc/stats.10+tlrc"[19]" \
cth10	0.5801105	5	Vowel	$top_dir/cth10/cth10.preproc/stats.10+tlrc"[22]" \
cth10	0.5801105	7	Vowel	$top_dir/cth10/cth10.preproc/stats.10+tlrc"[25]" \
cth11	0.9833333	1	Vowel	$top_dir/cth11/cth11.preproc/stats.11+tlrc"[16]" \
cth11	0.9833333	3	Vowel	$top_dir/cth11/cth11.preproc/stats.11+tlrc"[19]" \
cth11	0.9833333	5	Vowel	$top_dir/cth11/cth11.preproc/stats.11+tlrc"[22]" \
cth11	0.9833333	7	Vowel	$top_dir/cth11/cth11.preproc/stats.11+tlrc"[25]" \
cth12	0.8181818	1	Vowel	$top_dir/cth12/cth12.preproc/stats.12+tlrc"[16]" \
cth12	0.8181818	3	Vowel	$top_dir/cth12/cth12.preproc/stats.12+tlrc"[19]" \
cth12	0.8181818	5	Vowel	$top_dir/cth12/cth12.preproc/stats.12+tlrc"[22]" \
cth12	0.8181818	7	Vowel	$top_dir/cth12/cth12.preproc/stats.12+tlrc"[25]" \
cth14	0.875000	1	Vowel	$top_dir/cth14/cth14.preproc/stats.14+tlrc"[16]" \
cth14	0.875000	3	Vowel	$top_dir/cth14/cth14.preproc/stats.14+tlrc"[19]" \
cth14	0.875000	5	Vowel	$top_dir/cth14/cth14.preproc/stats.14+tlrc"[22]" \
cth14	0.875000	7	Vowel	$top_dir/cth14/cth14.preproc/stats.14+tlrc"[25]" \
cth15	0.7348066	1	Vowel	$top_dir/cth15/cth15.preproc/stats.15+tlrc"[16]" \
cth15	0.7348066	3	Vowel	$top_dir/cth15/cth15.preproc/stats.15+tlrc"[19]" \
cth15	0.7348066	5	Vowel	$top_dir/cth15/cth15.preproc/stats.15+tlrc"[22]" \
cth15	0.7348066	7	Vowel	$top_dir/cth15/cth15.preproc/stats.15+tlrc"[25]" \
cth16	1.000000	1	Vowel	$top_dir/cth16/cth16.preproc/stats.16+tlrc"[16]" \
cth16	1.000000	3	Vowel	$top_dir/cth16/cth16.preproc/stats.16+tlrc"[19]" \
cth16	1.000000	5	Vowel	$top_dir/cth16/cth16.preproc/stats.16+tlrc"[22]" \
cth16	1.000000	7	Vowel	$top_dir/cth16/cth16.preproc/stats.16+tlrc"[25]" \
cth17	0.875000	1	Vowel	$top_dir/cth17/cth17.preproc/stats.17+tlrc"[16]" \
cth17	0.875000	3	Vowel	$top_dir/cth17/cth17.preproc/stats.17+tlrc"[19]" \
cth17	0.875000	5	Vowel	$top_dir/cth17/cth17.preproc/stats.17+tlrc"[22]" \
cth17	0.875000	7	Vowel	$top_dir/cth17/cth17.preproc/stats.17+tlrc"[25]" \
cth18	0.8232044	1	Vowel	$top_dir/cth18/cth18.preproc/stats.18+tlrc"[16]" \
cth18	0.8232044	3	Vowel	$top_dir/cth18/cth18.preproc/stats.18+tlrc"[19]" \
cth18	0.8232044	5	Vowel	$top_dir/cth18/cth18.preproc/stats.18+tlrc"[22]" \
cth18	0.8232044	7	Vowel	$top_dir/cth18/cth18.preproc/stats.18+tlrc"[25]" \
cth2	0.8066298	1	Vowel	$top_dir/cth2/cth2.preproc/stats.2+tlrc"[16]" \
cth2	0.8066298	3	Vowel	$top_dir/cth2/cth2.preproc/stats.2+tlrc"[19]" \
cth2	0.8066298	5	Vowel	$top_dir/cth2/cth2.preproc/stats.2+tlrc"[22]" \
cth2	0.8066298	7	Vowel	$top_dir/cth2/cth2.preproc/stats.2+tlrc"[25]" \
cth20	0.9166667	1	Vowel	$top_dir/cth20/cth20.preproc/stats.20+tlrc"[16]" \
cth20	0.9166667	3	Vowel	$top_dir/cth20/cth20.preproc/stats.20+tlrc"[19]" \
cth20	0.9166667	5	Vowel	$top_dir/cth20/cth20.preproc/stats.20+tlrc"[22]" \
cth20	0.9166667	7	Vowel	$top_dir/cth20/cth20.preproc/stats.20+tlrc"[25]" \
cth21	0.9666667	1	Vowel	$top_dir/cth21/cth21.preproc/stats.21+tlrc"[16]" \
cth21	0.9666667	3	Vowel	$top_dir/cth21/cth21.preproc/stats.21+tlrc"[19]" \
cth21	0.9666667	5	Vowel	$top_dir/cth21/cth21.preproc/stats.21+tlrc"[22]" \
cth21	0.9666667	7	Vowel	$top_dir/cth21/cth21.preproc/stats.21+tlrc"[25]" \
cth22	0.7900552	1	Vowel	$top_dir/cth22/cth22.preproc/stats.22+tlrc"[16]" \
cth22	0.7900552	3	Vowel	$top_dir/cth22/cth22.preproc/stats.22+tlrc"[19]" \
cth22	0.7900552	5	Vowel	$top_dir/cth22/cth22.preproc/stats.22+tlrc"[22]" \
cth22	0.7900552	7	Vowel	$top_dir/cth22/cth22.preproc/stats.22+tlrc"[25]" \
cth24	0.5359116	1	Vowel	$top_dir/cth24/cth24.preproc/stats.24+tlrc"[16]" \
cth24	0.5359116	3	Vowel	$top_dir/cth24/cth24.preproc/stats.24+tlrc"[19]" \
cth24	0.5359116	5	Vowel	$top_dir/cth24/cth24.preproc/stats.24+tlrc"[22]" \
cth24	0.5359116	7	Vowel	$top_dir/cth24/cth24.preproc/stats.24+tlrc"[25]" \
cth25	0.6850829	1	Vowel	$top_dir/cth25/cth25.preproc/stats.25+tlrc"[16]" \
cth25	0.6850829	3	Vowel	$top_dir/cth25/cth25.preproc/stats.25+tlrc"[19]" \
cth25	0.6850829	5	Vowel	$top_dir/cth25/cth25.preproc/stats.25+tlrc"[22]" \
cth25	0.6850829	7	Vowel	$top_dir/cth25/cth25.preproc/stats.25+tlrc"[25]" \
cth3	0.968254	1	Vowel	$top_dir/cth3/cth3.preproc/stats.3+tlrc"[16]" \
cth3	0.968254	3	Vowel	$top_dir/cth3/cth3.preproc/stats.3+tlrc"[19]" \
cth3	0.968254	5	Vowel	$top_dir/cth3/cth3.preproc/stats.3+tlrc"[22]" \
cth3	0.968254	7	Vowel	$top_dir/cth3/cth3.preproc/stats.3+tlrc"[25]" \
cth6	0.852459	1	Vowel	$top_dir/cth6/cth6.preproc/stats.6+tlrc"[16]" \
cth6	0.852459	3	Vowel	$top_dir/cth6/cth6.preproc/stats.6+tlrc"[19]" \
cth6	0.852459	5	Vowel	$top_dir/cth6/cth6.preproc/stats.6+tlrc"[22]" \
cth6	0.852459	7	Vowel	$top_dir/cth6/cth6.preproc/stats.6+tlrc"[25]" \
cth8	0.8153846	1	Vowel	$top_dir/cth8/cth8.preproc/stats.8+tlrc"[16]" \
cth8	0.8153846	3	Vowel	$top_dir/cth8/cth8.preproc/stats.8+tlrc"[19]" \
cth8	0.8153846	5	Vowel	$top_dir/cth8/cth8.preproc/stats.8+tlrc"[22]" \
cth8	0.8153846	7	Vowel	$top_dir/cth8/cth8.preproc/stats.8+tlrc"[25]" \
cth9	0.9193548	1	Vowel	$top_dir/cth9/cth9.preproc/stats.9+tlrc"[16]" \
cth9	0.9193548	3	Vowel	$top_dir/cth9/cth9.preproc/stats.9+tlrc"[19]" \
cth9	0.9193548	5	Vowel	$top_dir/cth9/cth9.preproc/stats.9+tlrc"[22]" \
cth9	0.9193548	7	Vowel	$top_dir/cth9/cth9.preproc/stats.9+tlrc"[25]" \
cth1	0.9333333	1	Sine	$top_dir/cth1/cth1.preproc/stats.1+tlrc"[4]" \
cth1	0.9333333	3	Sine	$top_dir/cth1/cth1.preproc/stats.1+tlrc"[7]" \
cth1	0.933333	5	Sine	$top_dir/cth1/cth1.preproc/stats.1+tlrc"[10]" \
cth1	0.933333	7	Sine	$top_dir/cth1/cth1.preproc/stats.1+tlrc"[13]" \
cth10	0.9354839	1	Sine	$top_dir/cth10/cth10.preproc/stats.10+tlrc"[4]" \
cth10	0.9354839	3	Sine	$top_dir/cth10/cth10.preproc/stats.10+tlrc"[7]" \
cth10	0.935484	5	Sine	$top_dir/cth10/cth10.preproc/stats.10+tlrc"[10]" \
cth10	0.935484	7	Sine	$top_dir/cth10/cth10.preproc/stats.10+tlrc"[13]" \
cth11	0.9833333	1	Sine	$top_dir/cth11/cth11.preproc/stats.11+tlrc"[4]" \
cth11	0.9833333	3	Sine	$top_dir/cth11/cth11.preproc/stats.11+tlrc"[7]" \
cth11	0.983333	5	Sine	$top_dir/cth11/cth11.preproc/stats.11+tlrc"[10]" \
cth11	0.983333	7	Sine	$top_dir/cth11/cth11.preproc/stats.11+tlrc"[13]" \
cth12	0.5801105	1	Sine	$top_dir/cth12/cth12.preproc/stats.12+tlrc"[4]" \
cth12	0.5801105	3	Sine	$top_dir/cth12/cth12.preproc/stats.12+tlrc"[7]" \
cth12	0.580111	5	Sine	$top_dir/cth12/cth12.preproc/stats.12+tlrc"[10]" \
cth12	0.580111	7	Sine	$top_dir/cth12/cth12.preproc/stats.12+tlrc"[13]" \
cth14	0.9333333	1	Sine	$top_dir/cth14/cth14.preproc/stats.14+tlrc"[4]" \
cth14	0.9333333	3	Sine	$top_dir/cth14/cth14.preproc/stats.14+tlrc"[7]" \
cth14	0.933333	5	Sine	$top_dir/cth14/cth14.preproc/stats.14+tlrc"[10]" \
cth14	0.933333	7	Sine	$top_dir/cth14/cth14.preproc/stats.14+tlrc"[13]" \
cth15	0.9666667	1	Sine	$top_dir/cth15/cth15.preproc/stats.15+tlrc"[4]" \
cth15	0.9666667	3	Sine	$top_dir/cth15/cth15.preproc/stats.15+tlrc"[7]" \
cth15	0.966667	5	Sine	$top_dir/cth15/cth15.preproc/stats.15+tlrc"[10]" \
cth15	0.966667	7	Sine	$top_dir/cth15/cth15.preproc/stats.15+tlrc"[13]" \
cth16	1.000000	1	Sine	$top_dir/cth16/cth16.preproc/stats.16+tlrc"[4]" \
cth16	1.000000	3	Sine	$top_dir/cth16/cth16.preproc/stats.16+tlrc"[7]" \
cth16	1.000000	5	Sine	$top_dir/cth16/cth16.preproc/stats.16+tlrc"[10]" \
cth16	1.000000	7	Sine	$top_dir/cth16/cth16.preproc/stats.16+tlrc"[13]" \
cth17	0.8939394	1	Sine	$top_dir/cth17/cth17.preproc/stats.17+tlrc"[4]" \
cth17	0.8939394	3	Sine	$top_dir/cth17/cth17.preproc/stats.17+tlrc"[7]" \
cth17	0.893939	5	Sine	$top_dir/cth17/cth17.preproc/stats.17+tlrc"[10]" \
cth17	0.893939	7	Sine	$top_dir/cth17/cth17.preproc/stats.17+tlrc"[13]" \
cth18	0.9508197	1	Sine	$top_dir/cth18/cth18.preproc/stats.18+tlrc"[4]" \
cth18	0.9508197	3	Sine	$top_dir/cth18/cth18.preproc/stats.18+tlrc"[7]" \
cth18	0.950820	5	Sine	$top_dir/cth18/cth18.preproc/stats.18+tlrc"[10]" \
cth18	0.950820	7	Sine	$top_dir/cth18/cth18.preproc/stats.18+tlrc"[13]" \
cth2	0.6740331	1	Sine	$top_dir/cth2/cth2.preproc/stats.2+tlrc"[4]" \
cth2	0.6740331	3	Sine	$top_dir/cth2/cth2.preproc/stats.2+tlrc"[7]" \
cth2	0.674033	5	Sine	$top_dir/cth2/cth2.preproc/stats.2+tlrc"[10]" \
cth2	0.674033	7	Sine	$top_dir/cth2/cth2.preproc/stats.2+tlrc"[13]" \
cth20	0.9666667	1	Sine	$top_dir/cth20/cth20.preproc/stats.20+tlrc"[4]" \
cth20	0.9666667	3	Sine	$top_dir/cth20/cth20.preproc/stats.20+tlrc"[7]" \
cth20	0.966667	5	Sine	$top_dir/cth20/cth20.preproc/stats.20+tlrc"[10]" \
cth20	0.966667	7	Sine	$top_dir/cth20/cth20.preproc/stats.20+tlrc"[13]" \
cth21	0.8589744	1	Sine	$top_dir/cth21/cth21.preproc/stats.21+tlrc"[4]" \
cth21	0.8589744	3	Sine	$top_dir/cth21/cth21.preproc/stats.21+tlrc"[7]" \
cth21	0.858974	5	Sine	$top_dir/cth21/cth21.preproc/stats.21+tlrc"[10]" \
cth21	0.858974	7	Sine	$top_dir/cth21/cth21.preproc/stats.21+tlrc"[13]" \
cth22	0.983871	1	Sine	$top_dir/cth22/cth22.preproc/stats.22+tlrc"[4]" \
cth22	0.983871	3	Sine	$top_dir/cth22/cth22.preproc/stats.22+tlrc"[7]" \
cth22	0.983871	5	Sine	$top_dir/cth22/cth22.preproc/stats.22+tlrc"[10]" \
cth22	0.983871	7	Sine	$top_dir/cth22/cth22.preproc/stats.22+tlrc"[13]" \
cth24	0.8066298	1	Sine	$top_dir/cth24/cth24.preproc/stats.24+tlrc"[4]" \
cth24	0.8066298	3	Sine	$top_dir/cth24/cth24.preproc/stats.24+tlrc"[7]" \
cth24	0.806630	5	Sine	$top_dir/cth24/cth24.preproc/stats.24+tlrc"[10]" \
cth24	0.806630	7	Sine	$top_dir/cth24/cth24.preproc/stats.24+tlrc"[13]" \
cth25	0.984375	1	Sine	$top_dir/cth25/cth25.preproc/stats.25+tlrc"[4]" \
cth25	0.984375	3	Sine	$top_dir/cth25/cth25.preproc/stats.25+tlrc"[7]" \
cth25	0.984375	5	Sine	$top_dir/cth25/cth25.preproc/stats.25+tlrc"[10]" \
cth25	0.984375	7	Sine	$top_dir/cth25/cth25.preproc/stats.25+tlrc"[13]" \
cth3	0.9833333	1	Sine	$top_dir/cth3/cth3.preproc/stats.3+tlrc"[4]" \
cth3	0.9833333	3	Sine	$top_dir/cth3/cth3.preproc/stats.3+tlrc"[7]" \
cth3	0.983333	5	Sine	$top_dir/cth3/cth3.preproc/stats.3+tlrc"[10]" \
cth3	0.983333	7	Sine	$top_dir/cth3/cth3.preproc/stats.3+tlrc"[13]" \
cth6	0.850000	1	Sine	$top_dir/cth6/cth6.preproc/stats.6+tlrc"[4]" \
cth6	0.850000	3	Sine	$top_dir/cth6/cth6.preproc/stats.6+tlrc"[7]" \
cth6	0.850000	5	Sine	$top_dir/cth6/cth6.preproc/stats.6+tlrc"[10]" \
cth6	0.850000	7	Sine	$top_dir/cth6/cth6.preproc/stats.6+tlrc"[13]" \
cth8	0.8955224	1	Sine	$top_dir/cth8/cth8.preproc/stats.8+tlrc"[4]" \
cth8	0.8955224	3	Sine	$top_dir/cth8/cth8.preproc/stats.8+tlrc"[7]" \
cth8	0.895522	5	Sine	$top_dir/cth8/cth8.preproc/stats.8+tlrc"[10]" \
cth8	0.895522	7	Sine	$top_dir/cth8/cth8.preproc/stats.8+tlrc"[13]" \
cth9	1.000000	1	Sine	$top_dir/cth9/cth9.preproc/stats.9+tlrc"[4]" \
cth9	1.000000	3	Sine	$top_dir/cth9/cth9.preproc/stats.9+tlrc"[7]" \
cth9	1.000000	5	Sine	$top_dir/cth9/cth9.preproc/stats.9+tlrc"[10]" \
cth9	1.000000	7	Sine	$top_dir/cth9/cth9.preproc/stats.9+tlrc"[13]" 
