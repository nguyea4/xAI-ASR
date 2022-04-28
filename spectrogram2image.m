% Converts original unperturbed dataset into a short time fourier transform
% data that will act synonymously to an array of pixels in an image.
clear all
close all
verbose = true;
name = '2830-3980-0043_TDI_Acc_5.76';
filename = append('./audio/',name,'.wav');

[orig_signal, fs] = audioread(filename); % for our own purposes
N = length(orig_signal);
% Make it one channel if its more than one
if size(orig_signal,2) > 1
    orig_signal = orig_signal(:,1);
end

% Get short time fourier transform.  --- The below are hyper parameters
% SPECTROGRAM(X,WINDOW,NOVERLAP,NFFT,Fs)
window = 128;
noverlap = 32;
NFFT = round(N/32);
S = stft(orig_signal,fs, 'Window', hamming(window,'periodic'),'OverlapLength',noverlap, 'FrequencyRange', 'onesided', 'FFTLENGTH', NFFT);

% Save data for next program
save(append('./temp/stft_',name,'.mat'));


%S = spectrogram(orig_signal,window,noverlap,NFFT,fs, 'yaxis'); spectrogram
%doesnt have inverse
if verbose
    % Play inverse and save a test file
    % 1:41, 121:151 is counterfactual
    row_range = 69:88; % y range
    col_range = 173:192; % x range
    S(row_range,col_range) = zeros([length(row_range),length(col_range)]);
    x_test = real(istft(S, fs, 'Window', hamming(window,'periodic'),'OverlapLength',noverlap,'FrequencyRange', 'onesided',  'FFTLENGTH', NFFT));
    sound(x_test,fs) 
    audiowrite('./audio/nophasetest.wav',x_test,fs);
    
    % 
    figure % Plot it for visualization
    spectrogram(orig_signal,window,noverlap,NFFT,fs, 'yaxis');
    title("Original signal")
end

% Get magnitude for a grey scale image. ------ CAN JUST USE STFT DIRECTLY
S_abs = abs(S);% absolute of spectrogram
S_max = max(S_abs,[],'all'); % max value in S
S_normalized = S_abs/(S_max); % all values are between 0 and 1
S_grey_c = S_normalized*255; % all values are continous between 0 and 255
S_grey_d = round(S_grey_c); % all values are quantized between 0 and 255
if verbose
    figure
    imshow(S_grey_d,[]) % plots grey scale
    %imshow(S_grey_d) % Plots black or white
    title("Greyscale representation")
end

% reconstruct sample audio clip from spectrogram
