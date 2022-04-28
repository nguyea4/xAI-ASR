#!/bin/bash
# This is a bash script to run deepspeech on all the perturbed signals
# has the good commands
# 2830-3980-0043_TDI_Acc_5.76_1.wav -> 2830-3980-0043_TDI_Acc_5.76_11067.wav
# Save output to 2830-3980-0043_TDI_Acc_5.76_1.txt -> 2830-3980-0043_TDI_Acc_5.76_11067.txt
# its spacing sensitive oh no
# for oneliner: x=1; while [ $x -le 3 ]; do deepspeech --model deepspeech-0.9.3-models.pbmm --scorer deepspeech-0.9.3-models.scorer  --audio temp/2830-3980-0043_TDI_Acc_5.76_$x.wav  --json --candidate_transcripts 1 > temp/out_2830-3980-0043_TDI_Acc_5.76_$x.txt; x=$(( $x+1 )); done 
x=1
max=$1
while [ $x -le max ]
do  
 deepspeech --model deepspeech-0.9.3-models.pbmm --scorer deepspeech-0.9.3-models.scorer  --audio temp/2830-3980-0043_TDI_Acc_5.76_$x.wav  --json --candidate_transcripts 1 > temp/out_2830-3980-0043_TDI_Acc_5.76_$x.txt
 x=$(($x+1))
done 