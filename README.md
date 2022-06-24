# xAI-ASR
Explainable AI in Automatic Speech Recognition Attacks

Goal of this project is to successfully generate signal processing attacks on automatic speech recognition systems(ASR). What the project does new is applying explainable AI counterfactuals, originally used in the image domain, into the audio domain. The counterfactuals creates multiple perturbed signals that varied slightly based on either altering specific segments. Segments, when removed, changed the output are considered pertinent positives: segments necessary for the classification. Future work can search for pertinent negatives, the segments that when have additive information will result in a changed output, so the absence of that part of the spectrogram is necessary. After finding those two, pertinnet neutrals can be found that should be able to have additive nosie(that distrub the human perception) without affecting classification.

To install deepspeech:
- Getting prebuilt Mozzilla Deepspech model from https://deepspeech.readthedocs.io/en/r0.9/USING.html
- wget https://github.com/mozilla/DeepSpeech/releases/download/v0.9.3/deepspeech-0.9.3-models.pbmm
- wget https://github.com/mozilla/DeepSpeech/releases/download/v0.9.3/deepspeech-0.9.3-models.scorer
- Creating virtual environment: virtualenv -p python3 $HOME/tmp/deepspeech-venv/
- Run virtual environment: source $HOME/tmp/deepspeech-venv/bin/activate
- Install deepspeech package: pip3 install deepspeech
- You can run deepspeech program: deepspeech --model deepspeech-0.9.3-models.pbmm --scorer deepspeech-0.9.3-models.scorer --audio my_audio_file.wav

Open WSL command prompt at the main folder
Run the virtual environment: source $HOME/tmp/deepspeech-venv/bin/activate

(Optional) Preprocessing
if the audio file is an OGG file 
- edit filename in OGGData_to_Wav.m file to produce OGG file to WAV file.

To use Signal Processing attack an audio file
- go to testSigProcattack.m: 
- edit parameters: filename, window_length, verbose, attack_type
- This runs addSigProcAttack.m that adds attack type of  Time domain inversion and Random phase generation (addTDI.m and addRPG.m)
- This saves it as filename_attacktype.wav file


Convert audio file( I used the signal processing attack) to shorttime fourier transform(data from spectrogram) data:
- Go to spectrogram2image.m
- Edit parameters like verbose and name like true and '2830-3980-0043_TDI_Acc_5.76'
- STFT parameters include window, noverlap, and NFFT
- Saves spectrogram and many other variables into "./temp/stft_name.mat"
- Verbose allows sound + spectrogram and graphs

Create search for evidence counterfactual. This creates multiple perturbations by shifting an M x M segment and removing that signal and storing multiple of those. For future, improved segments could be used.
- go to sedc.m
- Edit parameters for name and M size segment of the audio file like name = '2830-3980-0043_TDI_Acc_5.76' and M = 20
- This program will write many modified audio file in ./temp/name_number.wav


After creating many perturbed signals, run the bashscript to run the deepspeech program on it
- I had troubles running perturb2ds.sh bash script file, so I made a one liner to execute on wsl. Modify the number (below is 11067) for the number of items 
- 

`x=1; while [ $x -le 11067 ]; do deepspeech --model deepspeech-0.9.3-models.pbmm --scorer deepspeech-0.9.3-models.scorer  --audio temp/name_$x.wav  --json --candidate_transcripts 1 > temp/out_2830-3980-0043_TDI_Acc_5.76_$x.txt; x=$(( $x+1 )); done `

- Saves text file containing json output in temp/out_name_number.txt


After getting output of perturbed signal, you get confidence score and the words transcribed,
- Use json2counterfactual.m 
- edit parameters like name, ext, and actual transcription of result and the number of files as well
- After running, it will highlight the segments of the spectrogram that are pertinent positives: the segments necessary for the input to be classified as the actual transcription. Without these segments, the classification will be incorrect
- Future work can include finding pertinent negatives and eventually the neutrals that can be used to formulate attacks without changing classification.










