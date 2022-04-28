clear all
close all

%% Parameters
%filename = './audio/2830-3980-0043.wav'; %TDI of 6.75ms worked, 2.5 ms does not work
filename = './audio/4507-16021-0012.wav';
%filename = './audio/8455-210777-0068.wav';
%filename = './audio/abuzz.wav';
%filename = './audio/badly.wav';
%filename = './audio/hicc.wav';
ext = filename(end-3:end);
params.window_length = 12*10^-3;
params.verbose = true;
attack_type = 'TDI'; % 'TDI' or 'RPG' 
[orig_signal, fs] = audioread(filename); % for our own purposes
N = length(orig_signal);
% Make it one channel
if size(orig_signal,2) == 2
    orig_signal = orig_signal(:,1);
end
save_filename = strcat(filename(1:end-4),'_',attack_type,'.wav')
[output_signal, fs] = addSigProcAttack(filename,attack_type, params);
audiowrite(save_filename, output_signal,16000);

% Spectrograms
figure
spectrogram(orig_signal,720,120, N,fs, 'yaxis');
title("Original signal")
figure
spectrogram(output_signal,720,120, N,fs,'yaxis');
title("output signal")