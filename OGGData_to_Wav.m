filename = './audio/hiccup'; % put ogg file in audio folder and get everything but extension
[orig_signal, fs] = audioread(append(filename,'.ogg'));  % 44.1kHz
%down_signal = resample(orig_signal, 16000,fs); resampling does not work
%fs_new = 16000;
audiowrite(append(filename,'.wav'),orig_signal,fs);