% SEDC: Search for Evidence Counterfactual
% Produce many perturbed spectrograms and save them
clear all
close all

name = '2830-3980-0043_TDI_Acc_5.76'
load(append('./temp/stft_',name,'.mat')) % get original signal, STFT and its parameters
sz = size(S)
% use square array of pixels of size M x M for superpixel segments
M = 20;
% define starting index for horizontal (h) and vertical (v)
x_left = 1;
x_right = M;
y_left = 1;
y_right = M;
step_size = 4;
counter = 0; % count the number of perturbation
while x_right <=390 && y_right <=587
    % create pertubred audio signal and save it
    temp = S;
    counter = counter + 1; % increment the count
    temp(y_left:y_right,x_left:x_right) = zeros([M,M]);
    perturb_sig =  real(istft(temp, fs, 'Window', hamming(window,'periodic'),'OverlapLength',noverlap,'FrequencyRange', 'onesided',  'FFTLENGTH', NFFT));
    audiowrite(append('./temp/',name,'_',int2str(counter),'.wav'),perturb_sig,fs);
    
    % Update index by sliding to the right
    x_left = x_left + step_size;
    x_right = x_right + step_size;
    y_left = y_left;
    y_right = y_right;
    
    % if x_right is past the size
    if x_right > 390
        % shift down a row back to left sie
        x_left = 1;
        x_right = M;
        y_left = y_left  + step_size; 
        y_right = y_right + step_size;
    end
end