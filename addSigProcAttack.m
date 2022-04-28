% Orig file as '.wav'
% Attack_type as
%   'TDI': time domain inversion
%   'RPG': random phase generation
%   'HFA': High frequency addition
%   'TS': Time Scaling
function [output_signal, fs] = addSigProcAttack(orig_file, attack_type, params)
if ~exist('params','var')
    params.window_length = 2*10^-3; % Default it to 2 ms
    params.verbose = true; %For debugging, default set to true
end

verbose = params.verbose;


% Load wav file 
[orig_signal, fs] = audioread(orig_file);
% Make it one channel
if size(orig_signal,2) == 2
    orig_signal = orig_signal(:,1);
end
% out = audioplayer(orig_signal, fs);
% play(out);


% Add respective attack type
switch attack_type
    case 'TDI'
        window_size = round(params.window_length*fs); %Edit window size length
        [output_signal, fs] = addTDI(orig_signal,fs, window_size);
    case 'RPG'
        window_size = round(params.window_length*fs); % Variable window size
        [output_signal, fs] = addRPG(orig_signal,fs, window_size);
    case 'HFA'
    case 'TS'
end
if verbose
    sound(output_signal,fs)            
    figure
    t = (0:length(orig_signal)-1)/fs;
    plot(t,orig_signal); hold on;
    plot(t,output_signal);
    legend(["orig",attack_type])
    title("Time-domain of audio samples")
end

end